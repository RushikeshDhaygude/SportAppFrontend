import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Api/api_constants.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late Future<List<dynamic>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEventData();
  }

  Future<List<dynamic>> fetchEventData() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.eventApiUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load event data');
      }
    } catch (e) {
      print('Error fetching event data: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: futureEvents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.isEmpty) {
              return Text('No events available');
            } else {
              return EventList(events: snapshot.data!);
            }
          },
        ),
      ),
    );
  }
}

class EventList extends StatelessWidget {
  final List<dynamic> events;

  const EventList({required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(
          eventName: events[index]['eventName'],
          eventDate: events[index]['eventDate'],
          location: events[index]['location'],
          organizationId: events[index]['organizationId'],
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String location;
  final int organizationId;

  const EventCard({
    required this.eventName,
    required this.eventDate,
    required this.location,
    required this.organizationId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(eventName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: $eventDate'),
            Text('Location: $location'),
            // Text('Organization ID: $organizationId'),
          ],
        ),
      ),
    );
  }
}
