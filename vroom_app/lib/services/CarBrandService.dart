import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:vroom_app/models/carBrand.dart';

class CarBrandService {
  Future<List<CarBrand>> fetchCarBrands({int page = 0, int pageSize = 50}) async {
    //const String baseUrl = '${ApiConfig.baseUrl}/CarBrand';
    final String baseUrl = '${dotenv.env['BASE_URL']}/CarBrand';

    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'Page': page.toString(),
      'PageSize': pageSize.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] != null && data['data'] is List) {
        final List<dynamic> items = data['data'];
        return items.map((json) => CarBrand.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load car brands');
    }
  }
}
