import 'package:vroom_app/models/city.dart';

class User {
  final int id;
  final String userName;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address;
  final String gender;
  final bool isAdmin;
  final DateTime dateOfBirth;
  final String? profilePicture;
  final int cityId;
  final City city;

  User({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    required this.isAdmin,
    required this.dateOfBirth,
    this.profilePicture,
    required this.cityId,
    required this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['adress'], // Note: "adress" in JSON
      gender: json['gender'],
      isAdmin: json['isAdmin'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      profilePicture: json['profilePicture'],
      cityId: json['cityId'],
      city: City.fromJson(json['city']),
    );
  }
}
