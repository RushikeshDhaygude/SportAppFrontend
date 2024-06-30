import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationDialogWidget extends StatelessWidget {
  final List<RemoteMessage> notifications;
  final VoidCallback onClear;

  NotificationDialogWidget({required this.notifications, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Notifications',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      content: Container(
        width: double.maxFinite,
        child: notifications.isEmpty
            ? Center(
                child: Text(
                  'No notifications available.',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(
                        Icons.notification_important,
                        color: Colors.blue,
                        size: 40,
                      ),
                      title: Text(
                        notifications[index].notification?.title ?? 'No Title',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        notifications[index].notification?.body ?? 'No Body',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: onClear,
          child: Text(
            'Clear All',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
