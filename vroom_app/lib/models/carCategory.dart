class CarCategory {
  final int id;
  final String name;

  CarCategory({required this.id, required this.name});

  factory CarCategory.fromJson(Map<String, dynamic> json) {
    return CarCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}
