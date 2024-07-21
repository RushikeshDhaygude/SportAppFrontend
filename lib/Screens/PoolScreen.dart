// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../Api/api_constants.dart';

// class PoolWidget extends StatelessWidget {
//   final int eventId;
//   final bool isAdmin;

//   PoolWidget({required this.eventId, required this.isAdmin});

//   Future<List<dynamic>> fetchPools() async {
//     try {
//       final response = await http.get(Uri.parse('${ApiConstants.pools}?eventId=$eventId'));

//       if (response.statusCode == 200) {
//         List<dynamic> pools = json.decode(response.body);
//         // Filter pools based on eventId
//         pools = pools.where((pool) => pool['event']['id'] == eventId).toList();
//         return pools;
//       } else {
//         throw Exception('Failed to load pools');
//       }
//     } catch (e) {
//       print('Error fetching pools data: $e');
//       throw e;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pools'),
//         actions: isAdmin
//             ? [
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: () {
//                     // Add your add pool functionality here
//                   },
//                 ),
//               ]
//             : null,
//       ),
//       body: FutureBuilder<List<dynamic>>(
//         future: fetchPools(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No pools available'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 return buildPoolCard(context, snapshot.data![index]);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget buildPoolCard(BuildContext context, Map<String, dynamic> pool) {
//     String poolName = pool['poolName'];
//     List<dynamic> teams = pool['teams'];

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
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     'Pool: $poolName',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 if (isAdmin)
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.edit),
//                         onPressed: () {
//                           // Add your edit pool functionality here
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () {
//                           // Add your delete pool functionality here
//                         },
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Table(
//               border: TableBorder.all(color: Colors.grey),
//               columnWidths: {
//                 0: FlexColumnWidth(1),
//                 1: FlexColumnWidth(3),
//                 2: FlexColumnWidth(2),
//               },
//               children: [
//                 TableRow(
//                   decoration: BoxDecoration(color: Colors.grey[200]),
//                   children: [
//                     TableCell(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(child: Text('ID')),
//                       ),
//                     ),
//                     TableCell(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(child: Text('Team Name')),
//                       ),
//                     ),
//                     TableCell(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(child: Text('Captain Contact')),
//                       ),
//                     ),
//                   ],
//                 ),
//                 for (var team in teams)
//                   TableRow(
//                     children: [
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Center(child: Text('${team['id']}')),
//                         ),
//                       ),
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Center(child: Text('${team['teamName']}')),
//                         ),
//                       ),
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Center(child: Text('${team['teamCaptainContact']}')),
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Api/api_constants.dart';

// class PoolWidget extends StatelessWidget {
//   final int eventId;
//   final bool isAdmin;

//   PoolWidget({required this.eventId, required this.isAdmin});

//   Future<List<dynamic>> fetchPools() async {
//     try {
//       final response = await http.get(Uri.parse('${ApiConstants.pools}?eventId=$eventId'));

//       if (response.statusCode == 200) {
//         List<dynamic> pools = json.decode(response.body);
//         pools = pools.where((pool) => pool['event']['id'] == eventId).toList();
//         return pools;
//       } else {
//         throw Exception('Failed to load pools');
//       }
//     } catch (e) {
//       print('Error fetching pools data: $e');
//       throw e;
//     }
//   }

//   Future<void> addPool(Map<String, dynamic> poolData) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
//     try {
//       final response = await http.post(
//         Uri.parse(ApiConstants.pools),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode(poolData),
//       );

//       if (response.statusCode == 201) {
//         print('Pool added successfully');
//       } else {
//         throw Exception('Failed to add pool');
//       }
//     } catch (e) {
//       print('Error adding pool: $e');
//       throw e;
//     }
//   }

//   Future<void> editPool(String poolId, Map<String, dynamic> poolData) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
//     try {
//       final response = await http.put(
//         Uri.parse('${ApiConstants.pools}/$poolId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode(poolData),
//       );

//       if (response.statusCode == 200) {
//         print('Pool edited successfully');
//       } else {
//         throw Exception('Failed to edit pool');
//       }
//     } catch (e) {
//       print('Error editing pool: $e');
//       throw e;
//     }
//   }

//   Future<void> deletePool(String poolId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
//     try {
//       final response = await http.delete(
//         Uri.parse('${ApiConstants.pools}/$poolId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         print('Pool deleted successfully');
//       } else {
//         throw Exception('Failed to delete pool');
//       }
//     } catch (e) {
//       print('Error deleting pool: $e');
//       throw e;
//     }
//   }

//   void openPoolForm(BuildContext context, {Map<String, dynamic>? pool}) {
//     showDialog(
//       context: context,
//       builder: (context) => PoolFormDialog(
//         eventId: eventId,
//         pool: pool,
//         onSave: pool == null ? addPool : (data) => editPool(pool['id'].toString(), data),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pools'),
//         actions: isAdmin
//             ? [
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: () => openPoolForm(context),
//                 ),
//               ]
//             : null,
//       ),
//       body: FutureBuilder<List<dynamic>>(
//         future: fetchPools(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No pools available'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 return buildPoolCard(context, snapshot.data![index]);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget buildPoolCard(BuildContext context, Map<String, dynamic> pool) {
//     String poolName = pool['poolName'];
//     List<dynamic> teams = pool['teams'];

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
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     'Pool: $poolName',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 if (isAdmin)
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.edit),
//                         onPressed: () => openPoolForm(context, pool: pool),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () => deletePool(pool['id'].toString()),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Table(
//               border: TableBorder.all(color: Colors.grey),
//               columnWidths: {
//                 0: FlexColumnWidth(1),
//                 1: FlexColumnWidth(3),
//                 2: FlexColumnWidth(2),
//               },
//               children: [
//                 TableRow(
//                   decoration: BoxDecoration(color: Colors.grey[200]),
//                   children: [
//                     TableCell(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(child: Text('ID')),
//                       ),
//                     ),
//                     TableCell(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(child: Text('Team Name')),
//                       ),
//                     ),
//                     TableCell(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(child: Text('Captain Contact')),
//                       ),
//                     ),
//                   ],
//                 ),
//                 for (var team in teams)
//                   TableRow(
//                     children: [
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Center(child: Text('${team['id']}')),
//                         ),
//                       ),
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Center(child: Text('${team['teamName']}')),
//                         ),
//                       ),
//                       TableCell(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Center(child: Text('${team['teamCaptainContact']}')),
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PoolFormDialog extends StatefulWidget {
//   final int eventId;
//   final Map<String, dynamic>? pool;
//   final Function(Map<String, dynamic>) onSave;

//   PoolFormDialog({required this.eventId, this.pool, required this.onSave});

//   @override
//   _PoolFormDialogState createState() => _PoolFormDialogState();
// }

// class _PoolFormDialogState extends State<PoolFormDialog> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _poolNameController;
//   List<int> _teamIds = [];

//   @override
//   void initState() {
//     super.initState();
//     _poolNameController = TextEditingController(text: widget.pool?['poolName'] ?? '');
//     if (widget.pool != null) {
//       _teamIds = List<int>.from(widget.pool!['teams'].map((team) => team['id']));
//     }
//   }

//   @override
//   void dispose() {
//     _poolNameController.dispose();
//     super.dispose();
//   }

//   void _saveForm() {
//     if (_formKey.currentState?.validate() ?? false) {
//       widget.onSave({
//         'poolName': _poolNameController.text,
//         'eventId': widget.eventId,
//         'teamIds': _teamIds,
//       });
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.pool == null ? 'Add Pool' : 'Edit Pool'),
//       content: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               controller: _poolNameController,
//               decoration: InputDecoration(labelText: 'Pool Name'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter Pool Name';
//                 }
//                 return null;
//               },
//             ),
//             // You can add fields to select teams here
//             // For simplicity, we're using a simple text input for team IDs
//             TextFormField(
//               initialValue: _teamIds.join(', '),
//               decoration: InputDecoration(labelText: 'Team IDs (comma separated)'),
//               onChanged: (value) {
//                 _teamIds = value.split(',').map((id) => int.tryParse(id.trim()) ?? 0).toList();
//               },
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: _saveForm,
//           child: Text('Save'),
//         ),
//       ],
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Api/api_constants.dart';

class PoolWidget extends StatelessWidget {
  final int eventId;
  final bool isAdmin;

  PoolWidget({required this.eventId, required this.isAdmin});

  Future<List<dynamic>> fetchPools() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.pools}?eventId=$eventId'));

      if (response.statusCode == 200) {
        List<dynamic> pools = json.decode(response.body);
        pools = pools.where((pool) => pool['event']['id'] == eventId).toList();
        return pools;
      } else {
        throw Exception('Failed to load pools');
      }
    } catch (e) {
      print('Error fetching pools data: $e');
      throw e;
    }
  }

  Future<void> addPool(Map<String, dynamic> poolData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.pools),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(poolData),
      );

      if (response.statusCode == 201) {
        print('Pool added successfully');
      } else {
        throw Exception('Failed to add pool');
      }
    } catch (e) {
      print('Error adding pool: $e');
      throw e;
    }
  }

  Future<void> editPool(String poolId, Map<String, dynamic> poolData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.pools}/$poolId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(poolData),
      );

      if (response.statusCode == 200) {
        print('Pool edited successfully');
      } else {
        throw Exception('Failed to edit pool');
      }
    } catch (e) {
      print('Error editing pool: $e');
      throw e;
    }
  }

  Future<void> deletePool(String poolId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.pools}/$poolId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Pool deleted successfully');
      } else {
        throw Exception('Failed to delete pool');
      }
    } catch (e) {
      print('Error deleting pool: $e');
      throw e;
    }
  }

  void openPoolForm(BuildContext context, {Map<String, dynamic>? pool}) {
    showDialog(
      context: context,
      builder: (context) => PoolFormDialog(
        eventId: eventId,
        pool: pool,
        onSave: pool == null ? addPool : (data) => editPool(pool['id'].toString(), data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pools'),
        actions: isAdmin
            ? [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => openPoolForm(context),
                ),
              ]
            : null,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPools(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No pools available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return buildPoolCard(context, snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildPoolCard(BuildContext context, Map<String, dynamic> pool) {
    String poolName = pool['poolName'];
    List<dynamic> teams = pool['teams'];

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Pool: $poolName',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isAdmin)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => openPoolForm(context, pool: pool),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deletePool(pool['id'].toString()),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DataTable(
                  columnSpacing: 20,
                  dataRowHeight: 60,
                  headingRowHeight: 50,
                  columns: [
                    DataColumn(
                      label: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Logo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Team Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    for (var team in teams)
                      DataRow(
                        cells: [
                          DataCell(
                            ClipOval(
                              child: Image.network(
                                team['teamLogoPath'] ?? '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey.shade200,
                                    child: Icon(Icons.error, size: 30, color: Colors.red),
                                  );
                                },
                              ),
                            ),
                          ),
                          DataCell(Text('${team['teamName']}')),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PoolFormDialog extends StatefulWidget {
  final int eventId;
  final Map<String, dynamic>? pool;
  final Function(Map<String, dynamic>) onSave;

  PoolFormDialog({required this.eventId, this.pool, required this.onSave});

  @override
  _PoolFormDialogState createState() => _PoolFormDialogState();
}

class _PoolFormDialogState extends State<PoolFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _poolNameController;
  List<int> _teamIds = [];

  @override
  void initState() {
    super.initState();
    _poolNameController = TextEditingController(text: widget.pool?['poolName'] ?? '');
    if (widget.pool != null) {
      _teamIds = List<int>.from(widget.pool!['teams'].map((team) => team['id']));
    }
  }

  @override
  void dispose() {
    _poolNameController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'poolName': _poolNameController.text,
        'eventId': widget.eventId,
        'teamIds': _teamIds,
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.pool == null ? 'Add Pool' : 'Edit Pool'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _poolNameController,
              decoration: InputDecoration(labelText: 'Pool Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Pool Name';
                }
                return null;
              },
            ),
            // You can add fields to select teams here
            // For simplicity, we're using a simple text input for team IDs
            TextFormField(
              initialValue: _teamIds.join(', '),
              decoration: InputDecoration(labelText: 'Team IDs (comma separated)'),
              onChanged: (value) {
                _teamIds = value.split(',').map((id) => int.tryParse(id.trim()) ?? 0).toList();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveForm,
          child: Text('Save'),
        ),
      ],
    );
  }
}
