import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../screens/image_screen.dart';

class ImageItem extends StatelessWidget {
  final String base64Image;

  const ImageItem({
    required this.base64Image,
    super.key,
  });

  Uint8List _decodeBase64(String value) {
    return base64Decode(value);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.amber,
        hoverColor: const Color.fromARGB(255, 181, 220, 238),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ImageScreen(base64Image: base64Image),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: GridTile(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  _decodeBase64(base64Image),
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
