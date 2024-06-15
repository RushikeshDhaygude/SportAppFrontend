import 'package:flutter/material.dart';

class EventListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildEventWidget('Volleyball', Icons.sports_volleyball),
          buildEventWidget('Cricket', Icons.sports_cricket),
          buildEventWidget('Basketball', Icons.sports_basketball),
          buildEventWidget('Baseball', Icons.sports_baseball),
          buildEventWidget('Table Tennis', Icons.sports_tennis),
          buildEventWidget('Football', Icons.sports_football),
        ],
      ),
    );
  }

  Widget buildEventWidget(String eventName, IconData iconData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Icon(
            iconData,
            size: 50,
            color: Colors.grey,
          ),
          SizedBox(height: 4),
          Text(
            eventName,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
