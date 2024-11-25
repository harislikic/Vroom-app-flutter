class CarModel {
  final int id;
  final String name;

  CarModel({required this.id, required this.name});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
