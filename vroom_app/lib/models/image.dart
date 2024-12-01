class ImageModel {
  final int id;
  final String imageUrl;

  ImageModel({required this.id, required this.imageUrl});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      imageUrl: json['imageUrl'],
    );
  }
}
