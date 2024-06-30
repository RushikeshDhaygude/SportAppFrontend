// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:stomp_dart_client/stomp.dart';
// import 'package:stomp_dart_client/stomp_config.dart';
// import 'package:stomp_dart_client/stomp_frame.dart';
// import 'package:intl/intl.dart'; // Import intl package for date formatting

// import '../Api/api_constants.dart';

// class LiveScorecardWidget extends StatefulWidget {
//   @override
//   _LiveScorecardWidgetState createState() => _LiveScorecardWidgetState();
// }

// class _LiveScorecardWidgetState extends State<LiveScorecardWidget>
//     with SingleTickerProviderStateMixin {
//   late StompClient stompClient;
//   List<Scorecard> scorecards = [];
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize StompClient and connect to WebSocket server
//     stompClient = StompClient(
//       config: StompConfig(
//         url: ApiConstants.socketAddress,
//         onConnect: onConnectCallback,
//         onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
//         stompConnectHeaders: {'Authorization': 'Bearer your_token'},
//       ),
//     );
//     stompClient.activate();

//     // Initialize animation controller
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     )..repeat(reverse: true);
//   }

//   void onConnectCallback(StompFrame? frame) {
//     print('Connected to WebSocket');
//     // Subscribe to the desired topic
//     stompClient.subscribe(
//       destination: '/topic/score-updates',
//       callback: (StompFrame frame) {
//         print('Received message: ${frame.body}');
//         // Parse the incoming message and update the state
//         setState(() {
//           Map<String, dynamic> data = json.decode(frame.body ?? '{}');
//           Scorecard scorecard = Scorecard.fromJson(data);

//           int index = scorecards.indexWhere((card) => card.id == scorecard.id);

//           if (index != -1) {
//             // Update existing scorecard
//             scorecards[index] = scorecard;
//           } else {
//             // Add new scorecard
//             scorecards.add(scorecard);
//           }
//         });
//       },
//     );
//   }

//   @override
//   void dispose() {
//     stompClient.deactivate();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300, // Set a fixed height for the horizontal list
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: scorecards.length,
//         itemBuilder: (context, index) {
//           return ScorecardWidget(scorecard: scorecards[index]);
//         },
//       ),
//     );
//   }
// }

// class Scorecard {
//   final int id;
//   final String team1Name;
//   final String team2Name;
//   final String team1LogoPath;
//   final String team2LogoPath;
//   final String matchResult;
//   final String team1Score;
//   final String team2Score;
//   final String location;
//   final String matchDetails;
//   final String eventName;
//   final DateTime eventDate;
//   final String status;

//   Scorecard({
//     required this.id,
//     required this.team1Name,
//     required this.team2Name,
//     required this.team1LogoPath,
//     required this.team2LogoPath,
//     required this.matchResult,
//     required this.team1Score,
//     required this.team2Score,
//     required this.location,
//     required this.matchDetails,
//     required this.eventName,
//     required this.eventDate,
//     required this.status,
//   });

//   factory Scorecard.fromJson(Map<String, dynamic> json) {
//     return Scorecard(
//       id: json['id'],
//       team1Name: json['team1']['teamName']?.trim() ?? '',
//       team2Name: json['team2']['teamName']?.trim() ?? '',
//       team1LogoPath: json['team1']['teamLogoPath'] ?? '',
//       team2LogoPath: json['team2']['teamLogoPath'] ?? '',
//       matchResult: json['matchResult'] ?? '',
//       team1Score: json['team1Score'] ?? '',
//       team2Score: json['team2Score'] ?? '',
//       location: json['eventLocation'] ?? '',
//       matchDetails: json['matchDetails'] ?? '',
//       eventName: json['event']['eventName'] ?? '',
//       eventDate: DateTime.parse(json['eventDate']),
//       status: json['status'] ?? '',
//     );
//   }
// }

// class ScorecardWidget extends StatelessWidget {
//   final Scorecard scorecard;

