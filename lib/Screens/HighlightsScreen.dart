// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class HighlightsScreen extends StatefulWidget {
//   final bool isAdmin;

//   HighlightsScreen({required this.isAdmin});

//   @override
//   _HighlightsScreenState createState() => _HighlightsScreenState();
// }

// class _HighlightsScreenState extends State<HighlightsScreen> {
//   late Future<List<Highlight>> futureHighlights;

//   @override
//   void initState() {
//     super.initState();
//     futureHighlights = fetchHighlights();
//   }

//   Future<List<Highlight>> fetchHighlights() async {
//     final response = await http.get(Uri.parse('https://sportappapi-production.up.railway.app/api/highlights'));

//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((highlight) => Highlight.fromJson(highlight)).toList();
//     } else {
//       throw Exception('Failed to load highlights');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Highlights'),
//         actions: widget.isAdmin
//             ? [
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: () {
//                     // Handle add action
//                   },
//                 ),
//               ]
//             : [],
//       ),
//       body: FutureBuilder<List<Highlight>>(
//         future: futureHighlights,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 return HighlightWidget(highlight: snapshot.data![index], isAdmin: widget.isAdmin);
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text("${snapshot.error}"));
//           }

//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }

// class Highlight {
//   final int id;
//   final int organizationId;
//   final String videoFilePath;
//   final String details;
//   final int likes;

//   Highlight({
//     required this.id,
//     required this.organizationId,
//     required this.videoFilePath,
//     required this.details,
//     required this.likes,
//   });

//   factory Highlight.fromJson(Map<String, dynamic> json) {
//     return Highlight(
//       id: json['id'],
//       organizationId: json['organizationId'],
//       videoFilePath: json['videoFilePath'],
//       details: json['details'],
//       likes: json['likes'],
//     );
//   }
// }

// class HighlightWidget extends StatefulWidget {
//   final Highlight highlight;
//   final bool isAdmin;

//   HighlightWidget({required this.highlight, required this.isAdmin});

//   @override
//   _HighlightWidgetState createState() => _HighlightWidgetState();
// }

