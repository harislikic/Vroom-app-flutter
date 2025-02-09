import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class ImageGalleryEditAutomobile extends StatelessWidget {
  final List<dynamic> existingImages;
  final List<XFile> newImages;
  final void Function(int imageId) onRemoveExistingImage;
  final void Function(XFile newImage) onRemoveNewImage;

  const ImageGalleryEditAutomobile({
    Key? key,
    required this.existingImages,
    required this.newImages,
    required this.onRemoveExistingImage,
    required this.onRemoveNewImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        for (var image in existingImages)
          Container(
            margin: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${dotenv.env['BASE_URL']}${image.imageUrl}',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => onRemoveExistingImage(image.id),
                  ),
                ),
              ],
            ),
          ),
        // Prikaz novih slika
        for (var newImage in newImages)
          Container(
            margin: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(newImage.path),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => onRemoveNewImage(newImage),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
