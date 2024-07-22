import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryWidget extends StatefulWidget {
  final bool isAdmin;

  
  GalleryWidget({required this.isAdmin});

  @override
  _GalleryWidgetState createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  List<Map<String, dynamic>> galleryData = [];
  String? orgId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrgId();
  }

  Future<void> _loadOrgId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String? organizationJson = prefs.getString('organization');
      if (organizationJson != null) {
        Map<String, dynamic> organization = json.decode(organizationJson);
        orgId = organization['id'].toString();
      }
    });
    fetchGallery();
  }

  Future<void> fetchGallery() async {
    if (orgId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://sportappapi-production.up.railway.app/api/galleries'),
      );

      if (response.statusCode == 200) {
        List<dynamic> gallery = json.decode(response.body);
        setState(() {
          galleryData = gallery.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error: Failed to load gallery. Status code: ${response.statusCode}');
        setState(() {
          galleryData = [];
        });
      }
    } catch (e) {
      print('Error fetching gallery data: $e');
      setState(() {
        galleryData = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> deleteImage(int imageId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.delete(
        Uri.parse('https://sportappapi-production.up.railway.app/api/galleries/$imageId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        setState(() {
          galleryData.removeWhere((image) => image['id'] == imageId);
        });
      } else {
        print('Failed to delete image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> _showAddImageDialog() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Organization ID: $orgId'),
              SizedBox(height: 10),
              Image.file(imageFile, height: 150, width: 150),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _uploadImage(imageFile);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImage(File imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (orgId == null || token == null) return;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://sportappapi-production.up.railway.app/api/galleries'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['organizationId'] = orgId!;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ),
    );

    var response = await request.send();

    if (response.statusCode == 201) {
      print('Image uploaded successfully.');
      fetchGallery();
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: galleryData.length,
                itemBuilder: (context, index) {
                  final image = galleryData[index];
                  return GridTile(
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(image['imagePath']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (widget.isAdmin)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Column(
                                children: [
                                  Text(
                                    'ID: ${image['id']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      deleteImage(image['id']);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: _showAddImageDialog,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
