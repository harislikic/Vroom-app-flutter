import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vroom_app/models/transmissionType.dart';
import 'ApiConfig.dart';

class TransmissionTypeService {
  Future<List<TransmissionType>> fetchTransmissionTypes({int page = 0, int pageSize = 25}) async {
    const String baseUrl = '${ApiConfig.baseUrl}/TransmissionType';

    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'Page': page.toString(),
      'PageSize': pageSize.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] != null && data['data'] is List) {
        final List<dynamic> items = data['data'];
        return items.map((json) => TransmissionType.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load Transmission Type');
    }
  }
}
