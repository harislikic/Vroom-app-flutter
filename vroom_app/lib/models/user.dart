import 'package:vroom_app/models/city.dart';

class User {
  final int id;
  final String? userName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? gender;
  final bool? isAdmin;
  final DateTime? dateOfBirth;
  final String? profilePicture;
  final int? cityId;
  final City? city;

  User({
    required this.id,
    this.userName,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.address,
    this.gender,
    required this.isAdmin,
    required this.dateOfBirth,
    this.profilePicture,
    this.cityId,
    this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      userName: json['userName'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['adress'] as String?,
      gender: json['gender'] as String?,
      isAdmin: json['isAdmin'] ?? false,
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      profilePicture: json['profilePicture'] as String?,
      cityId: json['cityId'] as int?,
      city: json['city'] == null
          ? null
          : City.fromJson(json['city']),
    );
  }
}
