import 'dart:convert';
import 'package:http/http.dart' as http;
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
      String carModelId = ''}) async {
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
      if (carModelId.isNotEmpty) 'CarModelId': carModelId
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
}
