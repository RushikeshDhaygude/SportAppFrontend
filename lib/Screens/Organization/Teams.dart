
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../Api/api_constants.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class TeamsWidget extends StatefulWidget {
//   @override
//   _TeamsWidgetState createState() => _TeamsWidgetState();
// }

// class _TeamsWidgetState extends State<TeamsWidget> {
//   Future<List<dynamic>> fetchTeams() async {
//     try {
//       final response = await http.get(
//         Uri.parse(ApiConstants.Teams),
//         headers: {
//           'Authorization': 'Bearer ${await _getToken()}',
//         },
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> teams = json.decode(response.body);
//         return teams;
//       } else {
//         throw Exception('Failed to load teams');
//       }
//     } catch (e) {
//       print('Error fetching teams data: $e');
//       throw e;
//     }
//   }

//   Future<String> _getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token') ?? '';
//   }

//   void _addTeam() async {
//     String teamName = '';
//     String teamCaptain = '';
//     String teamCaptainContact = '';
//     String eventId = '';
//     File? teamLogo;

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add Team'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   decoration: InputDecoration(labelText: 'Team Name'),
//                   onChanged: (value) {
//                     teamName = value;
//                   },
//                 ),
//                 TextField(
//                   decoration: InputDecoration(labelText: 'Team Captain'),
//                   onChanged: (value) {
//                     teamCaptain = value;
//                   },
//                 ),
//                 TextField(
//                   decoration: InputDecoration(labelText: 'Team Captain Contact'),
//                   onChanged: (value) {
//                     teamCaptainContact = value;
//                   },
//                 ),
//                 TextField(
//                   decoration: InputDecoration(labelText: 'Event ID'),
//                   onChanged: (value) {
//                     eventId = value;
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//                     if (pickedFile != null) {
//                       setState(() {
//                         teamLogo = File(pickedFile.path);
//                       });
//                     }
//                   },
//                   child: Text('Upload Team Logo'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Add'),
//               onPressed: () async {
//                 if (teamName.isNotEmpty && teamCaptain.isNotEmpty && teamCaptainContact.isNotEmpty && eventId.isNotEmpty && teamLogo != null) {
//                   var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.Teams));
//                   request.headers['Authorization'] = 'Bearer ${await _getToken()}';
//                   request.fields['teamName'] = teamName;
//                   request.fields['teamCaptain'] = teamCaptain;
//                   request.fields['teamCaptainContact'] = teamCaptainContact;
//                   request.fields['eventId'] = eventId;
//                   request.files.add(await http.MultipartFile.fromPath('teamLogo', teamLogo!.path));

//                   var response = await request.send();

//                   if (response.statusCode == 200) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Team added successfully')));
//                     Navigator.of(context).pop();
//                     setState(() {});
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Failed to add team')));
//                   }
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _editTeam(Map<String, dynamic> team) async {
//     String teamName = team['teamName'];
//     String teamCaptain = team['teamCaptain'];
//     String teamCaptainContact = team['teamCaptainContact'];
//     String eventId = team['eventId'].toString();
//     File? teamLogo;

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit Team'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   decoration: InputDecoration(labelText: 'Team Name'),
//                   onChanged: (value) {
//                     teamName = value;
//                   },
//                   controller: TextEditingController(text: teamName),
//                 ),
//                 TextField(
//                   decoration: InputDecoration(labelText: 'Team Captain'),
//                   onChanged: (value) {
//                     teamCaptain = value;
//                   },
//                   controller: TextEditingController(text: teamCaptain),
//                 ),
//                 TextField(
//                   decoration: InputDecoration(labelText: 'Team Captain Contact'),
//                   onChanged: (value) {
//                     teamCaptainContact = value;
//                   },
//                   controller: TextEditingController(text: teamCaptainContact),
//                 ),
//                 TextField(
//                   decoration: InputDecoration(labelText: 'Event ID'),
//                   onChanged: (value) {
//                     eventId = value;
//                   },
//                   controller: TextEditingController(text: eventId),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//                     if (pickedFile != null) {
//                       setState(() {
//                         teamLogo = File(pickedFile.path);
//                       });
//                     }
//                   },
//                   child: Text('Upload Team Logo'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Save'),
//               onPressed: () async {
//                 if (teamName.isNotEmpty && teamCaptain.isNotEmpty && teamCaptainContact.isNotEmpty && eventId.isNotEmpty) {
//                   var request = http.MultipartRequest('PUT', Uri.parse('${ApiConstants.Teams}/${team['id']}'));
//                   request.headers['Authorization'] = 'Bearer ${await _getToken()}';
//                   request.fields['teamName'] = teamName;
//                   request.fields['teamCaptain'] = teamCaptain;
//                   request.fields['teamCaptainContact'] = teamCaptainContact;
//                   request.fields['eventId'] = eventId;
//                   if (teamLogo != null) {
//                     request.files.add(await http.MultipartFile.fromPath('teamLogo', teamLogo!.path));
//                   }

//                   var response = await request.send();

//                   if (response.statusCode == 200) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Team updated successfully')));
//                     Navigator.of(context).pop();
//                     setState(() {});
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Failed to update team')));
//                   }
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _deleteTeam(int id) async {
//     final response = await http.delete(
//       Uri.parse('${ApiConstants.Teams}/$id'),
//       headers: {
//         'Authorization': 'Bearer ${await _getToken()}',
//       },
//     );

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Team deleted successfully')));
//       setState(() {});
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to delete team')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Teams'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addTeam,
//         child: Icon(Icons.add),
//       ),
//       body: FutureBuilder<List<dynamic>>(
//         future: fetchTeams(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No teams available'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 return buildTeamCard(snapshot.data![index]);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget buildTeamCard(Map<String, dynamic> team) {
//     String teamId = team['id'].toString();
//     String teamName = team['teamName'].trim();
//     String teamCaptain = team['teamCaptain'];
//     String teamCaptainContact = team['teamCaptainContact'];

//     return Card(
//       margin: EdgeInsets.all(10),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 5,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Team ID: $teamId',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   teamName,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () => _editTeam(team),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () => _deleteTeam(team['id']),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             ListTile(
//               leading: CircleAvatar(
//                 backgroundImage: AssetImage('assets/images/Elevate_Logo.jpeg'),
//                 radius: 25,
//               ),
//               title: Text('Captain: $teamCaptain'),
//               subtitle: Text('Contact: $teamCaptainContact'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api/api_constants.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TeamsWidget extends StatefulWidget {
  @override
  _TeamsWidgetState createState() => _TeamsWidgetState();
}

class _TeamsWidgetState extends State<TeamsWidget> {
  Future<List<dynamic>> fetchTeams() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.Teams),
        headers: {
          'Authorization': 'Bearer ${await _getToken()}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> teams = json.decode(response.body);
        return teams;
      } else {
        throw Exception('Failed to load teams');
      }
    } catch (e) {
      print('Error fetching teams data: $e');
      throw e;
    }
  }

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  void _addTeam() async {
    String teamName = '';
    String teamCaptain = '';
    String teamCaptainContact = '';
    String eventId = '';
    File? teamLogo;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Team'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Team Name'),
                  onChanged: (value) {
                    teamName = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Team Captain'),
                  onChanged: (value) {
                    teamCaptain = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Team Captain Contact'),
                  onChanged: (value) {
                    teamCaptainContact = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Event ID'),
                  onChanged: (value) {
                    eventId = value;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        teamLogo = File(pickedFile.path);
                      });
                    }
                  },
                  child: Text('Upload Team Logo'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                if (teamName.isNotEmpty && teamCaptain.isNotEmpty && teamCaptainContact.isNotEmpty && eventId.isNotEmpty && teamLogo != null) {
                  var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.Teams));
                  request.headers['Authorization'] = 'Bearer ${await _getToken()}';
                  request.fields['teamName'] = teamName;
                  request.fields['teamCaptain'] = teamCaptain;
                  request.fields['teamCaptainContact'] = teamCaptainContact;
                  request.fields['eventId'] = eventId;
                  request.files.add(await http.MultipartFile.fromPath('teamLogo', teamLogo!.path));

                  var response = await request.send();

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Team added successfully')));
                    Navigator.of(context).pop();
                    setState(() {});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add team')));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editTeam(Map<String, dynamic> team) async {
    String teamName = team['teamName'];
    String teamCaptain = team['teamCaptain'];
    String teamCaptainContact = team['teamCaptainContact'];
    String eventId = team['eventId'].toString();
    File? teamLogo;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Team'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Team Name'),
                  onChanged: (value) {
                    teamName = value;
                  },
                  controller: TextEditingController(text: teamName),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Team Captain'),
                  onChanged: (value) {
                    teamCaptain = value;
                  },
                  controller: TextEditingController(text: teamCaptain),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Team Captain Contact'),
                  onChanged: (value) {
                    teamCaptainContact = value;
                  },
                  controller: TextEditingController(text: teamCaptainContact),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Event ID'),
                  onChanged: (value) {
                    eventId = value;
                  },
                  controller: TextEditingController(text: eventId),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        teamLogo = File(pickedFile.path);
                      });
                    }
                  },
                  child: Text('Upload Team Logo'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                if (teamName.isNotEmpty && teamCaptain.isNotEmpty && teamCaptainContact.isNotEmpty && eventId.isNotEmpty) {
                  var request = http.MultipartRequest('PUT', Uri.parse('${ApiConstants.Teams}/${team['id']}'));
                  request.headers['Authorization'] = 'Bearer ${await _getToken()}';
                  request.fields['teamName'] = teamName;
                  request.fields['teamCaptain'] = teamCaptain;
                  request.fields['teamCaptainContact'] = teamCaptainContact;
                  request.fields['eventId'] = eventId;
                  if (teamLogo != null) {
                    request.files.add(await http.MultipartFile.fromPath('teamLogo', teamLogo!.path));
                  }

                  var response = await request.send();

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Team updated successfully')));
                    Navigator.of(context).pop();
                    setState(() {});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update team')));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTeam(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.Teams}/$id'),
      headers: {
        'Authorization': 'Bearer ${await _getToken()}',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Team deleted successfully')));
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete team')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teams'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTeam,
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No teams available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return buildTeamCard(snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildTeamCard(Map<String, dynamic> team) {
    String teamId = team['id'].toString();
    String teamName = team['teamName'].trim();
    String teamCaptain = team['teamCaptain'];
    String teamCaptainContact = team['teamCaptainContact'];
    String teamLogoPath = team['teamLogoPath'];

    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team ID: $teamId',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  teamName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editTeam(team),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteTeam(team['id']),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(teamLogoPath),
                radius: 25,
              ),
              title: Text('Captain: $teamCaptain'),
              subtitle: Text('Contact: $teamCaptainContact'),
            ),
          ],
        ),
      ),
    );
  }
}
