// import 'package:flutter/material.dart';
// import 'package:flutter_sports/Api/api_constants.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class Location {
//   final int id;
//   final String name;
//   final double latitude;
//   final double longitude;

//   Location({
//     required this.id,
//     required this.name,
//     required this.latitude,
//     required this.longitude,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       id: json['id'],
//       name: json['name'],
//       latitude: json['latitude'],
//       longitude: json['longitude'],
//     );
//   }
// }

// class LocationMapScreen extends StatefulWidget {
//   @override
//   _LocationMapScreenState createState() => _LocationMapScreenState();
// }

// class _LocationMapScreenState extends State<LocationMapScreen> {
//   late GoogleMapController mapController;
//   final Set<Marker> _markers = {};
//   static const LatLng _center = const LatLng(18.4576331, 73.8509006);
//   LatLng? _selectedLocation;
//   TextEditingController _locationNameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchLocations();
//   }

//   Future<void> _fetchLocations() async {
//     try {
//       final response = await http.get(
//         Uri.parse(ApiConstants.locationsApi),
//         headers: {
//           'Authorization': 'Bearer ${await _getToken()}',
//         },
//       );
//       if (response.statusCode == 200) {
//         List<dynamic> locations = json.decode(response.body);
//         setState(() {
//           _markers.clear();
//           for (var location in locations) {
//             final loc = Location.fromJson(location);
//             _markers.add(Marker(
//               markerId: MarkerId(loc.id.toString()),
//               position: LatLng(loc.latitude, loc.longitude),
//               infoWindow: InfoWindow(
//                 title: loc.name,
//                 snippet: 'Tap to delete',
//                 onTap: () => _deleteLocation(loc.id),
//               ),
//             ));
//           }
//         });
//       } else {
//         throw Exception('Failed to load locations');
//       }
//     } catch (e) {
//       print('Error fetching locations: $e');
//     }
//   }

//   Future<String> _getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token') ?? '';
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   void _onTap(LatLng location) {
//     setState(() {
//       _selectedLocation = location;
//       _locationNameController.clear();
//     });
//     _showAddLocationDialog();
//   }

//   void _showAddLocationDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add Location'),
//           content: TextField(
//             controller: _locationNameController,
//             decoration: InputDecoration(labelText: 'Location Name'),
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
//               onPressed: () {
//                 _addLocation();
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _addLocation() async {
//     if (_selectedLocation != null && _locationNameController.text.isNotEmpty) {
//       final String name = _locationNameController.text;
//       final response = await http.post(
//         Uri.parse(ApiConstants.locationsApi),
//         headers: {
//           'Authorization': 'Bearer ${await _getToken()}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'name': name,
//           'latitude': _selectedLocation!.latitude,
//           'longitude': _selectedLocation!.longitude,
//         }),
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Location added successfully')));
//         _fetchLocations();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to add location')));
//       }
//     }
//   }

//   Future<void> _deleteLocation(int id) async {
//     final response = await http.delete(
//       Uri.parse('${ApiConstants.locationsApi}/$id'),
//       headers: {
//         'Authorization': 'Bearer ${await _getToken()}',
//       },
//     );

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Location deleted successfully')));
//       _fetchLocations();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to delete location')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Locations Map'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: _selectedLocation == null ? null : _showAddLocationDialog,
//           ),
//         ],
//       ),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: _center,
//           zoom: 10.0,
//         ),
//         markers: _markers,
//         onTap: _onTap,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_sports/Api/api_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Location {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class LocationMapScreen extends StatefulWidget {
  final bool isAdmin;

  LocationMapScreen({required this.isAdmin});

  @override
  _LocationMapScreenState createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  static const LatLng _center = const LatLng(18.4576331, 73.8509006);
  LatLng? _selectedLocation;
  TextEditingController _locationNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.locationsApi),
        headers: {
          'Authorization': 'Bearer ${await _getToken()}',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> locations = json.decode(response.body);
        setState(() {
          _markers.clear();
          for (var location in locations) {
            final loc = Location.fromJson(location);
            _markers.add(Marker(
              markerId: MarkerId(loc.id.toString()),
              position: LatLng(loc.latitude, loc.longitude),
              infoWindow: InfoWindow(
                title: loc.name,
                snippet: widget.isAdmin ? 'Tap to delete' : null,
                onTap: widget.isAdmin ? () => _deleteLocation(loc.id) : null,
              ),
            ));
          }
        });
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _showAllMarkers();
  }

  void _onTap(LatLng location) {
    if (widget.isAdmin) {
      setState(() {
        _selectedLocation = location;
        _locationNameController.clear();
      });
      _showAddLocationDialog();
    }
  }

  void _showAllMarkers() {
    for (var marker in _markers) {
      mapController.showMarkerInfoWindow(marker.markerId);
    }
  }

  void _showAddLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Location'),
          content: TextField(
            controller: _locationNameController,
            decoration: InputDecoration(labelText: 'Location Name'),
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
              onPressed: () {
                _addLocation();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addLocation() async {
    if (_selectedLocation != null && _locationNameController.text.isNotEmpty) {
      final String name = _locationNameController.text;
      final response = await http.post(
        Uri.parse(ApiConstants.locationsApi),
        headers: {
          'Authorization': 'Bearer ${await _getToken()}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location added successfully')));
        _fetchLocations();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add location')));
      }
    }
  }

  Future<void> _deleteLocation(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.locationsApi}/$id'),
      headers: {
        'Authorization': 'Bearer ${await _getToken()}',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location deleted successfully')));
      _fetchLocations();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete location')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locations Map'),
        actions: widget.isAdmin
            ? [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed:
                      _selectedLocation == null ? null : _showAddLocationDialog,
                ),
              ]
            : null,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 10.0,
        ),
        markers: _markers,
        onTap: _onTap,
      ),
    );
  }
}
