// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class LeaderboardWidget extends StatefulWidget {
//   final int eventId;
//   final bool isAdmin;

//   LeaderboardWidget({required this.eventId, required this.isAdmin});

//   @override
//   _LeaderboardWidgetState createState() => _LeaderboardWidgetState();
// }

// class _LeaderboardWidgetState extends State<LeaderboardWidget> {
//   List<Map<String, dynamic>> leaderboardData = [];
//   List<Map<String, dynamic>> temporaryTeams = [];
//   int? leaderboardId;

//   Future<void> fetchLeaderboard() async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://sportappapi-production.up.railway.app/api/leaderboards/${widget.eventId}'),
//       );

//       if (response.statusCode == 200) {
//         var leaderboard = json.decode(response.body);

//         if (leaderboard != null && leaderboard['event'] != null && leaderboard['event']['id'] == widget.eventId) {
//           leaderboardId = leaderboard['id'];
//           var teamScores = leaderboard['teamScores'];
//           if (teamScores is List) {
//             teamScores.sort((a, b) => b['totalPoints'].compareTo(a['totalPoints']));
//             setState(() {
//               leaderboardData = teamScores.cast<Map<String, dynamic>>();
//             });
//           } else {
//             setState(() {
//               leaderboardData = [];
//             });
//           }
//         } else {
//           setState(() {
//             leaderboardData = [];
//           });
//         }
//       } else if (response.statusCode == 404) {
//         setState(() {
//           leaderboardData = [];
//         });
//       } else {
//         setState(() {
//           leaderboardData = [];
//         });
//       }
//     } catch (e) {
//       setState(() {
//         leaderboardData = [];
//       });
//     }
//   }

//   Future<void> addTeams(List<Map<String, dynamic>> teams) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');

//       if (token == null) {
//         throw Exception('Token not found');
//       }

//       Map<String, dynamic> requestBody = {
//         'eventId': widget.eventId,
//         'teamScores': teams,
//       };

//       final response = await http.post(
//         Uri.parse('https://sportappapi-production.up.railway.app/api/leaderboards'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           temporaryTeams.clear();
//         });
//         await fetchLeaderboard();
//       } else if (response.statusCode == 403) {
//         throw Exception('Forbidden: Ensure you have the correct permissions.');
//       } else {
//         throw Exception('Failed to add teams');
//       }
//     } catch (e) {
//       print('Error adding teams: $e');
//     }
//   }

//   Future<void> deleteLeaderboard() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');

//       if (token == null) {
//         throw Exception('Token not found');
//       }

//       final response = await http.delete(
//         Uri.parse('https://sportappapi-production.up.railway.app/api/leaderboards/$leaderboardId'),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 204) {
//         setState(() {
//           leaderboardData.clear();
//         });
//       } else {
//         throw Exception('Failed to delete leaderboard');
//       }
//     } catch (e) {
//       print('Error deleting leaderboard: $e');
//     }
//   }

