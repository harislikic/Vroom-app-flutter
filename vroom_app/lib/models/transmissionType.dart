class TransmissionType {
  final int id;
  final String name;

  TransmissionType({required this.id, required this.name});

  factory TransmissionType.fromJson(Map<String, dynamic> json) {
    return TransmissionType(
      id: json['id'],
      name: json['name'],
    );
  }
}
