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
                  return Stack(
                    children: [
                      ClipRRect(
                        //borderRadius: BorderRadius.circular(15), // Zaobljeni kutovi
                        child: Image.network(
                          'http://localhost:5194${image.imageUrl}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            _showFullScreenImage(index); // Prikaži sliku u punoj veličini
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.zoom_out_map,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Positioned(
                bottom: 0, // Pozicija na dnu
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.images.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _setCarouselPage(entry.key),
                      child: Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
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

  void _setCarouselPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showFullScreenImage(int initialIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(0), // Pun ekran
          child: Stack(
            children: [
              PageView.builder(
                itemCount: widget.images.length,
                controller: PageController(initialPage: initialIndex),
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index; // Ažuriraj index kada se slika promeni
                  });
                },
                itemBuilder: (context, index) {
                  final image = widget.images[index];
                  return InteractiveViewer(
                    child: Image.network(
                      'http://localhost:5194${image.imageUrl}',
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  );
                },
              ),
              Positioned(
                top: 30,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(), // Zatvori dijalog
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
