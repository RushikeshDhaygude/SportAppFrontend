import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class ImageGalleryScreen extends StatefulWidget {
  @override
  _ImageGalleryScreenState createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    final response = await http.get(Uri.parse('http://192.168.106.73:8080/api/galleries'));

    if (response.statusCode == 200) {
      setState(() {
        images = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: images.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final image = images[index];
                  final imageUrl = 'http://192.168.106.73:8080/' + image['imagePath'].replaceAll('\\', '/');
                  return Card(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
    );
  }
}

