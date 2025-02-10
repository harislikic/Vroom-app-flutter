import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vroom_app/models/carModel.dart';
import 'package:vroom_app/services/config.dart';

class CarModelService {
  Future<List<CarModel>> fetchCarModels(
      {int page = 0, int pageSize = 50}) async {
    final String url = '$baseUrl/CarModel';

    final Uri uri = Uri.parse(url).replace(queryParameters: {
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
