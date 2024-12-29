import 'package:vroom_app/models/image.dart'; // Assuming Image is in the 'image.dart' file

class FavoritesAutomobiles {
  final int id;
  final String title;
  final double price;
  final int yearOfManufacture;
  final int mileage;
  final int horsePower;
  final List<ImageModel> images;

  FavoritesAutomobiles({
    required this.id,
    required this.title,
    required this.price,
    required this.yearOfManufacture,
    required this.mileage,
    required this.horsePower,
    required this.images,
  });

  // From JSON
  factory FavoritesAutomobiles.fromJson(Map<String, dynamic> json) {
    return FavoritesAutomobiles(
      id: json['id'],
      title: json['title'] ?? 'Unknown',
      price: json['price']?.toDouble() ?? 0.0, // Default to 0 if null
      yearOfManufacture: json['yearOfManufacture'] ?? 0, // Default to 0 if null
      mileage: json['milage'] ?? 0, // Default to 0 if null
      horsePower: json['horsePower'] ?? 0, // Default to 0 if null
      images: (json['images'] as List)
          .map((image) => ImageModel.fromJson(image))
          .toList(),
    );
  }
}
