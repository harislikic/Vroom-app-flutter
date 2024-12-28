import 'package:vroom_app/models/canton.dart';

class City {
  final int id;
  final String title;
  final Canton canton;

  City({required this.id, required this.title, required this.canton});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      title: json['title'],
      canton: Canton.fromJson(json['canton']),
    );
  }
}
