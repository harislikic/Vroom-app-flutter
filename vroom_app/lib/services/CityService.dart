import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:vroom_app/models/city.dart';

class CityService {
  Future<List<City>> fetchCities({int page = 0, int pageSize = 90}) async {
    final String baseUrl = '${dotenv.env['BASE_URL']}/City';

    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'Page': page.toString(),
      'PageSize': pageSize.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] != null && data['data'] is List) {
        final List<dynamic> items = data['data'];
        return items.map((json) => City.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load car models');
    }
  }
}
