// import 'package:flutter/material.dart';

// class FixtureForm extends StatefulWidget {
//   final int eventId;
//   final Map<String, dynamic>? match;
//   final Function(Map<String, dynamic>) onSave;

//   FixtureForm({required this.eventId, this.match, required this.onSave});

//   @override
//   _FixtureFormState createState() => _FixtureFormState();
// }

// class _FixtureFormState extends State<FixtureForm> {
//   final _formKey = GlobalKey<FormState>();
//   late int _team1Id;
//   late int _team2Id;
//   late DateTime _dateTime;
//   late String _gender;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.match != null) {
//       _team1Id = widget.match!['team1Id'];
//       _team2Id = widget.match!['team2Id'];
//       _dateTime = DateTime.parse(widget.match!['dateTime']);
//       _gender = widget.match!['gender'];
//     } else {
//       _team1Id = 0;
//       _team2Id = 0;
//       _dateTime = DateTime.now();
//       _gender = 'Male';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.match == null ? 'Add Match' : 'Edit Match'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 initialValue: widget.eventId.toString(),
//                 readOnly: true,
//                 decoration: InputDecoration(labelText: 'Event ID'),
//               ),
//               TextFormField(
//                 initialValue: _team1Id.toString(),
//                 decoration: InputDecoration(labelText: 'Team 1 ID'),
//                 onSaved: (value) => _team1Id = int.parse(value!),
//               ),
//               TextFormField(
//                 initialValue: _team2Id.toString(),
//                 decoration: InputDecoration(labelText: 'Team 2 ID'),
//                 onSaved: (value) => _team2Id = int.parse(value!),
//               ),
//               TextFormField(
//                 initialValue: _dateTime.toIso8601String(),
//                 decoration: InputDecoration(labelText: 'Date and Time'),
//                 onSaved: (value) => _dateTime = DateTime.parse(value!),
//               ),
//               TextFormField(
//                 initialValue: _gender,
//                 decoration: InputDecoration(labelText: 'Gender'),
//                 onSaved: (value) => _gender = value!,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     widget.onSave({
//                       'eventId': widget.eventId,
//                       'team1Id': _team1Id,
//                       'team2Id': _team2Id,
//                       'dateTime': _dateTime.toIso8601String(),
//                       'gender': _gender,
//                     });
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 child: Text('Save'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class FixtureForm extends StatefulWidget {
  final int eventId;
  final Map<String, dynamic>? match;
  final Function(Map<String, dynamic>) onSave;

  FixtureForm({required this.eventId, this.match, required this.onSave});

  @override
  _FixtureFormState createState() => _FixtureFormState();
}

class _FixtureFormState extends State<FixtureForm> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDateTime;
  late int _team1Id;
  late int _team2Id;
  late String _gender;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.match != null
        ? DateTime.parse(widget.match!['dateTime'])
        : DateTime.now();
    _team1Id = widget.match?['team1Id'] ?? 0;
    _team2Id = widget.match?['team2Id'] ?? 0;
    _gender = widget.match?['gender'] ?? '';
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSave({
        'team1Id': _team1Id,
        'team2Id': _team2Id,
        'dateTime': _selectedDateTime.toIso8601String(),
        'gender': _gender,
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.match != null ? 'Edit Match' : 'Add Match'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.match?['team1Id']?.toString() ?? '',
                decoration: InputDecoration(labelText: 'Team 1 ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team 1 ID';
                  }
                  return null;
                },
                onSaved: (value) => _team1Id = int.parse(value!),
              ),
              TextFormField(
                initialValue: widget.match?['team2Id']?.toString() ?? '',
                decoration: InputDecoration(labelText: 'Team 2 ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team 2 ID';
                  }
                  return null;
                },
                onSaved: (value) => _team2Id = int.parse(value!),
              ),
              TextFormField(
                initialValue: widget.match?['gender'] ?? '',
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter gender';
                  }
                  return null;
                },
                onSaved: (value) => _gender = value!,
              ),
              Row(
                children: [
                  Text('Date and Time: ${_selectedDateTime.toLocal().toString().split(' ')[0]} ${_selectedDateTime.toLocal().toString().split(' ')[1].split('.')[0]}'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDateTime(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
