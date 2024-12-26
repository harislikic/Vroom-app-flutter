import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/automobileAd.dart';
import 'ApiConfig.dart';

class AutomobileAdService {
  Future<List<AutomobileAd>> fetchAutomobileAds({
    String searchTerm = '',
    int page = 0,
    int pageSize = 25,
    String minPrice = '',
    String maxPrice = '',
    String minMileage = '',
    String maxMileage = '',
    String yearOfManufacture = '',
    bool registered = false,
  }) async {
    final queryParams = {
      'Page': page.toString(),
      'PageSize': pageSize.toString(),
    };

    if (searchTerm.isNotEmpty) {
      queryParams['Title'] = searchTerm;
    }
    if (minPrice.isNotEmpty) {
      queryParams['MinPrice'] = minPrice;
    }
    if (maxPrice.isNotEmpty) {
      queryParams['MaxPrice'] = maxPrice;
    }
    if (minMileage.isNotEmpty) {
      queryParams['MinMileage'] = minMileage;
    }
    if (maxMileage.isNotEmpty) {
      queryParams['MaxMileage'] = maxMileage;
    }
    if (yearOfManufacture.isNotEmpty) {
      queryParams['YearOfManufacture'] = yearOfManufacture;
    }
    if (registered) {
      queryParams['Registered'] = registered.toString();
    }

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
