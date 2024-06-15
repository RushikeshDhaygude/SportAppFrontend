import 'package:flutter/material.dart';

class ScorecardForm extends StatefulWidget {
  @override
  _ScorecardFormState createState() => _ScorecardFormState();
}

class _ScorecardFormState extends State<ScorecardForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _eventId = 1;
  String _matchResult = '';
  String _team1Score = '';
  String _team2Score = '';
  int _team1Id = 1;
  int _team2Id = 2;
  String _matchDetails = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scorecard Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Event ID'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event ID';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _eventId = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Match Result'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the match result';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _matchResult = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Team 1 Score'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team 1 score';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _team1Score = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Team 2 Score'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team 2 score';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _team2Score = value ?? '';
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Team 1 ID'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team 1 ID';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _team1Id = int.parse(value!);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Team 2 ID'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team 2 ID';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _team2Id = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Match Details'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter match details';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _matchDetails = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Send the form data to the server or process it as needed
                    // For example:
                    // createScorecard(_eventId, _matchResult, _team1Score, _team2Score, _team1Id, _team2Id, _matchDetails);
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
