import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/automobileAd.dart';
import '../../models/image.dart';

class CarImageCarousel extends StatelessWidget {
  final List<ImageModel> images;

  const CarImageCarousel({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return images.isNotEmpty
        ? CarouselSlider.builder(
            itemCount: images.length,
            options: CarouselOptions(
              height: 300,
              enlargeCenterPage: true,
              viewportFraction: 1,
            ),
            itemBuilder: (context, index, realIndex) {
              final image = images[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(15), // Rounded Corners
                child: Image.network(
                  'http://localhost:5194${image.imageUrl}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          )
        : Container(
            height: 200,
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.directions_car, size: 40, color: Colors.grey),
            ),
          );
  }
}
