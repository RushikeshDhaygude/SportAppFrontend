

// import 'package:flutter/material.dart';
// import '../Widgets/drawer.dart';
// import '../Widgets/event_list_widget.dart';
// import '../Widgets/gallery_widget.dart';
// import '../Widgets/live_score_card.dart';
// import '../Widgets/match_list_widget.dart';


// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Elevate Sports'),
//         backgroundColor: Colors.yellow,
//       ),
//       drawer: DrawerWidget(),
//       body: ListView(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Welcome to Elevate Sports',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               'Discover Events and Stay Updated!',
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//           SizedBox(height: 16),
//           EventListWidget(),
//           SizedBox(height: 16),
//           GalleryWidget(),
//           SizedBox(height: 16),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               'Upcoming Matches',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(height: 8),
//           MatchListWidget(),
//           LiveScorecardWidget(),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../Widgets/drawer.dart';
import '../Widgets/event_list_widget.dart';
import '../Widgets/gallery_widget.dart';
import '../Widgets/live_score_card.dart';
import '../Widgets/match_list_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elevate Sports'),
        backgroundColor: Colors.yellow,
      ),
      drawer: DrawerWidget(),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Welcome to Elevate Sports',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Discover Events and Stay Updated!',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 16),
          EventListWidget(),
          SizedBox(height: 16),
          GalleryWidget(),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Upcoming Matches',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          MatchListWidget(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: LiveScorecardWidget(),
          ),
        ],
      ),
    );
  }
}
