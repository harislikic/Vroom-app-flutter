import 'package:vroom_app/models/comment.dart';

import 'automobileAdEquipment.dart';
import 'carBrand.dart';
import 'carCategory.dart';
import 'carModel.dart';
import 'equipment.dart';
import 'fuelType.dart';
import 'image.dart';
import 'transmissionType.dart';
import 'user.dart';
import 'vehicleCondition.dart';

class AutomobileAd {
  final int id;
  final String title;
  final String description;
  final double price;
  final DateTime dateOfAdd;
  final int viewsCount;
  final int yearOfManufacture;
  final bool registered;
  final DateTime? registrationExpirationDate;
  final String status;
  final DateTime? featuredExpiryDate;
  final DateTime? lastSmallService;
  final DateTime? lastBigService;
  final double mileage;
  final User? user;
  final CarBrand? carBrand;
  final CarCategory? carCategory;
  final CarModel? carModel;
  final Comment? comment;
  final FuelType? fuelType;
  final TransmissionType? transmissionType;
  final List<ImageModel> images;
  final List<AutomobileAdEquipment> automobileAdEquipments;
  final int enginePower;
  final int numberOfDoors;
  final int cubicCapacity;
  final int horsePower;
  final String color;
  final VehicleCondition? vehicleCondition;
  final bool isHighlighted;
  final DateTime? highlightExpiryDate;

  AutomobileAd({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.dateOfAdd,
    required this.viewsCount,
    required this.yearOfManufacture,
    required this.registered,
    this.registrationExpirationDate,
    required this.status,
    this.featuredExpiryDate,
    this.lastSmallService,
    this.lastBigService,
    required this.mileage,
    required this.user,
    this.carBrand,
    this.comment,
    this.carCategory,
    this.carModel,
    this.fuelType,
    this.transmissionType,
    required this.images,
    required this.automobileAdEquipments,
    required this.enginePower,
    required this.numberOfDoors,
    required this.cubicCapacity,
    required this.horsePower,
    required this.color,
    this.vehicleCondition,
    required this.isHighlighted,
    this.highlightExpiryDate,
  });

  factory AutomobileAd.fromJson(Map<String, dynamic> json) {
    return AutomobileAd(
      id: json['id'] ?? 0, // Default to 0 if id is missing
      title: json['title'] ?? 'N/A', // Default to 'N/A' if title is null
      description: json['description'] ?? 'N/A',
      price:
          (json['price'] ?? 0).toDouble(), // Handle null and convert to double
      dateOfAdd: json['dateOFadd'] != null
          ? DateTime.parse(json['dateOFadd'])
          : DateTime.now(), // Default to current date if missing
      viewsCount: json['viewsCount'] ?? 0,
      yearOfManufacture: json['yearOfManufacture'] ?? 0,
      registered: json['registered'] ?? false,
      registrationExpirationDate: json['registrationExpirationDate'] != null
          ? DateTime.parse(json['registrationExpirationDate'])
          : null,
      status: json['status'] ?? 'Unknown',
      featuredExpiryDate: json['featuredExpiryDate'] != null
          ? DateTime.parse(json['featuredExpiryDate'])
          : null,
      lastSmallService: json['last_Small_Service'] != null
          ? DateTime.parse(json['last_Small_Service'])
          : null,
      lastBigService: json['last_Big_Service'] != null
          ? DateTime.parse(json['last_Big_Service'])
          : null,
      mileage: json['milage'] != null ? json['milage'].toDouble() : 0,
      user: json['user'] != null
          ? User.fromJson(json['user'])
          : null, // Handle null user
      carBrand:
          json['carBrand'] != null ? CarBrand.fromJson(json['carBrand']) : null,
      carCategory: json['carCategory'] != null
          ? CarCategory.fromJson(json['carCategory'])
          : null,
      carModel:
          json['carModel'] != null ? CarModel.fromJson(json['carModel']) : null,
      comment:
          json['comment'] != null ? Comment.fromJson(json['comment']) : null,
      fuelType:
          json['fuelType'] != null ? FuelType.fromJson(json['fuelType']) : null,
      transmissionType: json['transmissionType'] != null
          ? TransmissionType.fromJson(json['transmissionType'])
          : null,
      images: (json['images'] as List? ?? [])
          .map((image) => ImageModel.fromJson(image))
          .toList(), // Default to empty list if null
      automobileAdEquipments: (json['automobileAdEquipments'] as List? ?? [])
          .map((equipment) => AutomobileAdEquipment.fromJson(equipment))
          .toList(),
      enginePower: json['enginePower'] ?? 0,
      numberOfDoors: json['numberOfDoors'] ?? 0,
      cubicCapacity: json['cubicCapacity'] ?? 0,
      horsePower: json['horsePower'] ?? 0,
      color: json['color'] ?? 'Unknown',
      vehicleCondition: json['vehicleCondition'] != null
          ? VehicleCondition.fromJson(json['vehicleCondition'])
          : null,
      isHighlighted: json['isHighlighted'] ?? false,
      highlightExpiryDate: json['highlightExpiryDate'] != null
          ? DateTime.parse(json['highlightExpiryDate'])
          : null,
    );
  }
}
