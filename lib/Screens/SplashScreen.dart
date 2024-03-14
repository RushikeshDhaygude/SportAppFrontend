import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import the lottie package
import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate some initialization process, like loading data, checking authentication, etc.
    _initializeApp();
  }

  void _initializeApp() async {
    // Simulate some delay to show the splash screen for a few seconds
    await Future.delayed(Duration(seconds: 3));

    // Navigate to the home screen after initialization
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your Lottie animation here
            Lottie.asset(
              'assets/animations/VolleyAnimation.json', // Replace with your Lottie animation file path
              width: 150,
              height: 150,
              // Optionally, you can customize the animation by using parameters like width, height, loop, etc.
            ),
            SizedBox(height: 20),
            Text(
              'Sport Event Management System',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Optional: Loading indicator
          ],
        ),
      ),
    );
  }
}
