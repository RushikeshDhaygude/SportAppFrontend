import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:convert';
import '../models/match.dart';

class StompService {
  late StompClient stompClient;
  Function(List<Match>) onMatchesUpdated;

  StompService(this.onMatchesUpdated);

  void connect() {
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://192.168.195.73:8080/ws',
        onConnect: onConnectCallback,
        onWebSocketError: onWebSocketError,
        stompConnectHeaders: {'Authorization': 'Bearer your_token'},
      ),
    );
    stompClient.activate();
  }

  void onConnectCallback(StompFrame? frame) {
    print('Connected to WebSocket');

    // Subscribe to match updates
    stompClient.subscribe(
      destination: '/topic/match-updates',
      callback: (StompFrame frame) {
        print('Received message: ${frame.body}');
        List<Match> matches = [];
        Map<String, dynamic> data = json.decode(frame.body ?? '{}');
        String method = data['method'] ?? '';

        if (method == 'POST') {
          matches.add(Match.fromJson(data));
        } else if (method == 'PUT') {
          int index = matches.indexWhere((match) => match.id == data['id']);
          if (index != -1) {
            matches[index] = Match.fromJson(data);
          }
        }

        onMatchesUpdated(matches);
      },
    );
  }

  void onWebSocketError(dynamic error) {
    print('WebSocket Error: $error');
    // Optionally, show an error message in the UI
  }

  void disconnect() {
    stompClient.deactivate();
  }
}
