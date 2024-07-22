// import 'package:flutter/material.dart';
// import 'package:flutter_sports/Screens/Organization/LiveStream.dart';
// import 'package:flutter_sports/Screens/Organization/LocationScreenOrg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_sports/Screens/Event.dart';
// import 'package:flutter_sports/Screens/Registration.dart';


// import '../Screens/Gallery.dart';

// class DrawerWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Container(
//         color: Colors.white,
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.yellow,
//               ),
//               padding: EdgeInsets.fromLTRB(
//                   16, 16, 16, 8), // Adjusted padding for a smaller header
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment:
//                     MainAxisAlignment.center, // Center the content vertically
//                 children: [
//                   CircleAvatar(
//                     radius: 40, // Further reduced the radius for a smaller logo
//                     backgroundImage: AssetImage(
//                         'assets/images/Elevate_Logo.jpeg'), // Ensure this path is correct
//                   ),
//                   SizedBox(height: 3),
//                   Text(
//                     '  Elevate',
//                     style: GoogleFonts.bebasNeue(
//                       textStyle: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20, // Reduced font size for better visibility
//                         fontWeight:
//                             FontWeight.bold, // Use bold to emphasize the title
//                       ),
//                     ),
//                   ),
//                   Text(
//                     '  Rise above all',
//                     style: GoogleFonts.bebasNeue(
//                       textStyle: TextStyle(
//                         color: Colors.black,
//                         fontSize:
//                             14, // Further reduced font size for better alignment
//                         fontWeight: FontWeight
//                             .normal, // Regular font weight for the subtitle
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             buildDrawerItem(context, 'Gallery', Icons.image, () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => GalleryWidget(
//                           isAdmin: false,
//                         )),
//               );
//             }),
//             buildDrawerItem(context, 'Map', Icons.location_pin, () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => LocationMapScreen(isAdmin: false)),
//               );
//             }),
//             buildDrawerItem(context, 'Highlights', Icons.video_camera_back, () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (context) => LivePage()),
//               // );
//             }),
//             buildDrawerItem(context, 'Events', Icons.event, () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => EventScreen(
//                           isAdmin: false,
//                         )),
//               );
//             }),
//             buildDrawerItem(context, 'Live Streaming', Icons.live_tv, () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => MyHomePage(isAdmin: false)),
//               );
//             }),
//             buildDrawerItem(context, 'Login', Icons.login, () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => RegisterPage()),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildDrawerItem(
//       BuildContext context, String title, IconData icon, Function() onTap) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.black),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 16, // Further reduced font size for the drawer items
//           fontWeight:
//               FontWeight.bold, // Regular font weight for the drawer items
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sports/Screens/HighlightsScreen.dart';
import 'package:flutter_sports/Screens/Organization/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/Organization/LiveStream.dart';
import '../Screens/Organization/LocationScreenOrg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Screens/Event.dart';
import '../Screens/Registration.dart';
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
              padding: EdgeInsets.fromLTRB(
                  16, 16, 16, 8), // Adjusted padding for a smaller header
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the content vertically
                children: [
                  CircleAvatar(
                    radius: 40, // Further reduced the radius for a smaller logo
                    backgroundImage: AssetImage(
                        'assets/images/Elevate_Logo.jpeg'), // Ensure this path is correct
                  ),
                  SizedBox(height: 3),
                  Text(
                    '  Elevate',
                    style: GoogleFonts.bebasNeue(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20, // Reduced font size for better visibility
                        fontWeight:
                            FontWeight.bold, // Use bold to emphasize the title
                      ),
                    ),
                  ),
                  Text(
                    '  Rise above all',
                    style: GoogleFonts.bebasNeue(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize:
                            14, // Further reduced font size for better alignment
                        fontWeight: FontWeight
                            .normal, // Regular font weight for the subtitle
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildDrawerItem(context, 'Gallery', Icons.image, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GalleryWidget(
                          isAdmin: false,
                        )),
              );
            }),
            buildDrawerItem(context, 'Map', Icons.location_pin, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LocationMapScreen(isAdmin: false)),
              );
            }),
            buildDrawerItem(context, 'Highlights', Icons.video_camera_back, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HighlightsScreen(isAdmin:false)),
              );
            }),
            buildDrawerItem(context, 'Events', Icons.event, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EventScreen(
                          isAdmin: false,
                        )),
              );
            }),
            buildDrawerItem(context, 'Live Streaming', Icons.live_tv, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(isAdmin: false)),
              );
            }),
            buildDrawerItem(context, 'Login', Icons.login, () async {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token');
              final organizationJson = prefs.getString('organization');
              Map<String, dynamic>? organization;

              if (organizationJson != null) {
                organization = json.decode(organizationJson);
              }

              if (token != null && token.isNotEmpty) {
                // User is already logged in
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDashboard(
                      organization: organization ?? {}, // Provide default empty map if null
                    ),
                  ),
                );
              } else {
                // User is not logged in, navigate to RegisterPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(
      BuildContext context, String title, IconData icon, Function() onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16, // Further reduced font size for the drawer items
          fontWeight:
              FontWeight.bold, // Regular font weight for the drawer items
        ),
      ),
      onTap: onTap,
    );
  }
}
