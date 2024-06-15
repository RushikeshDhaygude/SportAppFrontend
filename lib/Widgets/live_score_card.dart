import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../Api/api_constants.dart';

class LiveScorecardWidget extends StatefulWidget {
  @override
  _LiveScorecardWidgetState createState() => _LiveScorecardWidgetState();
}

class _LiveScorecardWidgetState extends State<LiveScorecardWidget> {
  late StompClient stompClient;
  List<Scorecard> scorecards = [];

  @override
  void initState() {
    super.initState();
    // Initialize StompClient and connect to WebSocket server
    stompClient = StompClient(
      config: StompConfig(
        url: ApiConstants.socketAddress,
        onConnect: onConnectCallback,
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
        stompConnectHeaders: {'Authorization': 'Bearer your_token'},
      ),
    );
    stompClient.activate();
  }

  void onConnectCallback(StompFrame? frame) {
    print('Connected to WebSocket');
    // Subscribe to the desired topic
    stompClient.subscribe(
      destination: '/topic/score-updates',
      callback: (StompFrame frame) {
        print('Received message: ${frame.body}');
        // Parse the incoming message and update the state
        setState(() {
          Map<String, dynamic> data = json.decode(frame.body ?? '{}');
          Scorecard scorecard = Scorecard.fromJson(data);

          int index = scorecards.indexWhere((card) => card.id == scorecard.id);

          if (index != -1) {
            // Update existing scorecard
            scorecards[index] = scorecard;
          } else {
            // Add new scorecard
            scorecards.add(scorecard);
          }
        });
      },
    );
  }

  @override
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Set a fixed height for the horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: scorecards.length,
        itemBuilder: (context, index) {
          return ScorecardWidget(scorecard: scorecards[index]);
        },
      ),
    );
  }
}

class Scorecard {
  final int id;
  final String team1Name;
  final String team2Name;
  final String team1LogoPath;
  final String team2LogoPath;
  final String matchResult;
  final String team1Score;
  final String team2Score;
  final String location;
  final String matchDetails;
  final String eventName;

  Scorecard({
    required this.id,
    required this.team1Name,
    required this.team2Name,
    required this.team1LogoPath,
    required this.team2LogoPath,
    required this.matchResult,
    required this.team1Score,
    required this.team2Score,
    required this.location,
    required this.matchDetails,
    required this.eventName,
  });

  factory Scorecard.fromJson(Map<String, dynamic> json) {
    return Scorecard(
      id: json['id'],
      team1Name: json['team1']['teamName']?.trim() ?? '',
      team2Name: json['team2']['teamName']?.trim() ?? '',
      team1LogoPath: json['team1']['teamLogoPath'] ?? '',
      team2LogoPath: json['team2']['teamLogoPath'] ?? '',
      matchResult: json['matchResult'] ?? '',
      team1Score: json['team1Score'] ?? '',
      team2Score: json['team2Score'] ?? '',
      location: json['event']['location'] ?? '',
      matchDetails: json['matchDetails'] ?? '',
      eventName: json['event']['eventName'] ?? '',
    );
  }
}

class ScorecardWidget extends StatelessWidget {
  final Scorecard scorecard;

  ScorecardWidget({required this.scorecard});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Set a fixed width for each scorecard
      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        // Wrap content in SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Scorecard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Event: ${scorecard.eventName}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Match: ${scorecard.team1Name} vs ${scorecard.team2Name}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Score: ${scorecard.team1Name}: ${scorecard.team1Score} - ${scorecard.team2Name}: ${scorecard.team2Score}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${scorecard.location}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Details: ${scorecard.matchDetails}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Result: ${scorecard.matchResult}',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
