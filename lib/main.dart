import 'package:flutter/material.dart';
import 'Screens/SplashScreen.dart'; // Import your SplashScreen widget
import 'Screens/WebsocketTest.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sport Event Management System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen() // Set SplashScreen as the home screen
        );
  }
}
