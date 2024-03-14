// // import 'dart:convert'; // Import dart:convert

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_sports/Screens/Event.dart';
// import 'Registration.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:flutter_stomp/flutter_stomp.dart';

// class HomeScreen extends StatelessWidget {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: Text('Home'),
//         backgroundColor: Color.fromARGB(255, 46, 240, 191),
//       ),
//       drawer: buildDrawer(context),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildSectionTitle('Events'),
//             buildEventList(),
//             SizedBox(height: 10),
//             buildSectionTitle('Gallery'),
//             buildImageList(),
//             SizedBox(height: 10),
//             buildSectionTitle('Upcoming Matches'),
//             buildMatchList(),
//             SizedBox(height: 10),
//             buildSectionTitle('Live Scorecard'),
//             _HomeScreenState(), // Use the _HomeScreenState widget here
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildDrawer(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Color.fromARGB(255, 46, 240, 191),
//             ),
//             child: Text(
//               'Elevate',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 24,
//               ),
//             ),
//           ),
//           buildDrawerItem('Gallery', () {}),
//           buildDrawerItem('Dashboard', () {}),
//           buildDrawerItem('Events', () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => EventScreen()),
//             );
//           }),
//           buildDrawerItem('Contact', () {}),
//           buildDrawerItem('Login', () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => RegistrationPage()),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Widget buildDrawerItem(String title, Function() onTap) {
//     return ListTile(
//       title: Text(title),
//       onTap: onTap,
//     );
//   }

//   Widget buildSectionTitle(String title) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 25,
//           fontWeight: FontWeight.normal,
//         ),
//       ),
//     );
//   }

//   Widget buildEventList() {
//     return SizedBox(
//       height: 80.0,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: [
//           buildEventWidget('Volleyball', Icons.sports_volleyball),
//           buildEventWidget('Cricket', Icons.sports_cricket),
//           buildEventWidget('Basketball', Icons.sports_basketball),
//           buildEventWidget('Baseball', Icons.sports_baseball),
//           buildEventWidget('Table Tennis', Icons.sports_tennis),
//           buildEventWidget('Football', Icons.sports_football),
//         ],
//       ),
//     );
//   }

//   Widget buildEventWidget(String eventName, IconData iconData) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.0),
//       child: Column(
//         children: [
//           Icon(
//             iconData,
//             size: 50,
//             color: Color.fromARGB(255, 46, 240, 191),
//           ),
//           SizedBox(height: 4),
//           Text(
//             eventName,
//             style: TextStyle(fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildImageList() {
//     return SizedBox(
//       height: 150.0,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: [
//           buildImageWidget('assets/images/Sports1.jpg'),
//           buildImageWidget('assets/images/Sports2.jpg'),
//           buildImageWidget('assets/images/Sports3.jpg'),
//         ],
//       ),
//     );
//   }

//   Widget buildImageWidget(String imagePath) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12.0),
//         child: Image.asset(
//           imagePath,
//           width: 200,
//           height: 175,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }

//   Widget buildMatchList() {
//     return SizedBox(
//       height: 180.0,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: [
//           buildMatchCard('Match 1', 'PICT vs VIT', '2022-03-01 14:00'),
//           buildMatchCard('Match 2', 'SCOE vs SITs', '2022-03-03 16:00'),
//           buildMatchCard('Match 3', 'VIIT vs COEP', '2022-03-05 12:00'),
//         ],
//       ),
//     );
//   }

//   Widget buildMatchCard(String matchName, String teams, String dateTime) {
//     return Container(
//       width: 100,
//       margin: EdgeInsets.symmetric(horizontal: 8.0),
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
//       child: Padding(
//         padding: EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               matchName,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               teams,
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 8),
//             Text(
//               dateTime,
//               style: TextStyle(fontSize: 14),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }

// class _HomeScreenState extends StatefulWidget {
//   @override
//   _HomeScreenStateState createState() => _HomeScreenStateState();
// }