// class _HighlightWidgetState extends State<HighlightWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool isLiked = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.highlight.videoFilePath);
//     _initializeVideoPlayerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         children: [
//           FutureBuilder(
//             future: _initializeVideoPlayerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 );
//               } else {
//                 return CircularProgressIndicator();
//               }
//             },
//           ),
//           VideoPlayerControls(controller: _controller),
//           ListTile(
//             title: Text(widget.highlight.details),
//             subtitle: Row(
//               children: [
//                 Text('Likes: ${widget.highlight.likes}'),
//                 IconButton(
//                   icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
//                   onPressed: () {
//                     setState(() {
//                       isLiked = !isLiked;
//                     });
//                   },
//                 ),
//                 if (widget.isAdmin) ...[
//                   IconButton(
//                     icon: Icon(Icons.edit),
//                     onPressed: () {
//                       // Handle edit action
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () {
//                       // Handle delete action
//                     },
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class VideoPlayerControls extends StatelessWidget {
//   final VideoPlayerController controller;

//   VideoPlayerControls({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           icon: Icon(
//             controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//           ),
//           onPressed: () {
//             controller.value.isPlaying ? controller.pause() : controller.play();
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.stop),
//           onPressed: () {
//             controller.seekTo(Duration.zero);
//             controller.pause();
//           },
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class HighlightsScreen extends StatefulWidget {
  final bool isAdmin;

  HighlightsScreen({required this.isAdmin});

  @override
  _HighlightsScreenState createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  late Future<List<Highlight>> futureHighlights;

  @override
  void initState() {
    super.initState();
    futureHighlights = fetchHighlights();
  }

  Future<List<Highlight>> fetchHighlights() async {
    final response = await http.get(Uri.parse('https://sportappapi-production.up.railway.app/api/highlights/organization/103'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((highlight) => Highlight.fromJson(highlight)).toList();
    } else {
      throw Exception('Failed to load highlights');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Highlights'),
        actions: widget.isAdmin
            ? [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    await _showAddHighlightDialog(context);
                    setState(() {
                      futureHighlights = fetchHighlights();
                    });
                  },
                ),
              ]
            : [],
      ),
      body: FutureBuilder<List<Highlight>>(
        future: futureHighlights,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return HighlightWidget(
                  highlight: snapshot.data![index],
                  isAdmin: widget.isAdmin,
                  onEdit: () {
                    setState(() {
                      futureHighlights = fetchHighlights();
                    });
                  },
                  onDelete: () {
                    setState(() {
                      futureHighlights = fetchHighlights();
                    });
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> _showAddHighlightDialog(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    final TextEditingController detailsController = TextEditingController();

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      int organizationId = prefs.getInt('organizationId') ?? 0;

      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Highlight'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Details:'),
                  TextField(
                    controller: detailsController,
                    decoration: InputDecoration(hintText: 'Enter details'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Add'),
                onPressed: () async {
                  await _addHighlight(file, organizationId, detailsController.text, token);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _addHighlight(File file, int organizationId, String details, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://sportappapi-production.up.railway.app/api/highlights/upload'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['organizationId'] = '103';
    request.fields['details'] = details;
    

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Highlight added successfully');
    } else {
      print('Failed to add highlight');
    }
  }
}

class Highlight {
  final int id;
  final int organizationId;
  final String videoFilePath;
  final String details;
  final int likes;

  Highlight({
    required this.id,
    required this.organizationId,
    required this.videoFilePath,
    required this.details,
    required this.likes,
  });

  factory Highlight.fromJson(Map<String, dynamic> json) {
    return Highlight(
      id: json['id'],
      organizationId: json['organizationId'],
      videoFilePath: json['videoFilePath'],
      details: json['details'],
      likes: json['likes'],
    );
  }
}

class HighlightWidget extends StatefulWidget {
  final Highlight highlight;
  final bool isAdmin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  HighlightWidget({
    required this.highlight,
    required this.isAdmin,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _HighlightWidgetState createState() => _HighlightWidgetState();
}

class _HighlightWidgetState extends State<HighlightWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.highlight.videoFilePath);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          VideoPlayerControls(controller: _controller),
          ListTile(
            title: Text(widget.highlight.details),
            subtitle: Row(
              children: [
                Text('Likes: ${widget.highlight.likes}'),
                IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
                if (widget.isAdmin) ...[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await _showEditHighlightDialog(context);
                      widget.onEdit();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await _deleteHighlight(widget.highlight.id);
                      widget.onDelete();
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditHighlightDialog(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    final TextEditingController detailsController = TextEditingController(text: widget.highlight.details);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      int organizationId = 103;

      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Highlight'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Details:'),
                  TextField(
                    controller: detailsController,
                    decoration: InputDecoration(hintText: 'Enter details'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () async {
                  await _editHighlight(widget.highlight.id, file, organizationId, detailsController.text, token);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _editHighlight(int id, File file, int organizationId, String details, String token) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('https://sportappapi-production.up.railway.app/api/highlights/103'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['organizationId'] = organizationId.toString();
    request.fields['details'] = details;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Highlight edited successfully');
    } else {
      print('Failed to edit highlight');
    }
  }

  Future<void> _deleteHighlight(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    final response = await http.delete(
      Uri.parse('https://sportappapi-production.up.railway.app/api/highlights/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Highlight deleted successfully');
    } else {
      print('Failed to delete highlight');
    }
  }
}

class VideoPlayerControls extends StatelessWidget {
  final VideoPlayerController controller;

  VideoPlayerControls({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        IconButton(
          icon: Icon(Icons.stop),
          onPressed: () {
            controller.seekTo(Duration.zero);
            controller.pause();
          },
        ),
      ],
    );
  }
}
