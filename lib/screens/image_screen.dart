import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageScreen extends StatelessWidget {
  final String base64Image;

  const ImageScreen({
    required this.base64Image,
    super.key,
  });

  Uint8List get _bytes => base64Decode(base64Image);

  Future<void> _saveImage(BuildContext context) async {
    final PermissionState status =
    await PhotoManager.requestPermissionExtend();

    if (!status.isAuth) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You should have permission')),
      );
      return;
    }

    final AssetEntity? entity =
    await PhotoManager.editor.saveImage(
      _bytes,
      title: 'image_${DateTime.now().millisecondsSinceEpoch}', filename: '',
    );

    if (entity != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved in gallery'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          children: [
            Icon(Icons.photo_album, color: Colors.white),
            Text(
              "Photo",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _saveImage(context),
            icon: const Icon(Icons.download, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          maxScale: 4,
          child: Image.memory(
            _bytes,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveImage(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.download),
      ),
    );
  }
}
