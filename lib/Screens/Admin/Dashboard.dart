import 'package:flutter/material.dart';
import 'package:flutter_sports/Screens/Admin/Event.dart';
import 'package:flutter_sports/Screens/Admin/Fixture.dart';
import 'package:flutter_sports/Screens/Admin/Scorecards.dart';
import 'Organization.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String adminName = 'John Doe';
  String adminEmail = 'admin@gmail.com';
  String adminPhone = '7410109414';

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
                  'Admin Info:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text('Name: $adminName'),
                Text('Phone: $adminPhone'),
                Text('Email: $adminEmail'),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              children: [
                _buildMenuItem('Organizations', Icons.business, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateOrganizationScreen()),
                  );
                }),
                _buildMenuItem('Events', Icons.event, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventForm()),
                  );
                }),
                _buildMenuItem('Fixtures', Icons.format_list_numbered, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FixtureForm()),
                  );
                }),
                _buildMenuItem('Scorecards', Icons.score, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScorecardForm()),
                  );
                }),
                _buildMenuItem('Pointstable', Icons.table_chart, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FixtureForm()),
                  );
                }),
                _buildMenuItem('Teams', Icons.group, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FixtureForm()),
                  );
                }),
                _buildMenuItem('Pools', Icons.list, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FixtureForm()),
                  );
                }),
                _buildMenuItem('About us', Icons.person, () {}),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Padding(
          // padding: const EdgeInsets.only(bottom: 80.0),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Add logout functionality here
              },
              child: Text('Logout'),
            ),
          ),
          // ),
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
