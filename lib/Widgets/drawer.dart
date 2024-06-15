import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sports/Screens/Event.dart';
import 'package:flutter_sports/Screens/Registration.dart';

import '../Screens/Gallery.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.yellow,
              ),
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8), // Adjusted padding for a smaller header
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                children: [
                  CircleAvatar(
                    radius:40 ,  // Further reduced the radius for a smaller logo
                    backgroundImage: AssetImage('assets/images/Elevate_Logo.jpeg'), // Ensure this path is correct
                  ),
                  SizedBox(height: 3),
                  Text(
                    '  Elevate',
                    style: GoogleFonts.bebasNeue(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20, // Reduced font size for better visibility
                        fontWeight: FontWeight.bold, // Use bold to emphasize the title
                      ),
                    ),
                  ),
                  Text(
                    '  Rise above all',
                    style: GoogleFonts.bebasNeue(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14, // Further reduced font size for better alignment
                        fontWeight: FontWeight.normal, // Regular font weight for the subtitle
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildDrawerItem(context, 'Gallery', Icons.photo_album, () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageGalleryScreen()),
              );
            }),
            buildDrawerItem(context, 'Dashboard', Icons.dashboard, () {}),
            buildDrawerItem(context, 'Events', Icons.event, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventScreen()),
              );
            }),
            buildDrawerItem(context, 'Contact', Icons.contact_mail, () {}),
            buildDrawerItem(context, 'Login', Icons.login, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationPage()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(BuildContext context, String title, IconData icon, Function() onTap) {
  return ListTile(
    leading: Icon(icon, color: Colors.black),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16, // Further reduced font size for the drawer items
        fontWeight: FontWeight.bold, // Regular font weight for the drawer items
      ),
    ),
    onTap: onTap,
  );
}
}