import 'package:flutter/material.dart';
import 'package:flutter_sports/Api/api_constants.dart';
import 'package:flutter_sports/Screens/Organization/Dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _organizationIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String organizationId = _organizationIdController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse(ApiConstants.LoginApi),
      body: {
        'organizationId': organizationId,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final String token = responseBody['token'];
      final Map<String, dynamic> organization = responseBody['organization'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('organization', json.encode(organization));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard(organization: organization)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
