import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vroom_app/models/carModel.dart';
import 'ApiConfig.dart';

class CarModelService {
  Future<List<CarModel>> fetchCarModels(
      {int page = 0, int pageSize = 50}) async {

    const String baseUrl = '${ApiConfig.baseUrl}/CarModel';

    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'Page': page.toString(),
      'PageSize': pageSize.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] != null && data['data'] is List) {
        final List<dynamic> items = data['data'];
        return items.map((json) => CarModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load car models');
    }
  }
}
