
// import 'package:flutter/material.dart';
// import '../Widgets/event_matches_widget.dart';
// import '../Screens/PoolScreen.dart';
// import '../Widgets/leaderboard_widget.dart';
// import '../Widgets/Resultswidget.dart'; // Import the ResultsWidget

// class EventDetailScreen extends StatefulWidget {
//   final int eventId;

//   EventDetailScreen({required this.eventId});

//   @override
//   _EventDetailScreenState createState() => _EventDetailScreenState();
// }

// class _EventDetailScreenState extends State<EventDetailScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this); // Updated to 4
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Event Details',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(
//               text: 'Matches',
//               icon: Icon(Icons.sports_cricket),
//             ),
//             Tab(
//               text: 'Pools',
//               icon: Icon(Icons.table_chart),
//             ),
//             Tab(
//               text: 'Leaderboard',
//               icon: Icon(Icons.leaderboard),
//             ),
//             Tab(
//               text: 'Results',
//               icon: Icon(Icons.score), // New tab for Results
//             ),
//           ],
//           indicatorColor: Colors.blueAccent,
//           indicatorWeight: 3.0,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: TabBarView(
//           controller: _tabController,
//           children: [
//             EventMatchesWidget(eventId: widget.eventId),
//             PoolWidget(eventId: widget.eventId),
//             LeaderboardWidget(eventId: widget.eventId),
//             ResultsWidget(eventId: widget.eventId), // Add the ResultsWidget
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../Widgets/event_matches_widget.dart';
import '../Screens/PoolScreen.dart';
import '../Widgets/leaderboard_widget.dart';
import '../Widgets/Resultswidget.dart'; // Import the ResultsWidget

class EventDetailScreen extends StatefulWidget {
  final int eventId;
  final bool isAdmin;

  EventDetailScreen({required this.eventId, required this.isAdmin});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Updated to 4
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Matches',
              icon: Icon(Icons.sports_cricket),
            ),
            Tab(
              text: 'Pools',
              icon: Icon(Icons.table_chart),
            ),
            Tab(
              text: 'Leaderboard',
              icon: Icon(Icons.leaderboard),
            ),
            Tab(
              text: 'Results',
              icon: Icon(Icons.score), // New tab for Results
            ),
          ],
          indicatorColor: Colors.blueAccent,
          indicatorWeight: 3.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            EventMatchesWidget(eventId: widget.eventId, isAdmin: widget.isAdmin),
            PoolWidget(eventId: widget.eventId, isAdmin: widget.isAdmin),
            LeaderboardWidget(eventId: widget.eventId, isAdmin: widget.isAdmin),
            ResultsWidget(eventId: widget.eventId, isAdmin: widget.isAdmin), // Add the ResultsWidget
          ],
        ),
      ),
    );
  }
}