//   ScorecardWidget({required this.scorecard});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 300, // Set a fixed width for each scorecard
//       margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
//       padding: EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           SingleChildScrollView(
//             // Wrap content in SingleChildScrollView
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Live Scorecard',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Event: ${scorecard.eventName}',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Match: ${scorecard.team1Name} vs ${scorecard.team2Name}',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Score: ${scorecard.team1Name}: ${scorecard.team1Score} - ${scorecard.team2Name}: ${scorecard.team2Score}',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Location: ${scorecard.location}',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Details: ${scorecard.matchDetails}',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Result: ${scorecard.matchResult}',
//                   style: TextStyle(fontSize: 16, color: Colors.green),
//                 ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Text(
//                       'Date: ${DateFormat('yyyy-MM-dd').format(scorecard.eventDate)}',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       'Time: ${DateFormat('kk:mm').format(scorecard.eventDate)}',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           if (scorecard.status == 'LIVE')
//             Positioned(
//               top: 0,
//               right: 0,
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(12),
//                     bottomLeft: Radius.circular(12),
//                   ),
//                 ),
//                 child: LiveIndicator(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class LiveIndicator extends StatefulWidget {
//   @override
//   _LiveIndicatorState createState() => _LiveIndicatorState();
// }

// class _LiveIndicatorState extends State<LiveIndicator>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     )..repeat(reverse: true);
//     _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'LIVE',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//             SizedBox(width: 4),
//             Container(
//               width: 10,
//               height: 10,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: Transform.translate(
//                 offset: Offset(0, 5 * (_animation.value - 0.5)),
//                 child: Container(
//                   width: 6,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../Api/api_constants.dart';

class LiveScorecardWidget extends StatefulWidget {
  @override
  _LiveScorecardWidgetState createState() => _LiveScorecardWidgetState();
}

class _LiveScorecardWidgetState extends State<LiveScorecardWidget>
    with SingleTickerProviderStateMixin {
  late StompClient stompClient;
  List<Scorecard> scorecards = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    stompClient = StompClient(
      config: StompConfig(
        url: ApiConstants.socketAddress,
        onConnect: onConnectCallback,
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
        stompConnectHeaders: {'Authorization': 'Bearer your_token'},
      ),
    );
    stompClient.activate();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  void onConnectCallback(StompFrame? frame) {
    print('Connected to WebSocket');
    stompClient.subscribe(
      destination: '/topic/score-updates',
      callback: (StompFrame frame) {
        print('Received message: ${frame.body}');
        setState(() {
          Map<String, dynamic> data = json.decode(frame.body ?? '{}');
          Scorecard scorecard = Scorecard.fromJson(data);

          int index = scorecards.indexWhere((card) => card.id == scorecard.id);

          if (index != -1) {
            scorecards[index] = scorecard;
            if (scorecard.status == 'FINAL') {
              removeScorecard(scorecard.id);
            }
          } else {
            if (scorecard.status != 'FINAL') {
              scorecards.add(scorecard);
            }
          }
        });
      },
    );
  }

  Future<void> updateScorecardStatus(int id, String status) async {
    final url = '${ApiConstants.baseUrl}/scorecards/$id';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer your_token',
      },
      body: json.encode({'status': status}),
    );

    if (response.statusCode == 200) {
      print('Scorecard status updated successfully.');
    } else {
      print('Failed to update scorecard status: ${response.body}');
    }
  }

  void removeScorecard(int id) {
    setState(() {
      scorecards.removeWhere((card) => card.id == id);
    });
  }

  @override
  void dispose() {
    stompClient.deactivate();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
  final DateTime eventDate;
  final String status;

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
    required this.eventDate,
    required this.status,
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
      location: json['eventLocation'] ?? '',
      matchDetails: json['matchDetails'] ?? '',
      eventName: json['event']['eventName'] ?? '',
      eventDate: DateTime.parse(json['eventDate']),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team1': {
        'teamName': team1Name,
        'teamLogoPath': team1LogoPath,
      },
      'team2': {
        'teamName': team2Name,
        'teamLogoPath': team2LogoPath,
      },
      'matchResult': matchResult,
      'team1Score': team1Score,
      'team2Score': team2Score,
      'eventLocation': location,
      'matchDetails': matchDetails,
      'event': {
        'eventName': eventName,
      },
      'eventDate': eventDate.toIso8601String(),
      'status': status,
    };
  }
}

class ScorecardWidget extends StatelessWidget {
  final Scorecard scorecard;

  ScorecardWidget({required this.scorecard});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
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
      child: Stack(
        children: [
          SingleChildScrollView(
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
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(scorecard.eventDate)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Time: ${DateFormat('kk:mm').format(scorecard.eventDate)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (scorecard.status == 'LIVE')
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: LiveIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class LiveIndicator extends StatefulWidget {
  @override
  _LiveIndicatorState createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<LiveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'LIVE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 4),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Transform.translate(
                offset: Offset(0, 5 * (_animation.value - 0.5)),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
