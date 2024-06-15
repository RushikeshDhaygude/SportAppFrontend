// import 'dart:convert';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Api/api_constants.dart';

class MatchListWidget extends StatelessWidget {
  // final String apiUrl = 'http://192.168.65.73:8080/api/fixtures'; // Update with your API URL

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
          return SizedBox(
            height: 250.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data!.map((match) {
                return buildMatchCard(match);
              }).toList(),
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
    String time = dateTime.split('T')[1];
    String team1Name = match['team1']['teamName'].trim();
    String team2Name = match['team2']['teamName'].trim();
    String gender = match['gender'];

    return Container(
      width: 210,
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
            SizedBox(height: 16),
            Text(
              eventName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 14),
            Text(
              'Location: $location',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Date: $date',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Time: $time',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '$team1Name vs $team2Name',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Gender: $gender',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
