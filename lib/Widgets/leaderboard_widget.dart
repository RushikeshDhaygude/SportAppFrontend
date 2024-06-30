import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Api/api_constants.dart';

class LeaderboardWidget extends StatelessWidget {
  final int eventId;

  LeaderboardWidget({required this.eventId});

  Future<List<dynamic>> fetchLeaderboard() async {
    try {
      final response =
          await http.get(Uri.parse('${ApiConstants.leaderboard}/$eventId'));

      if (response.statusCode == 200) {
        List<dynamic> leaderboard = json.decode(response.body);
        // Sort by total points in descending order
        leaderboard
            .sort((a, b) => b['totalPoints'].compareTo(a['totalPoints']));
        return leaderboard;
      } else {
        throw Exception('Failed to load leaderboard');
      }
    } catch (e) {
      print('Error fetching leaderboard data: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchLeaderboard(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No leaderboard data available'));
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Rank')),
                DataColumn(label: Text('Team Name')),
                DataColumn(label: Text('Matches Played')),
                DataColumn(label: Text('Matches Won')),
                DataColumn(label: Text('Matches Lost')),
                DataColumn(label: Text('Total Points')),
              ],
              rows: List<DataRow>.generate(
                snapshot.data!.length,
                (index) {
                  final entry = snapshot.data![index];
                  return DataRow(cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(Text(entry['teamName'].trim())),
                    DataCell(Text('${entry['matchesPlayed']}')),
                    DataCell(Text('${entry['matchesWon']}')),
                    DataCell(Text('${entry['matchesLost']}')),
                    DataCell(Text('${entry['totalPoints']}')),
                  ]);
                },
              ),
            ),
          );
        }
      },
    );
  }
}