// class _HomeScreenStateState extends State<_HomeScreenState> {
//   late IO.Socket socket;
//   String team1Name = '';
//   String team2Name = '';
//   String matchResult = '';
//   String team1Score = '';
//   String team2Score = '';
//   String location = '';
//   String matchDetails = '';

//   @override
//   void initState() {
//     super.initState();
//     // Initialize socket connection
//     socket = IO.io('http://localhost:8080/ws');

//     // Listen for messages from the server
//     socket.on('live_match', (data) {
//       setState(() {
//         // Parse the incoming message and update the state
//         Map<String, dynamic> jsonData = json.decode(data);
//         team1Name = jsonData['team1']['teamName'];
//         team2Name = jsonData['team2']['teamName'];
//         matchResult = jsonData['matchResult'];
//         team1Score = jsonData['team1Score'];
//         team2Score = jsonData['team2Score'];
//         location = jsonData['event']['location'];
//         matchDetails = jsonData['matchDetails'];
//       });
//     });

//     // Connect to the server
//     socket.connect();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     // Disconnect socket when the widget is disposed
//     socket.disconnect();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildLiveScoreCard();
//   }

//   Widget buildLiveScoreCard() {
//     return Container(
//       width: 200,
//       padding: EdgeInsets.all(10),
//       margin: EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Live Match',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             '$team1Name vs $team2Name',
//             style: TextStyle(fontSize: 16),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Result: $matchResult',
//             style: TextStyle(fontSize: 14, color: Colors.grey),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Score: $team1Score - $team2Score',
//             style: TextStyle(fontSize: 14, color: Colors.grey),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Location: $location',
//             style: TextStyle(fontSize: 14, color: Colors.grey),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Details: $matchDetails',
//             style: TextStyle(fontSize: 14, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:convert'; // Import dart:convert
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sports/Screens/Event.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'Registration.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color.fromARGB(255, 46, 240, 191),
      ),
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Events'),
            buildEventList(),
            SizedBox(height: 10),
            buildSectionTitle('Gallery'),
            buildImageList(),
            SizedBox(height: 10),
            buildSectionTitle('Upcoming Matches'),
            buildMatchList(),
            SizedBox(height: 10),
            buildSectionTitle('Live Scorecard'),
            _HomeScreenState(), // Use the _HomeScreenState widget here
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 46, 240, 191),
            ),
            child: Text(
              'Elevate',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          buildDrawerItem('Gallery', () {}),
          buildDrawerItem('Dashboard', () {}),
          buildDrawerItem('Events', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventScreen()),
            );
          }),
          buildDrawerItem('Contact', () {}),
          buildDrawerItem('Login', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget buildDrawerItem(String title, Function() onTap) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget buildEventList() {
    return SizedBox(
      height: 80.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildEventWidget('Volleyball', Icons.sports_volleyball),
          buildEventWidget('Cricket', Icons.sports_cricket),
          buildEventWidget('Basketball', Icons.sports_basketball),
          buildEventWidget('Baseball', Icons.sports_baseball),
          buildEventWidget('Table Tennis', Icons.sports_tennis),
          buildEventWidget('Football', Icons.sports_football),
        ],
      ),
    );
  }

  Widget buildEventWidget(String eventName, IconData iconData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Icon(
            iconData,
            size: 50,
            color: Color.fromARGB(255, 46, 240, 191),
          ),
          SizedBox(height: 4),
          Text(
            eventName,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget buildImageList() {
    return SizedBox(
      height: 150.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildImageWidget('assets/images/Sports1.jpg'),
          buildImageWidget('assets/images/Sports2.jpg'),
          buildImageWidget('assets/images/Sports3.jpg'),
        ],
      ),
    );
  }

  Widget buildImageWidget(String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.asset(
          imagePath,
          width: 200,
          height: 175,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildMatchList() {
    return SizedBox(
      height: 180.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildMatchCard('Match 1', 'PICT vs VIT', '2022-03-01 14:00'),
          buildMatchCard('Match 2', 'SCOE vs SITs', '2022-03-03 16:00'),
          buildMatchCard('Match 3', 'VIIT vs COEP', '2022-03-05 12:00'),
        ],
      ),
    );
  }

  Widget buildMatchCard(String matchName, String teams, String dateTime) {
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
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
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              matchName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              teams,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              dateTime,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// class _HomeScreenState extends StatefulWidget {
//   @override
//   _HomeScreenStateState createState() => _HomeScreenStateState();
// }

// class _HomeScreenStateState extends State<_HomeScreenState> {
//   late WebSocketChannel channel;
//   String team1Name = '';
//   String team2Name = '';
//   String matchResult = '';
//   String team1Score = '';
//   String team2Score = '';
//   String location = '';
//   String matchDetails = '';

//   @override
//   void initState() {
//     super.initState();

//     // Initialize WebSocket connection with error handling
//     _connectWebSocket(); // Use a separate function for clarity
//   }

//   void _connectWebSocket() async {
//     try {
//       channel = IOWebSocketChannel.connect("ws://192.168.43.56:8080/ws");
//       print("Connection Successful");
//       subscribeToTopic(); // Subscribe only after successful connection
//     } catch (e) {
//       print("Connection error: $e");
//       // Handle connection errors here, e.g., retry logic or displaying a user-friendly message
//       _handleConnectionError(e);
//     }
//   }

//   // Handle connection errors as needed
//   void _handleConnectionError(error) {
//     // Example: Show a retry button or informative error message
//     print("Connection failed, please try again.");
//   }

//   void subscribeToTopic() {
//     try {
//       Map<String, dynamic> subscriptionMessage = {
//         'action': 'subscribe',
//         'topic': '/topic/score-updates',
//       };
//       channel.sink.add(json.encode(subscriptionMessage));
//     } catch (e) {
//       print('Error while sending subscription message: $e');
//       // Handle the error as needed, e.g., retry or logging
//       _handleSubscriptionError(e);
//     }
//   }

//   // Handle subscription errors as needed
//   void _handleSubscriptionError(error) {
//     print("Failed to subscribe to topic.");
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     channel.sink.close(); // Close the WebSocket even in case of errors
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildLiveScoreCard();
//   }
//   Widget buildLiveScoreCard() {
//     return Container(
//       width: 200,
//       padding: EdgeInsets.all(10),
//       margin: EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Live Match',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             '$team1Name vs $team2Name',
//             style: TextStyle(fontSize: 16),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Result: $matchResult',
//             style: TextStyle(fontSize: 14, color: Colors.grey),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Score: $team1Score - $team2Score',
//             style: TextStyle(fontSize: 14, color: Colors.grey),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Location: $location',
//             style: TextStyle(fontSize: 14, color: Colors.grey),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Details: $matchDetails',
//             style: TextStyle(fontSize: 14, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
class _HomeScreenState extends StatefulWidget {
  @override
  _HomeScreenStateState createState() => _HomeScreenStateState();
}

class _HomeScreenStateState extends State<_HomeScreenState> {
  late StompClient stompClient;
  String team1Name = '';
  String team2Name = '';
  String matchResult = '';
  String team1Score = '';
  String team2Score = '';
  String location = '';
  String matchDetails = '';

  @override
  void initState() {
    super.initState();
    // Initialize StompClient and connect to WebSocket server
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://192.168.43.56:8080/ws',
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
          team1Name = data['team1Name'] ?? '';
          team2Name = data['team2Name'] ?? '';
          matchResult = data['matchResult'] ?? '';
          team1Score = data['team1Score'] ?? '';
          team2Score = data['team2Score'] ?? '';
          location = data['location'] ?? '';
          matchDetails = data['matchDetails'] ?? '';
        });
      },
    );
  }

  @override
  void dispose() {
    // Deactivate StompClient and close the WebSocket connection
    stompClient.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildLiveScoreCard();
  }

  Widget buildLiveScoreCard() {
    return Container(
      width: 200,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Match',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '$team1Name vs $team2Name',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            'Result: $matchResult',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 5),
          Text(
            'Score: $team1Score - $team2Score',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 5),
          Text(
            'Location: $location',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 5),
          Text(
            'Details: $matchDetails',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
