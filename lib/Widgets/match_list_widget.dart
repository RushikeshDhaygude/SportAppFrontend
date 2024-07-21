import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Api/api_constants.dart';

class MatchListWidget extends StatelessWidget {
  Future<List<dynamic>> fetchMatches() async {
    final response = await http.get(Uri.parse(ApiConstants.UpcomingMatchesApiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load matches');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchMatches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No matches available'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0), // Add padding around the ListView
            child: SizedBox(
              height: 250.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data!.map((match) {
                  return buildMatchCard(match);
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildMatchCard(Map<String, dynamic> match) {
    String eventName = match['event']['eventName'];
    String location = match['event']['location'];
    String dateTime = match['dateTime'];
    String date = dateTime.split('T')[0];
    String time = dateTime.split('T')[1].split('.')[0]; // Extract time without milliseconds
    String team1Name = match['team1']['teamName'].trim();
    String team2Name = match['team2']['teamName'].trim();
    String team1LogoPath = match['team1']['teamLogoPath'];
    String team2LogoPath = match['team2']['teamLogoPath'];
    String gender = match['gender'];

    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(eventName),
            SizedBox(height: 14),
            buildDetailRow(Icons.location_on, location),
            SizedBox(height: 8),
            buildDetailRow(Icons.calendar_today, date),
            SizedBox(height: 8),
            buildDetailRow(Icons.access_time, time),
            SizedBox(height: 8),
            buildTeamRow(team1Name, team1LogoPath, team2Name, team2LogoPath),
            SizedBox(height: 8),
            buildDetailRow(Icons.person, 'Gender: $gender'),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(String eventName) {
    return Row(
      children: [
        Icon(Icons.event, color: Colors.blue),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            eventName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget buildDetailRow(IconData icon, String detail) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            detail,
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget buildTeamRow(String team1Name, String team1LogoPath, String team2Name, String team2LogoPath) {
    return Row(
      children: [
        ClipOval(
          child: Image.network(
            team1LogoPath,
            width: 24,
            height: 24,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image_not_supported, size: 24);
            },
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            '$team1Name vs $team2Name',
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8),
        ClipOval(
          child: Image.network(
            team2LogoPath,
            width: 24,
            height: 24,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image_not_supported, size: 24);
            },
          ),
        ),
      ],
    );
  }
}
