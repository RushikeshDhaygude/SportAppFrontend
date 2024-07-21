
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Api/api_constants.dart';
// import '../Screens/EventDetailScreen.dart';

// class EventScreen extends StatefulWidget {
//   final bool isAdmin;

//   EventScreen({required this.isAdmin});

//   @override
//   _EventScreenState createState() => _EventScreenState();
// }

// class _EventScreenState extends State<EventScreen> {
//   late Future<List<dynamic>> futureEvents;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   String _organizationId = '';
//   String _eventName = '';
//   DateTime _selectedDate = DateTime.now();
//   String _location = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadOrganizationId();
//     futureEvents = fetchEventData();
//   }

//   Future<void> _loadOrganizationId() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? organization = prefs.getString('organization');
//     if (organization != null) {
//       setState(() {
//         _organizationId = json.decode(organization)['id'].toString();
//       });
//       futureEvents = fetchEventData();
//     }
//   }

//   Future<List<dynamic>> fetchEventData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('token');
//     if (token == null) return [];

//     final String apiUrl = '${ApiConstants.eventApiUrl}?organizationId=$_organizationId';

//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load event data');
//     }
//   }

//   Future<void> _saveEvent({String? eventId}) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('token');
//     if (token == null) return;

//     final String apiUrl = eventId == null
//         ? ApiConstants.AddEvent
//         : '${ApiConstants.UpdateEvent}/$eventId';

//     final Map<String, dynamic> eventData = {
//       'eventName': _eventName,
//       'eventDate': _selectedDate.toIso8601String().substring(0, 10),
//       'location': _location,
//       'organizationId': _organizationId,
//     };

//     final response = eventId == null
//         ? await http.post(
//             Uri.parse(apiUrl),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonEncode(eventData),
//           )
//         : await http.put(
//             Uri.parse(apiUrl),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonEncode(eventData),
//           );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Event ${eventId == null ? 'created' : 'updated'} successfully'),
//         backgroundColor: Colors.green,
//       ));
//       Navigator.pop(context);
//       setState(() {
//         futureEvents = fetchEventData();
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Failed to ${eventId == null ? 'create' : 'update'} event. Please try again.'),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }

//   Future<void> _deleteEvent(String eventId) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('token');
//     if (token == null) return;

//     final String apiUrl = '${ApiConstants.DeleteEvent}/$eventId';

//     final response = await http.delete(
//       Uri.parse(apiUrl),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200 || response.statusCode == 204) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Event deleted successfully'),
//         backgroundColor: Colors.green,
//       ));
//       setState(() {
//         futureEvents = fetchEventData();
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Failed to delete event. Please try again.'),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }

//   Future<void> _editEvent(Map<String, dynamic> event) async {
//     setState(() {
//       _eventName = event['eventName'];
//       _selectedDate = DateTime.parse(event['eventDate']);
//       _location = event['location'];
//     });

