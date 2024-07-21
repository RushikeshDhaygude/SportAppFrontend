import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api/api_constants.dart';

class ResultsWidget extends StatelessWidget {
  final int eventId;
  final bool isAdmin;

  ResultsWidget({required this.eventId, required this.isAdmin});

  Future<List<dynamic>> fetchResults() async {
    final String apiUrl = '${ApiConstants.finalScorecards}/$eventId';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('GET $apiUrl');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> results = json.decode(response.body);
        return results;
      } else {
        throw Exception('Failed to load results');
      }
    } catch (e) {
      print('Error fetching results data: $e');
      throw e;
    }
  }

  Future<void> addResult(Map<String, dynamic> resultData) async {
    final String apiUrl = ApiConstants.addScoreCards;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(resultData),
      );
      print('POST $apiUrl');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Result added successfully');
      } else {
        throw Exception('Failed to add result: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding result: $e');
      throw e;
    }
  }

  Future<void> editResult(
      String resultId, Map<String, dynamic> resultData) async {
    final String apiUrl = '${ApiConstants.addScoreCards}/$resultId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(resultData),
      );
      print('PUT $apiUrl');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Result edited successfully');
      } else {
        throw Exception('Failed to edit result: ${response.statusCode}');
      }
    } catch (e) {
      print('Error editing result: $e');
      throw e;
    }
  }

  Future<void> deleteResult(String resultId) async {
    final String apiUrl = '${ApiConstants.addScoreCards}/$resultId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('DELETE $apiUrl');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Result deleted successfully');
      } else {
        throw Exception('Failed to delete result: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting result: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        actions: isAdmin
            ? [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => openResultForm(context),
                ),
              ]
            : null,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No results data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return buildResultCard(context, snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildResultCard(BuildContext context, Map<String, dynamic> result) {
    String team1Name = (result['team1']['teamName'] ?? 'Unknown Team 1').trim();
    String team2Name = (result['team2']['teamName'] ?? 'Unknown Team 2').trim();
    String matchResult = result['matchResult'] ?? 'No result';
    String team1Score = result['team1Score']?.toString() ?? 'N/A';
    String team2Score = result['team2Score']?.toString() ?? 'N/A';
    String matchDetails = result['matchDetails'] ?? 'No details available';
    String eventLocation = result['eventLocation'] ?? 'Unknown location';
    String eventDateTime = result['eventDate'] ?? 'Unknown date';

    DateTime parsedDateTime =
        DateTime.tryParse(eventDateTime) ?? DateTime.now();
    String formattedDate = DateFormat.yMMMd().format(parsedDateTime);
    String formattedTime = DateFormat.jm().format(parsedDateTime);

    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$team1Name vs $team2Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.grey[300]),
            buildInfoRow(Icons.sports_score, 'Result', matchResult),
            buildInfoRow(Icons.score, 'Score', '$team1Score - $team2Score'),
            buildInfoRow(Icons.info, 'Details', matchDetails),
            buildInfoRow(Icons.location_on, 'Location', eventLocation),
            buildInfoRow(Icons.calendar_today, 'Date', formattedDate),
            buildInfoRow(Icons.access_time, 'Time', formattedTime),
            if (isAdmin) buildAdminActions(context, result),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  Widget buildAdminActions(BuildContext context, Map<String, dynamic> result) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => openResultForm(context, result: result),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => deleteResult(result['id'].toString()),
        ),
      ],
    );
  }

  void openResultForm(BuildContext context, {Map<String, dynamic>? result}) {
    showDialog(
      context: context,
      builder: (context) => ResultFormDialog(
        eventId: eventId,
        result: result,
        onSave: result == null
            ? addResult
            : (data) => editResult(result['id'].toString(), data),
      ),
    );
  }
}

class ResultFormDialog extends StatefulWidget {
  final int eventId;
  final Map<String, dynamic>? result;
  final Function(Map<String, dynamic>) onSave;

  ResultFormDialog({required this.eventId, this.result, required this.onSave});

  @override
  _ResultFormDialogState createState() => _ResultFormDialogState();
}

