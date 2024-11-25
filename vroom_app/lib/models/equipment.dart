class Equipment {
  final int id;
  final String name;

  Equipment({required this.id, required this.name});

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
    );
  }
}