//   void _showAddTeamDialog() {
//     final TextEditingController teamIdController = TextEditingController();
//     final TextEditingController matchesPlayedController = TextEditingController();
//     final TextEditingController matchesWonController = TextEditingController();
//     final TextEditingController matchesLostController = TextEditingController();
//     final TextEditingController totalPointsController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add Team'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: teamIdController,
//                   decoration: InputDecoration(labelText: 'Team ID'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: matchesPlayedController,
//                   decoration: InputDecoration(labelText: 'Matches Played'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: matchesWonController,
//                   decoration: InputDecoration(labelText: 'Matches Won'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: matchesLostController,
//                   decoration: InputDecoration(labelText: 'Matches Lost'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: totalPointsController,
//                   decoration: InputDecoration(labelText: 'Total Points'),
//                   keyboardType: TextInputType.number,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   temporaryTeams.add({
//                     'teamId': int.parse(teamIdController.text),
//                     'matchesPlayed': int.parse(matchesPlayedController.text),
//                     'matchesWon': int.parse(matchesWonController.text),
//                     'matchesLost': int.parse(matchesLostController.text),
//                     'totalPoints': int.parse(totalPointsController.text),
//                   });
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showEditTeamDialog(int index, Map<String, dynamic> team, bool isTemporary) {
//     final TextEditingController matchesPlayedController = TextEditingController(text: team['matchesPlayed'].toString());
//     final TextEditingController matchesWonController = TextEditingController(text: team['matchesWon'].toString());
//     final TextEditingController matchesLostController = TextEditingController(text: team['matchesLost'].toString());
//     final TextEditingController totalPointsController = TextEditingController(text: team['totalPoints'].toString());

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit Team'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: matchesPlayedController,
//                   decoration: InputDecoration(labelText: 'Matches Played'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: matchesWonController,
//                   decoration: InputDecoration(labelText: 'Matches Won'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: matchesLostController,
//                   decoration: InputDecoration(labelText: 'Matches Lost'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: totalPointsController,
//                   decoration: InputDecoration(labelText: 'Total Points'),
//                   keyboardType: TextInputType.number,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   final updatedTeam = {
//                     'eventId': widget.eventId,
//                     'teamId': team['teamId'],
//                     'matchesPlayed': int.parse(matchesPlayedController.text),
//                     'matchesWon': int.parse(matchesWonController.text),
//                     'matchesLost': int.parse(matchesLostController.text),
//                     'totalPoints': int.parse(totalPointsController.text),
//                   };
//                   if (isTemporary) {
//                     temporaryTeams[index] = updatedTeam;
//                   } else {
//                     leaderboardData[index] = updatedTeam;
//                   }
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchLeaderboard();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minWidth: MediaQuery.of(context).size.width,
//               ),
//               child: DataTable(
//                 columnSpacing: 20.0,
//                 columns: [
//                   DataColumn(label: Text('Team')),
//                   DataColumn(label: Text('Played')),
//                   DataColumn(label: Text('Won')),
//                   DataColumn(label: Text('Lost')),
//                   DataColumn(label: Text('Points')),
//                 ],
//                 rows: [
//                   ...leaderboardData.map((team) {
//                     return DataRow(cells: [
//                       DataCell(
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CircleAvatar(
//                               backgroundImage: team['teamLogoPath'] != null
//                                   ? NetworkImage(team['teamLogoPath'])
//                                   : null,
//                               radius: 25,
//                               child: team['teamLogoPath'] == null
//                                   ? Text('No Logo')
//                                   : null,
//                             ),
//                             SizedBox(height: 8),
//                             Text(team['teamName']),
//                           ],
//                         ),
//                       ),
//                       DataCell(Text(team['matchesPlayed'].toString())),
//                       DataCell(Text(team['matchesWon'].toString())),
//                       DataCell(Text(team['matchesLost'].toString())),
//                       DataCell(Text(team['totalPoints'].toString())),
//                     ]);
//                   }).toList(),
//                   ...temporaryTeams.asMap().entries.map((entry) {
//                     int index = entry.key;
//                     var team = entry.value;
//                     return DataRow(cells: [
//                       DataCell(
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CircleAvatar(
//                               child: Text('No Logo'),
//                               radius: 25,
//                             ),
//                             SizedBox(height: 8),
//                             Text('Temporary Team'),
//                           ],
//                         ),
//                       ),
//                       DataCell(Text(team['matchesPlayed'].toString())),
//                       DataCell(Text(team['matchesWon'].toString())),
//                       DataCell(Text(team['matchesLost'].toString())),
//                       DataCell(Text(team['totalPoints'].toString())),
//                     ]);
//                   }).toList(),
//                 ],
//               ),
//             ),
//           ),
//           if (widget.isAdmin) SizedBox(height: 20),
//           if (widget.isAdmin)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: _showAddTeamDialog,
//                   tooltip: 'Add Team',
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.save),
//                   onPressed: () async {
//                     if (temporaryTeams.isNotEmpty) {
//                       await addTeams(temporaryTeams);
//                     }
//                   },
//                   tooltip: 'Save All',
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: deleteLeaderboard,
//                   tooltip: 'Delete Leaderboard',
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Api/api_constants.dart';

// class LeaderboardWidget extends StatefulWidget {
//   final int eventId;
//   final bool isAdmin;

//   LeaderboardWidget({required this.eventId, required this.isAdmin});

//   @override
//   _LeaderboardWidgetState createState() => _LeaderboardWidgetState();
// }

// class _LeaderboardWidgetState extends State<LeaderboardWidget> {
//   List<Map<String, dynamic>> leaderboardData = [];
//   List<Map<String, dynamic>> temporaryTeams = [];

//   Future<void> fetchLeaderboard() async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://sportappapi-production.up.railway.app/api/leaderboards/${widget.eventId}'),
//       );

//       print('Response status code: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         var leaderboard = json.decode(response.body);
//         print('Response Body: ${json.encode(leaderboard)}'); // Debugging line

//         // Ensure the response is correctly structured
//         if (leaderboard != null && leaderboard['event'] != null && leaderboard['event']['id'] == widget.eventId) {
//           var teamScores = leaderboard['teamScores'];
//           if (teamScores is List) {
//             // Sort by total points in descending order
//             teamScores.sort((a, b) => b['totalPoints'].compareTo(a['totalPoints']));
//             setState(() {
//               leaderboardData = teamScores.cast<Map<String, dynamic>>();
//             });
//           } else {
//             print('teamScores is not a list'); // Debugging line
//             setState(() {
//               leaderboardData = [];
//             });
//           }
//         } else {
//           print('No matching eventLeaderboard found'); // Debugging line
//           setState(() {
//             leaderboardData = [];
//           });
//         }
//       } else if (response.statusCode == 404) {
//         print('Error: Resource not found (404). Check the URL and event ID.');
//         setState(() {
//           leaderboardData = [];
//         });
//       } else {
//         print('Error: Failed to load leaderboard. Status code: ${response.statusCode}');
//         setState(() {
//           leaderboardData = [];
//         });
//       }
//     } catch (e) {
//       print('Error fetching leaderboard data: $e');
//       setState(() {
//         leaderboardData = [];
//       });
//     }
//   }

//   Future<void> addTeams(List<Map<String, dynamic>> teams) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');

//       if (token == null) {
//         throw Exception('Token not found');
//       }

//       Map<String, dynamic> requestBody = {
//         'eventId': widget.eventId,
//         'teamScores': teams,
//       };

//       final response = await http.post(
//         Uri.parse('https://sportappapi-production.up.railway.app/api/leaderboards'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode(requestBody),
//       );

//       print('API Endpoint: https://sportappapi-production.up.railway.app/leaderboards');
//       print('Request Headers: ${response.request?.headers}');
//       print('Request Body: ${json.encode(requestBody)}');
//       print('Response Status Code: ${response.statusCode}');
//       print('Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         setState(() {
//           temporaryTeams.clear();
//         });
//         await fetchLeaderboard(); // Refetch the leaderboard after saving
//       } else if (response.statusCode == 403) {
//         throw Exception('Forbidden: Ensure you have the correct permissions.');
//       } else {
//         throw Exception('Failed to add teams');
//       }
//     } catch (e) {
//       print('Error adding teams: $e');
//     }
//   }

//   Future<void> updateTeam(int index, Map<String, dynamic> updatedTeam) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');
//       final response = await http.put(
//         Uri.parse(
//             '${ApiConstants.leaderboard}/${updatedTeam['eventId']}/${updatedTeam['teamId']}'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode(updatedTeam),
//       );
//       print('Request Body for Update: ${json.encode(updatedTeam)}');
//       print('Status Code for Update: ${response.statusCode}');
//       if (response.statusCode == 200) {
//         setState(() {
//           leaderboardData[index] = updatedTeam;
//         });
//       } else {
//         throw Exception('Failed to update team');
//       }
//     } catch (e) {
//       print('Error updating team: $e');
//     }
//   }

//   Future<void> deleteTeam(int teamId) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');
//       final response = await http.delete(
//         Uri.parse(
//             '${ApiConstants.leaderboard}/${widget.eventId}/team/${teamId}'),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );
//       print('Status Code for Delete: ${response.statusCode}');
//       if (response.statusCode == 204) {
//         setState(() {
//           leaderboardData.removeWhere((team) => team['teamId'] == teamId);
//         });
//       } else {
//         throw Exception('Failed to delete team');
//       }
//     } catch (e) {
//       print('Error deleting team: $e');
//     }
//   }

//   void _deleteTeam(int index, bool isTemporary) {
//     setState(() {
//       if (isTemporary) {
//         temporaryTeams.removeAt(index);
//       } else {
//         deleteTeam(leaderboardData[index]['teamId']);
//       }
//     });
//   }

//   void _showAddTeamDialog() {
//     final TextEditingController teamIdController = TextEditingController();
//     final TextEditingController matchesPlayedController = TextEditingController();
//     final TextEditingController matchesWonController = TextEditingController();
//     final TextEditingController matchesLostController = TextEditingController();
//     final TextEditingController totalPointsController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add Team'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: teamIdController,
//                 decoration: InputDecoration(labelText: 'Team ID'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: matchesPlayedController,
//                 decoration: InputDecoration(labelText: 'Matches Played'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: matchesWonController,
//                 decoration: InputDecoration(labelText: 'Matches Won'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: matchesLostController,
//                 decoration: InputDecoration(labelText: 'Matches Lost'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: totalPointsController,
//                 decoration: InputDecoration(labelText: 'Total Points'),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   temporaryTeams.add({
//                     'teamId': int.parse(teamIdController.text),
//                     'matchesPlayed': int.parse(matchesPlayedController.text),
//                     'matchesWon': int.parse(matchesWonController.text),
//                     'matchesLost': int.parse(matchesLostController.text),
//                     'totalPoints': int.parse(totalPointsController.text),
//                   });
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showEditTeamDialog(
//       int index, Map<String, dynamic> team, bool isTemporary) {
//     final TextEditingController teamIdController =
//         TextEditingController(text: team['teamId'].toString());
//     final TextEditingController matchesPlayedController =
//         TextEditingController(text: team['matchesPlayed'].toString());
//     final TextEditingController matchesWonController =
//         TextEditingController(text: team['matchesWon'].toString());
//     final TextEditingController matchesLostController =
//         TextEditingController(text: team['matchesLost'].toString());
//     final TextEditingController totalPointsController =
//         TextEditingController(text: team['totalPoints'].toString());

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit Team'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: teamIdController,
//                 decoration: InputDecoration(labelText: 'Team ID'),
//                 keyboardType: TextInputType.number,
//                 readOnly: true,
//               ),
//               TextField(
//                 controller: matchesPlayedController,
//                 decoration: InputDecoration(labelText: 'Matches Played'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: matchesWonController,
//                 decoration: InputDecoration(labelText: 'Matches Won'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: matchesLostController,
//                 decoration: InputDecoration(labelText: 'Matches Lost'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: totalPointsController,
//                 decoration: InputDecoration(labelText: 'Total Points'),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   final updatedTeam = {
//                     'eventId': widget.eventId,
//                     'teamId': int.parse(teamIdController.text),
//                     'matchesPlayed': int.parse(matchesPlayedController.text),
//                     'matchesWon': int.parse(matchesWonController.text),
//                     'matchesLost': int.parse(matchesLostController.text),
//                     'totalPoints': int.parse(totalPointsController.text),
//                   };
//                   if (isTemporary) {
//                     temporaryTeams[index] = updatedTeam;
//                   } else {
//                     updateTeam(index, updatedTeam);
//                   }
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchLeaderboard();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Column(
//         children: [
//           SizedBox(
//             height: 400,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columnSpacing: 10.0, // Reduce spacing between columns
//                 columns: [
//                   DataColumn(label: Text('Team ID')),
//                   DataColumn(label: Text('Team Logo')),
//                   DataColumn(label: Text('Team Name')),
//                   DataColumn(label: Text('Matches Played')),
//                   DataColumn(label: Text('Matches Won')),
//                   DataColumn(label: Text('Matches Lost')),
//                   DataColumn(label: Text('Total Points')),
//                   if (widget.isAdmin) DataColumn(label: Text('Actions')),
//                 ],
//                 rows: [
//                   ...leaderboardData.asMap().entries.map((entry) {
//                     int index = entry.key;
//                     var team = entry.value;
//                     return DataRow(cells: [
//                       DataCell(Text(team['teamId'].toString())),
//                       DataCell(
//                         team['teamLogoPath'] != null
//                             ? Image.network(
//                                 team['teamLogoPath'],
//                                 width: 50,
//                                 height: 50,
//                               )
//                             : Text('No Logo'),
//                       ),
//                       DataCell(Text(team['teamName'] ?? 'Unknown')),
//                       DataCell(Text(team['matchesPlayed'].toString())),
//                       DataCell(Text(team['matchesWon'].toString())),
//                       DataCell(Text(team['matchesLost'].toString())),
//                       DataCell(Text(team['totalPoints'].toString())),
//                       if (widget.isAdmin)
//                         DataCell(Row(
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.edit),
//                               onPressed: () => _showEditTeamDialog(
//                                   index, team, false),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.delete),
//                               onPressed: () => _deleteTeam(index, false),
//                             ),
//                           ],
//                         )),
//                     ]);
//                   }).toList(),
//                   ...temporaryTeams.asMap().entries.map((entry) {
//                     int index = entry.key;
//                     var team = entry.value;
//                     return DataRow(cells: [
//                       DataCell(Text(team['teamId'].toString())),
//                       DataCell(Text('No Logo')),
//                       DataCell(Text('Temporary Team')),
//                       DataCell(Text(team['matchesPlayed'].toString())),
//                       DataCell(Text(team['matchesWon'].toString())),
//                       DataCell(Text(team['matchesLost'].toString())),
//                       DataCell(Text(team['totalPoints'].toString())),
//                       DataCell(Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.edit),
//                             onPressed: () =>
//                                 _showEditTeamDialog(index, team, true),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete),
//                             onPressed: () => _deleteTeam(index, true),
//                           ),
//                         ],
//                       )),
//                     ]);
//                   }).toList(),
//                 ],
//               ),
//             ),
//           ),
//           if (widget.isAdmin) SizedBox(height: 20),
//           if (widget.isAdmin)
//             ElevatedButton(
//               onPressed: _showAddTeamDialog,
//               child: Text('Add Team'),
//             ),
//           if (widget.isAdmin)
//             ElevatedButton(
//               onPressed: () async {
//                 if (temporaryTeams.isNotEmpty) {
//                   await addTeams(temporaryTeams);
//                 }
//               },
//               child: Text('Save All'),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardWidget extends StatefulWidget {
  final int eventId;
  final bool isAdmin;

  LeaderboardWidget({required this.eventId, required this.isAdmin});

  @override
  _LeaderboardWidgetState createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends State<LeaderboardWidget> {
  List<Map<String, dynamic>> leaderboardData = [];
  List<Map<String, dynamic>> temporaryTeams = [];
  int? leaderboardId;

  Future<void> fetchLeaderboard() async {
    try {
      final response = await http.get(
        Uri.parse('https://sportappapi-production.up.railway.app/api/leaderboards/${widget.eventId}'),
      );

      if (response.statusCode == 200) {
        var leaderboard = json.decode(response.body);

        if (leaderboard != null && leaderboard['event'] != null && leaderboard['event']['id'] == widget.eventId) {
          leaderboardId = leaderboard['id'];
          var teamScores = leaderboard['teamScores'];
          if (teamScores is List) {
            teamScores.sort((a, b) => b['totalPoints'].compareTo(a['totalPoints']));
            setState(() {
              leaderboardData = teamScores.cast<Map<String, dynamic>>();
            });
          } else {
            setState(() {
              leaderboardData = [];
            });
          }
        } else {
          setState(() {
            leaderboardData = [];
          });
        }
      } else if (response.statusCode == 404) {
        setState(() {
          leaderboardData = [];
        });
      } else {
        setState(() {
          leaderboardData = [];
        });
      }
    } catch (e) {
      setState(() {
        leaderboardData = [];
      });
    }
  }

  Future<void> addTeams(List<Map<String, dynamic>> teams) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      Map<String, dynamic> requestBody = {
        'eventId': widget.eventId,
        'teamScores': teams,
      };

      final response = await http.post(
        Uri.parse('https://sportappapi-production.up.railway.app/api/leaderboards'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        setState(() {
          temporaryTeams.clear();
        });
        await fetchLeaderboard();
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: Ensure you have the correct permissions.');
      } else {
        throw Exception('Failed to add teams');
      }
    } catch (e) {
      print('Error adding teams: $e');
    }
  }

  Future<void> deleteLeaderboard() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.delete(
        Uri.parse('https://sportappapi-production.up.railway.app/api/leaderboards/$leaderboardId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        setState(() {
          leaderboardData.clear();
        });
      } else {
        throw Exception('Failed to delete leaderboard');
      }
    } catch (e) {
      print('Error deleting leaderboard: $e');
    }
  }

  void _showAddTeamDialog() {
    final TextEditingController teamIdController = TextEditingController();
    final TextEditingController matchesPlayedController = TextEditingController();
    final TextEditingController matchesWonController = TextEditingController();
    final TextEditingController matchesLostController = TextEditingController();
    final TextEditingController totalPointsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Team'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: teamIdController,
                  decoration: InputDecoration(labelText: 'Team ID'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: matchesPlayedController,
                  decoration: InputDecoration(labelText: 'Matches Played'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: matchesWonController,
                  decoration: InputDecoration(labelText: 'Matches Won'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: matchesLostController,
                  decoration: InputDecoration(labelText: 'Matches Lost'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: totalPointsController,
                  decoration: InputDecoration(labelText: 'Total Points'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  temporaryTeams.add({
                    'teamId': int.parse(teamIdController.text),
                    'matchesPlayed': int.parse(matchesPlayedController.text),
                    'matchesWon': int.parse(matchesWonController.text),
                    'matchesLost': int.parse(matchesLostController.text),
                    'totalPoints': int.parse(totalPointsController.text),
                  });
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTeamDialog(int index, Map<String, dynamic> team, bool isTemporary) {
    final TextEditingController matchesPlayedController = TextEditingController(text: team['matchesPlayed'].toString());
    final TextEditingController matchesWonController = TextEditingController(text: team['matchesWon'].toString());
    final TextEditingController matchesLostController = TextEditingController(text: team['matchesLost'].toString());
    final TextEditingController totalPointsController = TextEditingController(text: team['totalPoints'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Team'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: matchesPlayedController,
                  decoration: InputDecoration(labelText: 'Matches Played'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: matchesWonController,
                  decoration: InputDecoration(labelText: 'Matches Won'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: matchesLostController,
                  decoration: InputDecoration(labelText: 'Matches Lost'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: totalPointsController,
                  decoration: InputDecoration(labelText: 'Total Points'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final updatedTeam = {
                    'eventId': widget.eventId,
                    'teamId': team['teamId'],
                    'matchesPlayed': int.parse(matchesPlayedController.text),
                    'matchesWon': int.parse(matchesWonController.text),
                    'matchesLost': int.parse(matchesLostController.text),
                    'totalPoints': int.parse(totalPointsController.text),
                  };
                  if (isTemporary) {
                    temporaryTeams[index] = updatedTeam;
                  } else {
                    leaderboardData[index] = updatedTeam;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: DataTable(
                columnSpacing: 20.0,
                columns: [
                  DataColumn(label: Text('Team')),
                  DataColumn(label: Text('Played')),
                  DataColumn(label: Text('Won')),
                  DataColumn(label: Text('Lost')),
                  DataColumn(label: Text('Points')),
                ],
                rows: [
                  ...leaderboardData.map((team) {
                    return DataRow(cells: [
                      DataCell(
                        Row(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 60,
                                maxHeight: 60,
                              ),
                              child: CircleAvatar(
                                backgroundImage: team['teamLogoPath'] != null
                                    ? NetworkImage(team['teamLogoPath'])
                                    : null,
                                child: team['teamLogoPath'] == null
                                    ? Text('No Logo')
                                    : null,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                team['teamName'] ?? 'No Name',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(team['matchesPlayed'].toString())),
                      DataCell(Text(team['matchesWon'].toString())),
                      DataCell(Text(team['matchesLost'].toString())),
                      DataCell(Text(team['totalPoints'].toString())),
                    ]);
                  }).toList(),
                  ...temporaryTeams.asMap().entries.map((entry) {
                    int index = entry.key;
                    var team = entry.value;
                    return DataRow(cells: [
                      DataCell(
                        Row(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 60,
                                maxHeight: 60,
                              ),
                              child: CircleAvatar(
                                backgroundImage: null,
                                child: Text('No Logo'),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Temporary Team',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(team['matchesPlayed'].toString())),
                      DataCell(Text(team['matchesWon'].toString())),
                      DataCell(Text(team['matchesLost'].toString())),
                      DataCell(Text(team['totalPoints'].toString())),
                    ]);
                  }).toList(),
                ],
              ),
            ),
          ),
          if (widget.isAdmin) SizedBox(height: 20),
          if (widget.isAdmin)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _showAddTeamDialog,
                  tooltip: 'Add Team',
                ),
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () async {
                    if (temporaryTeams.isNotEmpty) {
                      await addTeams(temporaryTeams);
                    }
                  },
                  tooltip: 'Save All',
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: deleteLeaderboard,
                  tooltip: 'Delete Leaderboard',
                ),
              ],
            ),
        ],
      ),
    );
  }
}
