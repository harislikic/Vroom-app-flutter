import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vroom_app/models/favoritesAutomobiles.dart';
import 'package:vroom_app/services/AuthService.dart';

import 'ApiConfig.dart';

class FavoritesService {
  Future<List<FavoritesAutomobiles>> fetchFavorites(
      {int page = 1, int pageSize = 25}) async {
    final userId = await AuthService.getUserId();

    final response = await http.get(
      Uri.parse(
          '${ApiConfig.baseUrl}/Favorite/$userId?page=$page&pageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] != null && data['data'] is List) {
        final List<dynamic> items = data['data'];
        return items
            .map((json) => FavoritesAutomobiles.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  // Remove a favorite
  Future<void> removeFavorite(int userId, int automobileId) async {
    final response = await http.delete(
      Uri.parse(
          '${ApiConfig.baseUrl}/Favorite?userId=$userId&automobilId=$automobileId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove favorite');
    }
  }
}
