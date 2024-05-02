import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VisibleImage extends StatelessWidget {
  final String imageUrl;
  const VisibleImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ));
  }
}
