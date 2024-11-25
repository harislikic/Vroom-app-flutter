class VehicleCondition {
  final int id;
  final String name;

  VehicleCondition({required this.id, required this.name});

  factory VehicleCondition.fromJson(Map<String, dynamic> json) {
    return VehicleCondition(
      id: json['id'],
      name: json['name'],
    );
  }
}