//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               shrinkWrap: true,
//               children: <Widget>[
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Organization ID'),
//                   initialValue: _organizationId,
//                   readOnly: true,
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Event Name'),
//                   validator: (String? value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the event name';
//                     }
//                     return null;
//                   },
//                   onSaved: (String? value) {
//                     _eventName = value ?? '';
//                   },
//                   initialValue: _eventName,
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Text(
//                         'Selected Date: ${_selectedDate.toString().substring(0, 10)}',
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () => _selectDate(context),
//                       child: Text('Select Date'),
//                     ),
//                   ],
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Location'),
//                   validator: (String? value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the location';
//                     }
//                     return null;
//                   },
//                   onSaved: (String? value) {
//                     _location = value ?? '';
//                   },
//                   initialValue: _location,
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       _formKey.currentState!.save();
//                       _saveEvent(eventId: event['id'].toString());
//                     }
//                   },
//                   child: Text('Update'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedDate)
//       setState(() {
//         _selectedDate = picked;
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Events'),
//         centerTitle: true, // Center the title for a better look
//       ),
//       body: Center(
//         child: FutureBuilder<List<dynamic>>(
//           future: futureEvents,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Text('No events available');
//             } else {
//               return EventList(events: snapshot.data!, isAdmin: widget.isAdmin, editEvent: _editEvent, deleteEvent: _deleteEvent);
//             }
//           },
//         ),
//       ),
//       floatingActionButton: widget.isAdmin
//           ? FloatingActionButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => Dialog(
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Form(
//                         key: _formKey,
//                         child: ListView(
//                           shrinkWrap: true,
//                           children: <Widget>[
//                             TextFormField(
//                               decoration: InputDecoration(labelText: 'Organization ID'),
//                               initialValue: _organizationId,
//                               readOnly: true,
//                             ),
//                             TextFormField(
//                               decoration: InputDecoration(labelText: 'Event Name'),
//                               validator: (String? value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter the event name';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (String? value) {
//                                 _eventName = value ?? '';
//                               },
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   child: Text(
//                                     'Selected Date: ${_selectedDate.toString().substring(0, 10)}',
//                                   ),
//                                 ),
//                                 TextButton(
//                                   onPressed: () => _selectDate(context),
//                                   child: Text('Select Date'),
//                                 ),
//                               ],
//                             ),
//                             TextFormField(
//                               decoration: InputDecoration(labelText: 'Location'),
//                               validator: (String? value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter the location';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (String? value) {
//                                 _location = value ?? '';
//                               },
//                             ),
//                             SizedBox(height: 20),
//                             ElevatedButton(
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   _formKey.currentState!.save();
//                                   _saveEvent(); // Call function to save event
//                                 }
//                               },
//                               child: Text('Submit'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               child: Icon(Icons.add),
//             )
//           : null,
//     );
//   }
// }

// class EventList extends StatelessWidget {
//   final List<dynamic> events;
//   final bool isAdmin;
//   final Function(Map<String, dynamic>) editEvent;
//   final Function(String) deleteEvent;

//   EventList({
//     required this.events,
//     required this.isAdmin,
//     required this.editEvent,
//     required this.deleteEvent,
//   });
// @override
// Widget build(BuildContext context) {
//   return ListView.builder(
//     itemCount: events.length,
//     itemBuilder: (context, index) {
//       final event = events[index];
//       return Card(
//         margin: EdgeInsets.all(10),
//         child: Padding(
//           padding: EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 event['eventName'],
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 5),
//               Text(
//                 'Date: ${event['eventDate']}',
//                 style: TextStyle(fontSize: 16),
//               ),
//               Text(
//                 'Location: ${event['location']}',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EventDetailScreen(eventId: event['id'],isAdmin: isAdmin,),
//                         ),
//                       );
//                     },
//                     child: Text('View Details'),
//                   ),
//                   if (isAdmin)
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () {
//                             editEvent(event);
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () {
//                             deleteEvent(event['id'].toString());
//                           },
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api/api_constants.dart';
import '../Screens/EventDetailScreen.dart';

class EventScreen extends StatefulWidget {
  final bool isAdmin;

  EventScreen({required this.isAdmin});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late Future<List<dynamic>> futureEvents;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _organizationId = '';
  String _eventName = '';
  DateTime _selectedDate = DateTime.now();
  String _location = '';

  @override
  void initState() {
    super.initState();
    _loadOrganizationId();
    futureEvents = fetchEventData();
  }

  Future<void> _loadOrganizationId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? organization = prefs.getString('organization');
    if (organization != null) {
      setState(() {
        _organizationId = json.decode(organization)['id'].toString();
      });
      futureEvents = fetchEventData();
    }
  }

  Future<List<dynamic>> fetchEventData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) return [];

    final String apiUrl = '${ApiConstants.eventApiUrl}?organizationId=$_organizationId';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load event data');
    }
  }

  Future<void> _saveEvent({String? eventId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) return;

    final String apiUrl = eventId == null
        ? ApiConstants.AddEvent
        : '${ApiConstants.UpdateEvent}/$eventId';

    final Map<String, dynamic> eventData = {
      'eventName': _eventName,
      'eventDate': _selectedDate.toIso8601String().substring(0, 10),
      'location': _location,
      'organizationId': _organizationId,
    };

    final response = eventId == null
        ? await http.post(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(eventData),
          )
        : await http.put(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(eventData),
          );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Event ${eventId == null ? 'created' : 'updated'} successfully'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
      setState(() {
        futureEvents = fetchEventData();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to ${eventId == null ? 'create' : 'update'} event. Please try again.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _deleteEvent(String eventId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) return;

    final String apiUrl = '${ApiConstants.DeleteEvent}/$eventId';

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Event deleted successfully'),
        backgroundColor: Colors.green,
      ));
      setState(() {
        futureEvents = fetchEventData();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete event. Please try again.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _editEvent(Map<String, dynamic> event) async {
    setState(() {
      _eventName = event['eventName'];
      _selectedDate = DateTime.parse(event['eventDate']);
      _location = event['location'];
    });

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Organization ID'),
                  initialValue: _organizationId,
                  readOnly: true,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Event Name'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event name';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _eventName = value ?? '';
                  },
                  initialValue: _eventName,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Selected Date: ${_selectedDate.toString().substring(0, 10)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select Date'),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _location = value ?? '';
                  },
                  initialValue: _location,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _saveEvent(eventId: event['id'].toString());
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        centerTitle: true, // Center the title for a better look
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: futureEvents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No events available');
            } else {
              return EventList(
                events: snapshot.data!,
                isAdmin: widget.isAdmin,
                editEvent: _editEvent,
                deleteEvent: _deleteEvent,
              );
            }
          },
        ),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Organization ID'),
                              initialValue: _organizationId,
                              readOnly: true,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Event Name'),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the event name';
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                _eventName = value ?? '';
                              },
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Selected Date: ${_selectedDate.toString().substring(0, 10)}',
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text('Select Date'),
                                ),
                              ],
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Location'),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the location';
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                _location = value ?? '';
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  _saveEvent(); // Call function to save event
                                }
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}

class EventList extends StatelessWidget {
  final List<dynamic> events;
  final bool isAdmin;
  final Function(Map<String, dynamic>) editEvent;
  final Function(String) deleteEvent;

  EventList({
    required this.events,
    required this.isAdmin,
    required this.editEvent,
    required this.deleteEvent,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event ID: ${event['id']}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  event['eventName'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Date: ${event['eventDate']}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Location: ${event['location']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailScreen(
                              eventId: event['id'],
                              isAdmin: isAdmin,
                            ),
                          ),
                        );
                      },
                      child: Text('View Details'),
                    ),
                    if (isAdmin)
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              editEvent(event);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteEvent(event['id'].toString());
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
