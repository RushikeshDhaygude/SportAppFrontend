
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_sports/Widgets/FixtureForm.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Api/api_constants.dart';

// class EventMatchesWidget extends StatelessWidget {
//   final int eventId;
//   final bool isAdmin;

//   EventMatchesWidget({required this.eventId, required this.isAdmin});

//   Future<List<dynamic>> fetchMatches() async {
//     try {
//       final response = await http.get(Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}?eventId=$eventId'));

//       if (response.statusCode == 200) {
//         List<dynamic> matches = json.decode(response.body);
//         matches = matches.where((match) => match['event']['id'] == eventId).toList();
//         return matches;
//       } else {
//         throw Exception('Failed to load matches');
//       }
//     } catch (e) {
//       print('Error fetching matches data: $e');
//       throw e;
//     }
//   }

//   Future<void> addMatch(BuildContext context, Map<String, dynamic> matchData) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';

//       final jsonData = jsonEncode({
//         'eventId': eventId, // Take eventId from parameter
//         'team1Id': matchData['team1Id'],
//         'team2Id': matchData['team2Id'],
//         'dateTime': matchData['dateTime'],
//         'gender': matchData['gender'],
//       });

//       print('Add Match Payload: $jsonData');

//       final response = await http.post(
//         Uri.parse(ApiConstants.UpcomingMatchesApiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonData,
//       );

//       print('Add Match Status Code: ${response.statusCode}');
//       print('Add Match Response Body: ${response.body}');

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match added successfully')));
//       } else {
//         throw Exception('Failed to add match');
//       }
//     } catch (e) {
//       print('Error adding match: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding match: ${e.toString()}')));
//     }
//   }

//   Future<void> editMatch(BuildContext context, Map<String, dynamic> matchData, String matchId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';

//       final jsonData = jsonEncode({
//         'eventId': eventId, // Take eventId from parameter
//         'team1Id': matchData['team1Id'],
//         'team2Id': matchData['team2Id'],
//         'dateTime': matchData['dateTime'],
//         'gender': matchData['gender'],
//       });

//       print('Edit Match Payload: $jsonData');
//       print('Edit Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');

//       final response = await http.put(
//         Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}/$matchId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonData,
//       );

//       print('Edit Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');
//       print('Edit Match Status Code: ${response.statusCode}');
//       print('Edit Match Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match updated successfully')));
//       } else {
//         throw Exception('Failed to update match');
//       }
//     } catch (e) {
//       print('Error updating match: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating match: ${e.toString()}')));
//     }
//   }

//   Future<void> deleteMatch(BuildContext context, String matchId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';

//       print('Delete Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');

//       final response = await http.delete(
//         Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}/$matchId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       print('Delete Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');
//       print('Delete Match Status Code: ${response.statusCode}');
//       print('Delete Match Response Body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 204) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match deleted successfully')));
//       } else {
//         throw Exception('Failed to delete match');
//       }
//     } catch (e) {
//       print('Error deleting match: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting match: ${e.toString()}')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (isAdmin)
//           Align(
//             alignment: Alignment.topRight,
//             child: IconButton(
//               icon: Icon(Icons.add),
//               onPressed: () => Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => FixtureForm(
//                     eventId: eventId, // Pass eventId to the form
//                     onSave: (matchData) => addMatch(context, matchData),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         Expanded(
//           child: FutureBuilder<List<dynamic>>(
//             future: fetchMatches(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return Center(child: Text('No matches available'));
//               } else {
//                 return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     return buildMatchCard(context, snapshot.data![index]);
//                   },
//                 );
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildMatchCard(BuildContext context, Map<String, dynamic> match) {
//     String eventName = match['event']['eventName'];
//     String location = match['event']['location'];
//     String dateTime = match['dateTime'];
//     String date = dateTime.split('T')[0];
//     String time = dateTime.split('T')[1];
//     String team1Name = match['team1']['teamName'].trim();
//     String team2Name = match['team2']['teamName'].trim();
//     String gender = match['gender'];

//     return Card(
//       margin: EdgeInsets.all(10),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 5,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   eventName,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Chip(
//                   label: Text(gender),
//                   backgroundColor: Colors.blueAccent,
//                   labelStyle: TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//             Divider(color: Colors.grey[300]),
//             buildInfoRow(Icons.location_on, 'Location', location),
//             buildInfoRow(Icons.calendar_today, 'Date', date),
//             buildInfoRow(Icons.access_time, 'Time', time),
//             buildInfoRow(Icons.sports_volleyball_sharp, 'Match', '$team1Name vs $team2Name'),
//             if (isAdmin)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit),
//                     onPressed: () => Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => FixtureForm(
//                           eventId: eventId, // Pass eventId to the form
//                           match: match,
//                           onSave: (matchData) => editMatch(context, matchData, match['fixtureId'].toString()),
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () => deleteMatch(context, match['fixtureId'].toString()),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blueAccent),
//           SizedBox(width: 10),
//           Text(
//             '$label: ',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Expanded(child: Text(value, style: TextStyle(color: Colors.grey[700]))),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_sports/Widgets/FixtureForm.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Api/api_constants.dart';