class _ResultFormDialogState extends State<ResultFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _matchResultController;
  late TextEditingController _team1ScoreController;
  late TextEditingController _team2ScoreController;
  late TextEditingController _matchDetailsController;
  late TextEditingController _eventLocationController;
  late TextEditingController _eventDateTimeController;
  late TextEditingController _team1IdController; // New controller for Team1 ID
  late TextEditingController _team2IdController; // New controller for Team2 ID
  late String _status = 'FINAL'; // Default status
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  List<String> _statusOptions = [
    'FINAL',
    'LIVE'
  ]; // Status options for dropdown

  @override
  void initState() {
    super.initState();
    _matchResultController =
        TextEditingController(text: widget.result?['matchResult'] ?? '');
    _team1ScoreController = TextEditingController(
        text: widget.result?['team1Score']?.toString() ?? '');
    _team2ScoreController = TextEditingController(
        text: widget.result?['team2Score']?.toString() ?? '');
    _matchDetailsController =
        TextEditingController(text: widget.result?['matchDetails'] ?? '');
    _eventLocationController =
        TextEditingController(text: widget.result?['eventLocation'] ?? '');
    _eventDateTimeController =
        TextEditingController(text: widget.result?['eventDate'] ?? '');
    _team1IdController = TextEditingController(
        text: widget.result?['team1']['id']?.toString() ?? '');
    _team2IdController = TextEditingController(
        text: widget.result?['team2']['id']?.toString() ?? '');
    _status =
        widget.result?['status'] ?? 'FINAL'; // Set default or existing status

    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _matchResultController.dispose();
    _team1ScoreController.dispose();
    _team2ScoreController.dispose();
    _matchDetailsController.dispose();
    _eventLocationController.dispose();
    _eventDateTimeController.dispose();
    _team1IdController.dispose(); // Dispose new controllers
    _team2IdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.result == null ? 'Add Result' : 'Edit Result'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _matchResultController,
                decoration: InputDecoration(labelText: 'Match Result'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter match result';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _team1ScoreController,
                decoration: InputDecoration(labelText: 'Team 1 Score'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team 1 score';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _team2ScoreController,
                decoration: InputDecoration(labelText: 'Team 2 Score'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team 2 score';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _matchDetailsController,
                decoration: InputDecoration(labelText: 'Match Details'),
                maxLines: null, // Allows multiline input
              ),
              TextFormField(
                controller: _eventLocationController,
                decoration: InputDecoration(labelText: 'Event Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _eventDateTimeController,
                decoration: InputDecoration(labelText: 'Event Date and Time'),
                readOnly: true,
                onTap: () => _selectDateTime(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select event date and time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _team1IdController,
                decoration: InputDecoration(labelText: 'Team 1 ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team 1 ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _team2IdController,
                decoration: InputDecoration(labelText: 'Team 2 ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Team 2 ID';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: _status,
                items: _statusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Status'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> formData = {
                      'team1': {
                        'id': int.parse(_team1IdController.text)
                      }, // Updated to parse as int
                      'team2': {
                        'id': int.parse(_team2IdController.text)
                      }, // Updated to parse as int
                      'matchResult': _matchResultController.text,
                      'team1Score': _team1ScoreController.text,
                      'team2Score': _team2ScoreController.text,
                      'matchDetails': _matchDetailsController.text,
                      'status': _status,
                      'event': {'id': widget.eventId},
                      'eventLocation': _eventLocationController.text,
                      'eventDate': DateFormat("yyyy-MM-ddTHH:mm:ss").format(
                          DateTime(
                              _selectedDate.year,
                              _selectedDate.month,
                              _selectedDate.day,
                              _selectedTime.hour,
                              _selectedTime.minute)),
                    };
                    widget.onSave(formData);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

//   Future<void> _selectDateTime(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime.now().subtract(Duration(days: 1)),
//       lastDate: DateTime.now().add(Duration(days: 365)),
//     );

//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }

//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//     );

//     if (pickedTime != null && pickedTime != _selectedTime) {
//       setState(() {
//         _selectedTime = pickedTime;
//       });
//     }

//     setState(() {
//       _eventDateTimeController.text = DateFormat.yMMMd().format(_selectedDate) +
//           ' ' +
//           _selectedTime.format(context);
//     });
//   }
// }
Future<void> _selectDateTime(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime(2000), // Allow selecting dates from the year 2000
    lastDate: DateTime.now().add(Duration(days: 365)),
  );

  if (pickedDate != null) {
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: _selectedTime,
  );

  if (pickedTime != null) {
    setState(() {
      _selectedTime = pickedTime;
    });
  }

  setState(() {
    _eventDateTimeController.text = DateFormat.yMMMd().format(_selectedDate) +
        ' ' +
        _selectedTime.format(context);
  });
}
}