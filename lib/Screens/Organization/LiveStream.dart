// import 'package:flutter/material.dart';
// import 'package:flutter_sports/Api/api_constants.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class OrganizerScreen extends StatefulWidget {
//   @override
//   _OrganizerScreenState createState() => _OrganizerScreenState();
// }

// class _OrganizerScreenState extends State<OrganizerScreen> {
//   RTCPeerConnection? _peerConnection;
//   MediaStream? _localStream;
//   final _localRenderer = RTCVideoRenderer();
//   IO.Socket? socket;
//   bool _isStreaming = false;
//   String _message = 'Press Start to begin streaming';

//   @override
//   void initState() {
//     super.initState();
//     _initializeRenderer();
//     _connectToSocket();
//   }

//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _peerConnection?.close();
//     socket?.disconnect();
//     super.dispose();
//   }

//   Future<void> _initializeRenderer() async {
//     await _localRenderer.initialize();
//   }

//   void _connectToSocket() {
//     socket = IO.io(ApiConstants.signalingServer, <String, dynamic>{
//       'transports': ['websocket'],
//     });

//     socket?.on('connect', (_) {
//       setState(() {
//         _message = 'Connected to signaling server';
//       });
//       print('Connected to signaling server');
//     });

//     socket?.on('disconnect', (_) {
//       setState(() {
//         _message = 'Disconnected from signaling server';
//       });
//       print('Disconnected from signaling server');
//     });

//     socket?.on('offer', (data) async {
//       print('Received offer');
//       await _peerConnection?.setRemoteDescription(
//         RTCSessionDescription(data['sdp'], data['type']),
//       );
//       RTCSessionDescription answer = await _peerConnection!.createAnswer();
//       await _peerConnection?.setLocalDescription(answer);
//       socket?.emit('answer', {
//         'sdp': answer.sdp,
//         'type': answer.type,
//       });
//     });

//     socket?.on('ice-candidate', (data) async {
//       print('Received ICE candidate');
//       await _peerConnection?.addCandidate(
//         RTCIceCandidate(
//             data['candidate'], data['sdpMid'], data['sdpMLineIndex']),
//       );
//     });
//   }

//   Future<void> _createPeerConnection() async {
//     Map<String, dynamic> configuration = {
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'},
//       ],
//     };

//     _peerConnection = await createPeerConnection(configuration);

//     _localStream = await navigator.mediaDevices.getUserMedia({
//       'video': true,
//       'audio': true,
//     });

//     _localRenderer.srcObject = _localStream;
//     _localStream?.getTracks().forEach((track) {
//       _peerConnection?.addTrack(track, _localStream!);
//     });

//     _peerConnection?.onIceCandidate = (candidate) {
//       print('Sending ICE candidate');
//       socket?.emit('ice-candidate', {
//         'candidate': candidate.candidate,
//         'sdpMid': candidate.sdpMid,
//         'sdpMLineIndex': candidate.sdpMLineIndex,
//       });
//     };

//     RTCSessionDescription offer = await _peerConnection!.createOffer();
//     await _peerConnection?.setLocalDescription(offer);
//     socket?.emit('offer', {
//       'sdp': offer.sdp,
//       'type': offer.type,
//     });

//     setState(() {
//       _isStreaming = true;
//       _message = 'Streaming live';
//     });
//   }

//   void _startStreaming() {
//     if (!_isStreaming) {
//       _createPeerConnection();
//     }
//   }

//   void _stopStreaming() {
//     if (_isStreaming) {
//       _peerConnection?.close();
//       _localStream?.dispose();
//       _localRenderer.srcObject = null;
//       setState(() {
//         _isStreaming = false;
//         _message = 'Streaming stopped';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Live Stream (Organizer)'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: Center(
//               child: _isStreaming
//                   ? RTCVideoView(_localRenderer)
//                   : Text(_message),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: _startStreaming,
//                 child: Text('Start'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: _stopStreaming,
//                 child: Text('Stop'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sports/Api/api_constants.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final _idController = TextEditingController(text: 'LiveStreamID');
  bool isHostButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Livestreaming App')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _idController),
              Row(
                children: [
                  Text('Host Button: '),
                  Switch(
                      value: isHostButton,
                      onChanged: (val) {
                        setState(() {
                          isHostButton = !isHostButton;
                        });
                      })
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('Join'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => LivePage(
                    liveID: _idController.text.toString(),
                    isHost: isHostButton,
                  )));
        },
      ),
    );
  }
}

class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;

  const LivePage({Key? key, required this.liveID, this.isHost = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 1543817899,
        appSign: ApiConstants.appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: 'user_id' + Random().nextInt(100).toString(),
        userName: 'user_name' + Random().nextInt(100).toString(),
        liveID: liveID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}