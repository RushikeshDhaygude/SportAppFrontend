// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../Api/api_constants.dart';

// class PoolWidget extends StatelessWidget {
//   final int eventId;

//   PoolWidget({required this.eventId});

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
//     return FutureBuilder<List<dynamic>>(
//       future: fetchPools(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No pools available'));
//         } else {
//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               return buildPoolCard(snapshot.data![index]);
//             },
//           );
//         }
//       },
//     );
//   }

//   Widget buildPoolCard(Map<String, dynamic> pool) {
//     String poolName = pool['poolName'];
//     List<dynamic> teams = pool['teams'];

//     return Card(
//       margin: EdgeInsets.all(10),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 5,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Pool: $poolName',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Event: ${pool['event']['eventName']}',
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),
//             SizedBox(height: 16),
//             Table(
//               border: TableBorder.all(color: Colors.grey),
//               columnWidths: {
//                 0: FlexColumnWidth(2),
//                 1: FlexColumnWidth(4),
//                 2: FlexColumnWidth(3),
//               },
//               children: [
//                 TableRow(
//                   decoration: BoxDecoration(color: Colors.grey[200]),
//                   children: [
//                     TableCell(child: Center(child: Text('Team ID'))),
//                     TableCell(child: Center(child: Text('Team Name'))),
//                     TableCell(child: Center(child: Text('Captain Contact'))),
//                   ],
//                 ),
//                 for (var team in teams)
//                   TableRow(
//                     children: [
//                       TableCell(child: Center(child: Text('${team['id']}'))),
//                       TableCell(child: Center(child: Text('${team['teamName']}'))),
//                       TableCell(child: Center(child: Text('${team['teamCaptainContact']}'))),
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
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Api/api_constants.dart';

class PoolWidget extends StatelessWidget {
  final int eventId;

  PoolWidget({required this.eventId});

  Future<List<dynamic>> fetchPools() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.pools}?eventId=$eventId'));

      if (response.statusCode == 200) {
        List<dynamic> pools = json.decode(response.body);
        // Filter pools based on eventId
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
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
              return buildPoolCard(snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  Widget buildPoolCard(Map<String, dynamic> pool) {
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
                Text(
                  'Pool: $poolName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text('Event: ${pool['event']['eventName']}'),
                  backgroundColor: Colors.blueAccent,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  children: [
                    TableCell(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text('ID')),
                    )),
                    TableCell(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text('Team Name')),
                    )),
                    TableCell(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text('Captain Contact')),
                    )),
                  ],
                ),
                for (var team in teams)
                  TableRow(
                    children: [
                      TableCell(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('${team['id']}')),
                      )),
                      TableCell(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('${team['teamName']}')),
                      )),
                      TableCell(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('${team['teamCaptainContact']}')),
                      )),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
