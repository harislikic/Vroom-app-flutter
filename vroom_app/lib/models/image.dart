class Image {
  final int id;
  final String imageUrl;

  Image({required this.id, required this.imageUrl});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      imageUrl: json['imageUrl'],
    );
  }
}
