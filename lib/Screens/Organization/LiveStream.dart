import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sports/Api/api_constants.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class MyHomePage extends StatefulWidget {
  final bool isAdmin;

  MyHomePage({required this.isAdmin});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController(text: 'LiveStreamID');
  final _usernameController = TextEditingController();
  bool isHostButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Livestreaming App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Live Stream ID input field
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'Live Stream ID',
                  prefixIcon: Icon(Icons.live_tv),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Live Stream ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Username input field
              if (!widget.isAdmin) // Show username field if not admin
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 16),

              // Host button toggle
              if (widget.isAdmin) // Show toggle if admin
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Host Button:'),
                    Switch(
                      value: isHostButton,
                      onChanged: (val) {
                        setState(() {
                          isHostButton = val;
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => LivePage(
                liveID: _idController.text,
                isHost: widget.isAdmin ? isHostButton : false,
                username: widget.isAdmin ? 'Admin User' : _usernameController.text,
              ),
            ));
          }
        },
      ),
    );
  }
}

class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;
  final String username;

  const LivePage({Key? key, required this.liveID, this.isHost = false, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 1543817899,
        appSign: ApiConstants.appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: 'user_id' + Random().nextInt(100).toString(),
        userName: username, // Use the entered username
        liveID: liveID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}