// class EventMatchesWidget extends StatelessWidget {
//   final int eventId;
//   final bool isAdmin;

//   EventMatchesWidget({required this.eventId, required this.isAdmin});

//   Future<List<dynamic>> fetchMatches() async {
//     try {
//       final response = await http.get(Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}?eventId=$eventId'));

//       if (response.statusCode == 200) {
//         List<dynamic> matches = json.decode(response.body);
//         matches = matches.where((match) => match['event']['id'] == eventId).toList();
//         return matches;
//       } else {
//         throw Exception('Failed to load matches');
//       }
//     } catch (e) {
//       print('Error fetching matches data: $e');
//       throw e;
//     }
//   }

//   Future<void> addMatch(BuildContext context, Map<String, dynamic> matchData) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';

//       final jsonData = jsonEncode({
//         'eventId': eventId, // Take eventId from parameter
//         'team1Id': matchData['team1Id'],
//         'team2Id': matchData['team2Id'],
//         'dateTime': matchData['dateTime'],
//         'gender': matchData['gender'],
//       });

//       print('Add Match Payload: $jsonData');

//       final response = await http.post(
//         Uri.parse(ApiConstants.UpcomingMatchesApiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonData,
//       );

//       print('Add Match Status Code: ${response.statusCode}');
//       print('Add Match Response Body: ${response.body}');

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match added successfully')));
//       } else {
//         throw Exception('Failed to add match');
//       }
//     } catch (e) {
//       print('Error adding match: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding match: ${e.toString()}')));
//     }
//   }

//   Future<void> editMatch(BuildContext context, Map<String, dynamic> matchData, String matchId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';

//       final jsonData = jsonEncode({
//         'eventId': eventId, // Take eventId from parameter
//         'team1Id': matchData['team1Id'],
//         'team2Id': matchData['team2Id'],
//         'dateTime': matchData['dateTime'],
//         'gender': matchData['gender'],
//       });

//       print('Edit Match Payload: $jsonData');
//       print('Edit Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');

//       final response = await http.put(
//         Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}/$matchId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonData,
//       );

//       print('Edit Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');
//       print('Edit Match Status Code: ${response.statusCode}');
//       print('Edit Match Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match updated successfully')));
//       } else {
//         throw Exception('Failed to update match');
//       }
//     } catch (e) {
//       print('Error updating match: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating match: ${e.toString()}')));
//     }
//   }

//   Future<void> deleteMatch(BuildContext context, String matchId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';

//       print('Delete Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');

