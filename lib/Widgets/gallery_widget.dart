import 'package:flutter/material.dart';

class GalleryWidgetStatic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildImageWidget('assets/images/Sports1.jpg'),
          buildImageWidget('assets/images/Sports2.jpg'),
          buildImageWidget('assets/images/Sports3.jpg'),
        ],
      ),
    );
  }

  Widget buildImageWidget(String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.asset(
          imagePath,
          width: 200,
          height: 175,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
