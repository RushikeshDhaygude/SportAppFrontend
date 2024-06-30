import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class ImageFetcherScreen extends StatefulWidget {
  @override
  _ImageFetcherScreenState createState() => _ImageFetcherScreenState();
}

class _ImageFetcherScreenState extends State<ImageFetcherScreen> {
  List<String> imagePaths = [];
  final String serverBaseUrl =
      'http://192.168.43.56:8000'; // Replace with your local server's base URL and port

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    final response = await http.get(Uri.parse(
        '$serverBaseUrl/api/galleries')); // Replace with your actual API endpoint

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        imagePaths = data.map((item) => item['imagePath'] as String).toList();
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  String getFullImagePath(String relativePath) {
    return '$serverBaseUrl/$relativePath'.replaceAll('\\', '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Fetcher'),
      ),
      body: imagePaths.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    imageUrl: getFullImagePath(imagePaths[index]),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                );
              },
            ),
    );
  }
}
