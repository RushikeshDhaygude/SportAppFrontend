// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import '../Widgets/drawer.dart';
// import '../Widgets/event_list_widget.dart';
// import '../Widgets/gallery_widget.dart';
// import '../Widgets/live_score_card.dart';
// import '../Widgets/match_list_widget.dart';
// import '../Widgets/NotificationIconWidget.dart';
// import '../Widgets/NotificationDialogWidget.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _notificationCount = 0;
//   List<RemoteMessage> _notifications = [];

//   @override
//   void initState() {
//     super.initState();
//     _initializeFirebaseMessaging();
//   }

//   Future<void> _initializeFirebaseMessaging() async {
//     await Firebase.initializeApp();
//     FirebaseMessaging.instance.requestPermission();
//     FirebaseMessaging.instance.getToken().then((token) {
//       print("FCM Token: $token");
//       FirebaseMessaging.instance.subscribeToTopic('all');
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');
//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//       }
//       setState(() {
//         _notificationCount++;
//         _notifications.add(message);
//       });
//     });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     await Firebase.initializeApp();
//     print("Handling a background message: ${message.messageId}");
//   }

//   void _showNotifications() {
//     showDialog(
//       context: context,
//       builder: (context) => NotificationDialogWidget(
//         notifications: _notifications,
//         onClear: _clearNotifications,
//       ),
//     );
//   }

//   void _clearNotifications() {
//     setState(() {
//       _notifications.clear();
//       _notificationCount = 0;
//     });
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Elevate Sports'),
//         backgroundColor: Colors.yellow,
//         actions: [
//           NotificationIconWidget(
//             notificationCount: _notificationCount,
//             onTap: _showNotifications,
//           ),
//         ],
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
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: LiveScorecardWidget(),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../Widgets/drawer.dart';
import '../Widgets/event_list_widget.dart';
import '../Widgets/gallery_widget.dart';
import '../Widgets/live_score_card.dart';
import '../Widgets/match_list_widget.dart';
import '../Widgets/NotificationIconWidget.dart';
import '../Widgets/NotificationDialogWidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _notificationCount = 0;
  List<RemoteMessage> _notifications = [];

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }

  Future<void> _initializeFirebaseMessaging() async {
    await Firebase.initializeApp();
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token");
      FirebaseMessaging.instance.subscribeToTopic('all');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      setState(() {
        _notificationCount++;
        _notifications.add(message);
      });
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => NotificationDialogWidget(
        notifications: _notifications,
        onClear: _clearNotifications,
      ),
    );
  }

  void _clearNotifications() {
    setState(() {
      _notifications.clear();
      _notificationCount = 0;
    });
    Navigator.of(context).pop();
  }

  Future<void> _refreshData() async {
    // Add your refresh logic here. For example, you might re-fetch data from an API.
    // Here, we'll just simulate a network call with a delay.
    await Future.delayed(Duration(seconds: 2));

    // After fetching new data, update the state to reflect the changes
    setState(() {
      // Update your data here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elevate Sports'),
        backgroundColor: Colors.yellow,
        actions: [
          NotificationIconWidget(
            notificationCount: _notificationCount,
            onTap: _showNotifications,
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
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
      ),
    );
  }
}