//       final response = await http.delete(
//         Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}/$matchId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       print('Delete Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');
//       print('Delete Match Status Code: ${response.statusCode}');
//       print('Delete Match Response Body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 204) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match deleted successfully')));
//       } else {
//         throw Exception('Failed to delete match');
//       }
//     } catch (e) {
//       print('Error deleting match: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting match: ${e.toString()}')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (isAdmin)
//           Align(
//             alignment: Alignment.topRight,
//             child: IconButton(
//               icon: Icon(Icons.add),
//               onPressed: () => Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => FixtureForm(
//                     eventId: eventId, // Pass eventId to the form
//                     onSave: (matchData) => addMatch(context, matchData),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         Expanded(
//           child: FutureBuilder<List<dynamic>>(
//             future: fetchMatches(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return Center(child: Text('No matches available'));
//               } else {
//                 return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     return buildMatchCard(context, snapshot.data![index]);
//                   },
//                 );
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildMatchCard(BuildContext context, Map<String, dynamic> match) {
//     String eventName = match['event']['eventName'];
//     String location = match['event']['location'];
//     String dateTime = match['dateTime'];
//     String date = dateTime.split('T')[0];
//     String time = dateTime.split('T')[1];
//     String team1Name = match['team1']['teamName'].trim();
//     String team2Name = match['team2']['teamName'].trim();
//     String gender = match['gender'];

//     return Card(
//       margin: EdgeInsets.all(10),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 5,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   eventName,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Chip(
//                   label: Text(gender),
//                   backgroundColor: Colors.blueAccent,
//                   labelStyle: TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//             Divider(color: Colors.grey[300]),
//             buildInfoRow(Icons.location_on, 'Location', location),
//             buildInfoRow(Icons.calendar_today, 'Date', date),
//             buildInfoRow(Icons.access_time, 'Time', time),
//             buildInfoRow(Icons.sports_volleyball_sharp, 'Match', '$team1Name vs $team2Name'),
//             if (isAdmin)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit),
//                     onPressed: () => Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => FixtureForm(
//                           eventId: eventId, // Pass eventId to the form
//                           match: match,
//                           onSave: (matchData) => editMatch(context, matchData, match['fixtureId'].toString()),
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () => deleteMatch(context, match['fixtureId'].toString()),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blueAccent),
//           SizedBox(width: 10),
//           Text(
//             '$label: ',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Expanded(child: Text(value, style: TextStyle(color: Colors.grey[700]))),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_sports/Widgets/FixtureForm.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Api/api_constants.dart';

// class EventMatchesWidget extends StatelessWidget {
//   final int eventId;
//   final bool isAdmin;

//   EventMatchesWidget({required this.eventId, required this.isAdmin});

//   Future<List<dynamic>> fetchMatches() async {
//     try {
//       final response = await http.get(Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}?eventId=$eventId'));

//       if (response.statusCode == 200) {
//         List<dynamic> matches = json.decode(response.body);
//         matches = matches.where((match) => match['event']['id'] == eventId).toList();
//         return matches;
//       } else {
//         throw Exception('Failed to load matches');
//       }
//     } catch (e) {
//       print('Error fetching matches data: $e');
//       throw e;
//     }
//   }

//   Future<void> addMatch(BuildContext context, Map<String, dynamic> matchData) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';

//       final jsonData = jsonEncode({
//         'eventId': eventId, // Take eventId from parameter
//         'team1Id': matchData['team1Id'],
//         'team2Id': matchData['team2Id'],
//         'dateTime': matchData['dateTime'],
//         'gender': matchData['gender'],
//       });

//       print('Add Match Payload: $jsonData');

//       final response = await http.post(
//         Uri.parse(ApiConstants.UpcomingMatchesApiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonData,
//       );

//       print('Add Match Status Code: ${response.statusCode}');
//       print('Add Match Response Body: ${response.body}');

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match added successfully')));
//       } else {
//         throw Exception('Failed to add match');
//       }
//     } catch (e) {
//       print('Error adding match: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding match: ${e.toString()}')));
//     }
//   }

