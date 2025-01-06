import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/automobileAd.dart';
import 'ApiConfig.dart';

class AutomobileAdService {
  Future<List<AutomobileAd>> fetchAutomobileAds(
      {String searchTerm = '',
      int page = 0,
      int pageSize = 25,
      String minPrice = '',
      String maxPrice = '',
      String minMileage = '',
      String maxMileage = '',
      String yearOfManufacture = '',
      bool registered = false,
      String carBrandId = '',
      String carCategoryId = '',
      String carModelId = '',
      String cityId = ''}) async {
    final queryParams = {
      'Page': page.toString(),
      'PageSize': pageSize.toString(),
      if (searchTerm.isNotEmpty) 'Title': searchTerm,
      if (minPrice.isNotEmpty) 'MinPrice': minPrice,
      if (maxPrice.isNotEmpty) 'MaxPrice': maxPrice,
      if (minMileage.isNotEmpty) 'MinMileage': minMileage,
      if (maxMileage.isNotEmpty) 'MaxMileage': maxMileage,
      if (yearOfManufacture.isNotEmpty) 'YearOfManufacture': yearOfManufacture,
      if (registered) 'Registered': registered.toString(),
      if (carBrandId.isNotEmpty) 'CarBrandId': carBrandId,
      if (carCategoryId.isNotEmpty) 'CarCategoryId': carCategoryId,
      if (carModelId.isNotEmpty) 'CarModelId': carModelId,
      if (cityId.isNotEmpty) 'CityId': cityId,
    };

    final uri = Uri.parse('${ApiConfig.baseUrl}/AutomobileAd')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] != null && data['data'] is List) {
        final List<dynamic> items = data['data'];
        return items.map((json) => AutomobileAd.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load automobile ads');
    }
  }

  Future<AutomobileAd> getAutomobileById(int id) async {
    final response =
        await http.get(Uri.parse('${ApiConfig.baseUrl}/AutomobileAd/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AutomobileAd.fromJson(data);
    } else {
      throw Exception('Failed to load automobile details');
    }
  }

  Future<bool> createAutomobileAd(
      Map<String, dynamic> adData, authHeaders, List<XFile> imageFiles) async {
    print('data:::: ${adData}');

    try {
      // Set content type to multipart/form-data
      authHeaders['Content-Type'] = 'multipart/form-data';

      // Create MultipartRequest
      var request = http.MultipartRequest(
          'POST', Uri.parse('${ApiConfig.baseUrl}/AutomobileAd'))
        ..headers.addAll(authHeaders);

      // Adding fields to the multipart request
      adData.forEach((key, value) {
        if (value != null) {
          // Ensure values are correctly serialized to string
          request.fields[key] = value.toString();
        }
      });

      // Add image files if they exist
      if (imageFiles.isNotEmpty) {
        for (var imageFile in imageFiles) {
          print("Image path: ${imageFile.path}");
          // Add image file as 'Images' field
          request.files
              .add(await http.MultipartFile.fromPath('Images', imageFile.path));
        }
      }

      // Send the request and get the response
      var response = await request.send();

      print('response:::: ${response.statusCode}');

      // Handle the response
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
        return false;
      }
    } catch (e) {
      print('Error while creating automobile ad: $e');
      return false;
    }
  }
}
