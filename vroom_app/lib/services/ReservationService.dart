import 'dart:convert';

import 'package:vroom_app/models/reservation.dart';
import 'package:vroom_app/services/ApiConfig.dart';
import 'package:http/http.dart' as http;
import 'package:vroom_app/services/AuthService.dart';

class ReservationService {
  Future<List<Reservation>> getReservationsByAutomobileId({
    required int automobileAdId,
    int page = 1,
    int pageSize = 25,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };

    final uri =
        Uri.parse('${ApiConfig.baseUrl}/Reservation/automobile/$automobileAdId')
            .replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] is List) {
        return (data['data'] as List)
            .map((json) => Reservation.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  Future<Reservation> createReservation({
    required DateTime reservationDate,
    required int userId,
    required int automobileAdId,
  }) async {
    const String url = '${ApiConfig.baseUrl}/Reservation';
    final headers = await AuthService.getAuthHeaders();
    headers['Content-Type'] = 'application/json';

    final body = json.encode({
      'reservationDate': reservationDate.toIso8601String(),
      'userId': userId,
      'automobileAdId': automobileAdId,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Reservation.fromJson(data);
    } else {
      throw Exception(
          'Failed to create Reservation. Status Code: ${response.statusCode}');
    }
  }

  Future<void> deleteReservation({
    required int reservationId,
  }) async {
    final String url = '${ApiConfig.baseUrl}/Reservation/$reservationId';
    final headers = await AuthService.getAuthHeaders();

    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Reservation deleted successfully.');
    } else {
      throw Exception(
          'Failed to delete Reservation. Status Code: ${response.statusCode}');
    }
  }
}