//   Future<void> editMatch(BuildContext context, Map<String, dynamic> matchData, String matchId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';

//       final jsonData = jsonEncode({
//         'eventId': eventId, // Take eventId from parameter
//         'team1Id': matchData['team1Id'],
//         'team2Id': matchData['team2Id'],
//         'dateTime': matchData['dateTime'],
//         'gender': matchData['gender'],
//       });

//       print('Edit Match Payload: $jsonData');
//       print('Edit Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');

//       final response = await http.put(
//         Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}/$matchId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonData,
//       );

//       print('Edit Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');
//       print('Edit Match Status Code: ${response.statusCode}');
//       print('Edit Match Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match updated successfully')));
//       } else {
//         throw Exception('Failed to update match');
//       }
//     } catch (e) {
//       print('Error updating match: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating match: ${e.toString()}')));
//     }
//   }

//   Future<void> deleteMatch(BuildContext context, String matchId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';

//       print('Delete Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');

//       final response = await http.delete(
//         Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}/$matchId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       print('Delete Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');
//       print('Delete Match Status Code: ${response.statusCode}');
//       print('Delete Match Response Body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 204) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match deleted successfully')));
//       } else {
//         throw Exception('Failed to delete match');
//       }
//     } catch (e) {
//       print('Error deleting match: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting match: ${e.toString()}')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (isAdmin)
//           Align(
//             alignment: Alignment.topRight,
//             child: IconButton(
//               icon: Icon(Icons.add),
//               onPressed: () => Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => FixtureForm(
//                     eventId: eventId, // Pass eventId to the form
//                     onSave: (matchData) => addMatch(context, matchData),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         Expanded(
//           child: FutureBuilder<List<dynamic>>(
//             future: fetchMatches(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return Center(child: Text('No matches available'));
//               } else {
//                 return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     return buildMatchCard(context, snapshot.data![index]);
//                   },
//                 );
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildMatchCard(BuildContext context, Map<String, dynamic> match) {
//     String eventName = match['event']['eventName'];
//     String location = match['event']['location'];
//     String dateTime = match['dateTime'];
//     String date = dateTime.split('T')[0];
//     String time = dateTime.split('T')[1];
//     String team1Name = match['team1']['teamName'].trim();
//     String team2Name = match['team2']['teamName'].trim();
//     String team1LogoPath = match['team1']['teamLogoPath'];
//     String team2LogoPath = match['team2']['teamLogoPath'];
//     String gender = match['gender'];

//     return Card(
//       margin: EdgeInsets.all(10),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 5,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   eventName,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Chip(
//                   label: Text(gender),
//                   backgroundColor: Colors.blueAccent,
//                   labelStyle: TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//             Divider(color: Colors.grey[300]),
//             buildInfoRow(Icons.location_on, 'Location', location),
//             buildInfoRow(Icons.calendar_today, 'Date', date),
//             buildInfoRow(Icons.access_time, 'Time', time),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Image.network(
//                         team1LogoPath,
//                         height: 60,
//                         width: 60,
//                         fit: BoxFit.cover,
//                       ),
//                       SizedBox(height: 5),
//                       Text(team1Name),
//                     ],
//                   ),
//                 ),
//                 Text('vs', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Image.network(
//                         team2LogoPath,
//                         height: 60,
//                         width: 60,
//                         fit: BoxFit.cover,
//                       ),
//                       SizedBox(height: 5),
//                       Text(team2Name),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             if (isAdmin)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit),
//                     onPressed: () => Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => FixtureForm(
//                           eventId: eventId, // Pass eventId to the form
//                           match: match,
//                           onSave: (matchData) => editMatch(context, matchData, match['fixtureId'].toString()),
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () => deleteMatch(context, match['fixtureId'].toString()),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.grey),
//         SizedBox(width: 5),
//         Text('$label: $value'),
//       ],
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sports/Widgets/FixtureForm.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Api/api_constants.dart';

class EventMatchesWidget extends StatelessWidget {
  final int eventId;
  final bool isAdmin;

