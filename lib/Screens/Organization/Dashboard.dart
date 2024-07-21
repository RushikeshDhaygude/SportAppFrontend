import 'package:flutter/material.dart';
import 'package:flutter_sports/Screens/Event.dart';
import 'package:flutter_sports/Screens/Gallery.dart';
import 'package:flutter_sports/Screens/Organization/LiveStream.dart';
import 'package:flutter_sports/Screens/Organization/LocationScreenOrg.dart';
import 'package:flutter_sports/Screens/Organization/Announcements.dart';
import 'package:flutter_sports/Screens/Organization/Teams.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences package

import '../HomeScreen.dart';

import 'dart:convert';

class AdminDashboard extends StatefulWidget {
  final Map<String, dynamic> organization;

  AdminDashboard({required this.organization});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String orgName = '';
  String orgEmail = '';
  String orgContact = '';

  @override
  void initState() {
    super.initState();
    _loadOrganizationDetails();
  }

  Future<void> _loadOrganizationDetails() async {
    // Accessing organization details from widget parameter
    Map<String, dynamic> orgDetails = widget.organization;
    setState(() {
      orgName = orgDetails['name'] ?? '';
      orgEmail = orgDetails['email'] ?? '';
      orgContact = orgDetails['contact'] ?? '';
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data in SharedPreferences

    // Navigate to the home or login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()), // Change HomeScreen to your login or home screen widget
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organization Info:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text('Name: $orgName'),
                Text('Phone: $orgContact'),
                Text('Email: $orgEmail'),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              children: [
                _buildMenuItem('Events', Icons.event, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventScreen(isAdmin: true)),
                  );
                }),
                _buildMenuItem('Teams', Icons.group, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeamsWidget()),
                  );
                }),
                _buildMenuItem('Go Live', Icons.live_tv, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(isAdmin: true)),
                  );
                }),
                _buildMenuItem('Announcements', Icons.alarm, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnnouncementForm()),
                  );
                }),
                _buildMenuItem('Gallery', Icons.image, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GalleryWidget(isAdmin: true)),
                  );
                }),
                _buildMenuItem('Locations', Icons.location_pin, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocationMapScreen(isAdmin: true)),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _logout, // Call the _logout method
              child: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_sports/Screens/Organization/Event.dart';
// import 'package:flutter_sports/Screens/Organization/Fixture.dart';
// import 'package:flutter_sports/Screens/Organization/Scorecards.dart';
// import 'package:flutter_sports/Screens/Organization/Pools.dart';
// import 'package:flutter_sports/Screens/Organization/Announcements.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class AdminDashboard extends StatefulWidget {
//   final Map<String, dynamic> organization;

//   AdminDashboard({required this.organization});

//   @override
//   _AdminDashboardState createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   String orgName = '';
//   String orgEmail = '';
//   String orgContact = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadOrganizationDetails();
//   }

//   Future<void> _loadOrganizationDetails() async {
//     // Accessing organization details from widget parameter
//     Map<String, dynamic> orgDetails = widget.organization;
//     setState(() {
//       orgName = orgDetails['name'] ?? '';
//       orgEmail = orgDetails['email'] ?? '';
//       orgContact = orgDetails['contact'] ?? '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Container(
//             color: Colors.grey[200],
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Organization Info:',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text('Name: $orgName'),
//                 Text('Phone: $orgContact'),
//                 Text('Email: $orgEmail'),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: GridView.count(
//               crossAxisCount: 2,
//               childAspectRatio: 1.5,
//               children: [
//                 // _buildMenuItem('Organizations', Icons.business, () {
//                 //   Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //         builder: (context) => CreateOrganizationScreen()),
//                 //   );
//                 // }),
//                 _buildMenuItem('Events', Icons.event, () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => EventForm()),
//                   );
//                 }),
//                 _buildMenuItem('Fixtures', Icons.format_list_numbered, () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => FixtureForm()),
//                   );
//                 }),
//                 _buildMenuItem('Scorecards', Icons.score, () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ScorecardForm()),
//                   );
//                 }),
//                 _buildMenuItem('Pointstable', Icons.table_chart, () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => FixtureForm()),
//                   );
//                 }),
//                 _buildMenuItem('Teams', Icons.group, () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => FixtureForm()),
//                   );
//                 }),
//                 _buildMenuItem('Pools', Icons.list, () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => PoolsScreen()),
//                   );
//                 }),
//                 _buildMenuItem('Announcements', Icons.alarm, () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AnnouncementForm()),
//                   );
//                 }),
//                 _buildMenuItem('Gallery', Icons.image, () {}),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 // Add logout functionality here
//               },
//               child: Text('Logout'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 2,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 50),
//             SizedBox(height: 10),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
