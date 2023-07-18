import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PictureZoom extends StatefulWidget {
  final url;

  PictureZoom(this.url);

  @override
  State<PictureZoom> createState() => _PictureZoomState();
}

class _PictureZoomState extends State<PictureZoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PhotoView(
          backgroundDecoration: BoxDecoration(color: Colors.transparent),
          imageProvider: Image.network(widget.url).image,
        ),
      ),
    );
  }
}
