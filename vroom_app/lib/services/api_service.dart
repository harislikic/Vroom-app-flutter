import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/automobile_ad.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5194/AutomobileAd';

  Future<List<AutomobileAd>> fetchAutomobileAds(
      {int page = 0, int pageSize = 25}) async {
    final response =
        await http.get(Uri.parse('$baseUrl?Page=$page&PageSize=$pageSize'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Proveravamo da li "items" postoji i nije null
      if (data['data'] != null && data['data'] is List) {
        final List<dynamic> items = data['data'];
        return items.map((json) => AutomobileAd.fromJson(json)).toList();
      } else {
        // Ako nema rezultata, vraćamo praznu listu
        return [];
      }
    } else {
      throw Exception('Failed to load automobile ads');
    }
  }
}
