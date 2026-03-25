import 'package:flutter/material.dart';
import 'dart:io';

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;

  const ImagePreviewScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview")),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}