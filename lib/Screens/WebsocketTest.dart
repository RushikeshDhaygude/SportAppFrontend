import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketClient extends StatefulWidget {
  @override
  _WebSocketClientState createState() => _WebSocketClientState();
}

class _WebSocketClientState extends State<WebSocketClient> {
  late StompClient stompClient;

  @override
  void initState() {
    super.initState();
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://192.168.43.56:8080/ws',
        onConnect: onConnectCallback,
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
        stompConnectHeaders: {'Authorization': 'Bearer your_token'},
      ),
    );
    stompClient.activate();
  }

  void onConnectCallback(StompFrame frame) {
    print('Connected to WebSocket');
    stompClient.subscribe(
      destination: '/topic/score-updates',
      callback: (StompFrame frame) {
        print('Received message: ${frame.body}');
      },
    );
  }

  @override
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Client'),
      ),
      body: Center(
        child: Text('Listening for updates...'),
      ),
    );
  }
}
