import 'package:flutter/material.dart';
import 'package:flutter_sports/Api/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import this for jsonEncode

import 'Login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _organizationIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    final String organizationId = _organizationIdController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse(ApiConstants.RegisterApi),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'organizationId': organizationId,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Registration initiated. Please wait for admin confirmation.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid organization ID or email')));
    }
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _organizationIdController,
              decoration: InputDecoration(labelText: 'Organization ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            TextButton(
              onPressed: _navigateToLogin,
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
