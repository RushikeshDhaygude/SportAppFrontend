import 'package:flutter/material.dart';

class FixtureForm extends StatefulWidget {
  @override
  _FixtureFormState createState() => _FixtureFormState();
}

class _FixtureFormState extends State<FixtureForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _eventId = '';
  String _team1Id = '';
  String _team2Id = '';
  DateTime _selectedDateTime = DateTime.now();
  String _gender = '';

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _selectedDateTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fixture Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Event ID'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event ID';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _eventId = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Team 1 ID'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team 1 ID';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _team1Id = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Team 2 ID'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team 2 ID';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _team2Id = value ?? '';
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDateTime == null
                          ? 'No date and time chosen'
                          : 'Selected Date and Time: ${_selectedDateTime.toString()}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDateTime(context),
                    child: Text('Select Date and Time'),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the gender';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _gender = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Send the form data to the server or process it as needed
                    // For example:
                    // createFixture(_eventId, _team1Id, _team2Id, _selectedDateTime, _gender);
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
