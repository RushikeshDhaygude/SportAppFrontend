import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../Api/api_constants.dart';

class ResultsWidget extends StatelessWidget {
  final int eventId;

  ResultsWidget({required this.eventId});

  Future<List<dynamic>> fetchResults() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.finalScorecards}/$eventId'));

      if (response.statusCode == 200) {
        List<dynamic> results = json.decode(response.body);
        return results;
      } else {
        throw Exception('Failed to load results');
      }
    } catch (e) {
      print('Error fetching results data: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchResults(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results data available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return buildResultCard(snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  Widget buildResultCard(Map<String, dynamic> result) {
    String team1Name = (result['team1']['teamName'] ?? 'Unknown Team 1').trim();
    String team2Name = (result['team2']['teamName'] ?? 'Unknown Team 2').trim();
    String matchResult = result['matchResult'] ?? 'No result';
    String team1Score = result['team1Score']?.toString() ?? 'N/A';
    String team2Score = result['team2Score']?.toString() ?? 'N/A';
    String matchDetails = result['matchDetails'] ?? 'No details available';
    String eventLocation = result['eventLocation'] ?? 'Unknown location';
    String eventDateTime = result['eventDate'] ?? 'Unknown date';
    
    // Parse the date and time
    DateTime parsedDateTime = DateTime.tryParse(eventDateTime) ?? DateTime.now();
    String formattedDate = DateFormat.yMMMd().format(parsedDateTime);
    String formattedTime = DateFormat.jm().format(parsedDateTime);

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
            Text(
              '$team1Name vs $team2Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.grey[300]),
            buildInfoRow(Icons.sports_score, 'Result', matchResult),
            buildInfoRow(Icons.score, 'Score', '$team1Score - $team2Score'),
            buildInfoRow(Icons.info, 'Details', matchDetails),
            buildInfoRow(Icons.location_on, 'Location', eventLocation),
            buildInfoRow(Icons.calendar_today, 'Date', formattedDate),
            buildInfoRow(Icons.access_time, 'Time', formattedTime),
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
