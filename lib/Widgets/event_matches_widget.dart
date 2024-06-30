import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Api/api_constants.dart';

class EventMatchesWidget extends StatelessWidget {
  final int eventId;

  EventMatchesWidget({required this.eventId});

  Future<List<dynamic>> fetchMatches() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}?eventId=$eventId'));

      if (response.statusCode == 200) {
        List<dynamic> matches = json.decode(response.body);
        // Filter matches based on eventId
        matches = matches.where((match) => match['event']['id'] == eventId).toList();
        return matches;
      } else {
        throw Exception('Failed to load matches');
      }
    } catch (e) {
      print('Error fetching matches data: $e');
      throw e;
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
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return buildMatchCard(snapshot.data![index]);
            },
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

    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  eventName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(gender),
                  backgroundColor: Colors.blueAccent,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Divider(color: Colors.grey[300]),
            buildInfoRow(Icons.location_on, 'Location', location),
            buildInfoRow(Icons.calendar_today, 'Date', date),
            buildInfoRow(Icons.access_time, 'Time', time),
            buildInfoRow(Icons.sports_volleyball_sharp , 'Match', '$team1Name vs $team2Name'),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value, style: TextStyle(color: Colors.grey[700]))),
        ],
      ),
    );
  }
}
