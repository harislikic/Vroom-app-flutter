import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/image.dart';

class CarImageCarousel extends StatefulWidget {
  final List<ImageModel> images;

  const CarImageCarousel({Key? key, required this.images}) : super(key: key);

  @override
  _CarImageCarouselState createState() => _CarImageCarouselState();
}

class _CarImageCarouselState extends State<CarImageCarousel> {
  int _currentIndex = 0; // Trenutni index slike u carouselu

  @override
  Widget build(BuildContext context) {
    return widget.images.isNotEmpty
        ? Stack(
            children: [
              CarouselSlider.builder(
                itemCount: widget.images.length,
                options: CarouselOptions(
                  height: 300,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index; // Ažuriraj trenutni index kada se slika promeni
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final image = widget.images[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15), // Zaobljeni kutovi
                    child: Image.network(
                      'http://localhost:5194${image.imageUrl}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 10, // Pozicija na dnu
                right: 10, // Pozicija na desnoj strani
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentIndex + 1}/${widget.images.length}', // Indikator broja slika
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
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