  EventMatchesWidget({required this.eventId, required this.isAdmin});

  Future<List<dynamic>> fetchMatches() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}?eventId=$eventId'));

      if (response.statusCode == 200) {
        List<dynamic> matches = json.decode(response.body);
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

  Future<void> addMatch(BuildContext context, Map<String, dynamic> matchData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final jsonData = jsonEncode({
        'eventId': eventId, // Take eventId from parameter
        'team1Id': matchData['team1Id'],
        'team2Id': matchData['team2Id'],
        'dateTime': matchData['dateTime'],
        'gender': matchData['gender'],
      });

      print('Add Match Payload: $jsonData');

      final response = await http.post(
        Uri.parse(ApiConstants.UpcomingMatchesApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonData,
      );

      print('Add Match Status Code: ${response.statusCode}');
      print('Add Match Response Body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match added successfully')));
      } else {
        throw Exception('Failed to add match');
      }
    } catch (e) {
      print('Error adding match: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding match: ${e.toString()}')));
    }
  }

  Future<void> editMatch(BuildContext context, Map<String, dynamic> matchData, String matchId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final jsonData = jsonEncode({
        'eventId': eventId, // Take eventId from parameter
        'team1Id': matchData['team1Id'],
        'team2Id': matchData['team2Id'],
        'dateTime': matchData['dateTime'],
        'gender': matchData['gender'],
      });

      print('Edit Match Payload: $jsonData');
      print('Edit Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');

      final response = await http.put(
        Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}/$matchId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonData,
      );

      print('Edit Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');
      print('Edit Match Status Code: ${response.statusCode}');
      print('Edit Match Response Body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match updated successfully')));
      } else {
        throw Exception('Failed to update match');
      }
    } catch (e) {
      print('Error updating match: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating match: ${e.toString()}')));
    }
  }

  Future<void> deleteMatch(BuildContext context, String matchId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      print('Delete Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');

      final response = await http.delete(
        Uri.parse('${ApiConstants.UpcomingMatchesApiUrl}/$matchId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Delete Match URL: ${ApiConstants.UpcomingMatchesApiUrl}/$matchId');
      print('Delete Match Status Code: ${response.statusCode}');
      print('Delete Match Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match deleted successfully')));
      } else {
        throw Exception('Failed to delete match');
      }
    } catch (e) {
      print('Error deleting match: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting match: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isAdmin)
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FixtureForm(
                    eventId: eventId, // Pass eventId to the form
                    onSave: (matchData) => addMatch(context, matchData),
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          child: FutureBuilder<List<dynamic>>(
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
                    return buildMatchCard(context, snapshot.data![index]);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildMatchCard(BuildContext context, Map<String, dynamic> match) {
    String eventName = match['event']['eventName'];
    String location = match['event']['location'];
    String dateTime = match['dateTime'];
    String date = dateTime.split('T')[0];
    String time = dateTime.split('T')[1];
    String team1Name = match['team1']['teamName'].trim();
    String team2Name = match['team2']['teamName'].trim();
    String team1LogoPath = match['team1']['teamLogoPath'];
    String team2LogoPath = match['team2']['teamLogoPath'];
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTeamInfo(team1LogoPath, team1Name),
                Text('vs', style: TextStyle(fontWeight: FontWeight.bold)),
                buildTeamInfo(team2LogoPath, team2Name),
              ],
            ),
            if (isAdmin)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FixtureForm(
                          eventId: eventId, // Pass eventId to the form
                          match: match,
                          onSave: (matchData) => editMatch(context, matchData, match['fixtureId'].toString()),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteMatch(context, match['fixtureId'].toString()),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        SizedBox(width: 5),
        Text('$label: $value'),
      ],
    );
  }

  Widget buildTeamInfo(String logoPath, String teamName) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(logoPath),
        ),
        SizedBox(height: 8),
        Text(
          teamName,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
