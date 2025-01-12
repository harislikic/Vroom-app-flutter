import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:vroom_app/services/AuthService.dart';
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
          request.fields[key] = value.toString();
        }
      });

      if (imageFiles.isNotEmpty) {
        for (var imageFile in imageFiles) {
          request.files
              .add(await http.MultipartFile.fromPath('Images', imageFile.path));
        }
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error while creating automobile ad: $e');
      return false;
    }
  }

  Future<List<AutomobileAd>> fetchUserAutomobiles(
      {required String userId,
      int page = 0,
      int pageSize = 25,
      String? status,
      bool? IsHighlighted}) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };

    // Add `status` to query parameters if it's not null or empty
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    if (IsHighlighted == true) {
      queryParams['IsHighlighted'] = IsHighlighted.toString();
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/AutomobileAd/user-ads/$userId')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['data'] != null && data['data'] is List) {
          final List<dynamic> items = data['data'];
          return items.map((json) => AutomobileAd.fromJson(json)).toList();
        } else {
          return [];
        }
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load automobile ads');
      }
    } catch (e) {
      throw Exception('Error fetching user automobile ads: $e');
    }
  }

  Future<void> removeAutomobile(
      int automobileId, Map<String, String> authHeaders) async {
    authHeaders['accept'] = 'text/plain';

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/AutomobileAd/$automobileId'),
      headers: authHeaders,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove automobile');
    }
  }

  Future<List<AutomobileAd>> fetchRecommendAutomobiles() async {
    final userId = await AuthService.getUserId();
    if (userId == null) {
      throw Exception('User ID is not available');
    }

    final uri =
        Uri.parse('${ApiConfig.baseUrl}/AutomobileAd/$userId/recommend');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> items = json.decode(response.body);
        return items.map((json) => AutomobileAd.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recommended automobile ads');
      }
    } catch (e) {
      throw Exception('Error fetching recommended automobile ads: $e');
    }
  }
}
