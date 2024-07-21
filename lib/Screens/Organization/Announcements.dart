import 'package:flutter/material.dart';
import 'package:flutter_sports/Api/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementForm extends StatefulWidget {
  @override
  _AnnouncementFormState createState() => _AnnouncementFormState();
}

class _AnnouncementFormState extends State<AnnouncementForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> _sendAnnouncement() async {
    if (_formKey.currentState!.validate()) {
       final SharedPreferences prefs = await SharedPreferences.getInstance();
       final String? token = prefs.getString('token');
       
      final String url = ApiConstants.AddAnnouncementTopic; // Replace with your actual API URL

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "topic": _topicController.text,
          "title": _titleController.text,
          "message": _messageController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Announcement sent successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send announcement.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Announcement')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _topicController,
                decoration: InputDecoration(labelText: 'Topic'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a topic';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(labelText: 'Message'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendAnnouncement,
                child: Text('Send Announcement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
