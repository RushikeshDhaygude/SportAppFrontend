// import 'package:flutter/material.dart';
// import 'package:flutter_sports/Api/api_constants.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class ViewerScreen extends StatefulWidget {
//   @override
//   _ViewerScreenState createState() => _ViewerScreenState();
// }

// class _ViewerScreenState extends State<ViewerScreen> {
//   RTCPeerConnection? _peerConnection;
//   final _remoteRenderer = RTCVideoRenderer();
//   IO.Socket? socket;
//   String _message = 'Connecting to stream...';

//   @override
//   void initState() {
//     super.initState();
//     _initializeRenderer();
//     _connectToSocket();
//   }

//   @override
//   void dispose() {
//     _remoteRenderer.dispose();
//     _peerConnection?.close();
//     socket?.disconnect();
//     super.dispose();
//   }

//   Future<void> _initializeRenderer() async {
//     await _remoteRenderer.initialize();
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

//     _createPeerConnection();
//   }

//   Future<void> _createPeerConnection() async {
//     Map<String, dynamic> configuration = {
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'},
//       ],
//     };

//     _peerConnection = await createPeerConnection(configuration);

//     socket?.on('ice-candidate', (data) {
//       var candidate = RTCIceCandidate(
//         data['candidate'],
//         data['sdpMid'],
//         data['sdpMLineIndex'],
//       );
//       _peerConnection?.addCandidate(candidate);
//     });

//     _peerConnection?.onTrack = (RTCTrackEvent event) {
//       if (event.track.kind == 'video') {
//         setState(() {
//           _remoteRenderer.srcObject = event.streams[0];
//           _message = 'Live stream started';
//         });
//       }
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Live Stream (Viewer)'),
//       ),
//       body: Center(
//         child: _remoteRenderer.srcObject == null
//             ? Text(_message)
//             : RTCVideoView(_remoteRenderer),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_sports/Api/api_constants.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';


void jumpToLivePage(BuildContext context, {required bool isHost}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LivePage(isHost: isHost)));
}

class LivePage extends StatelessWidget {
  const LivePage({Key? key, this.isHost = false}) : super(key: key);
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID:  1543817899, // use your appID
        appSign: ApiConstants.appSign, // use your appSign
        userID: "Rushikesh",
        userName: 'Rushikesh',
        liveID: 'testLiveID',
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}