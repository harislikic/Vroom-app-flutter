import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vroom_app/models/reservation.dart';
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
        Uri.parse('${dotenv.env['BASE_URL']}/Reservation/automobile/$automobileAdId')
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
    final String url = '${dotenv.env['BASE_URL']}/Reservation';
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
    final String url = '${dotenv.env['BASE_URL']}/Reservation/$reservationId';
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

  Future<List<Reservation>> getUserReservations({
    required int userId,
    int page = 1,
    int pageSize = 25,
    String? status,
  }) async {
    final queryParams = {
      if (status != null) 'status': status,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };

    final uri =
        Uri.parse('${dotenv.env['BASE_URL']}/Reservation/user/$userId/reservations')
            .replace(
      queryParameters: queryParams,
    );

    final headers = await AuthService.getAuthHeaders();

    final response = await http.get(uri, headers: headers);

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
      throw Exception(
          'Failed to load user reservations. Status Code: ${response.statusCode}');
    }
  }

  Future<void> approveReservation({
    required int reservationId,
  }) async {
    final String url =
        '${dotenv.env['BASE_URL']}/Reservation/approve/$reservationId';
    final headers = await AuthService.getAuthHeaders();

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Reservation approved successfully.');
    } else {
      throw Exception(
          'Failed to approve reservation. Status Code: ${response.statusCode}');
    }
  }

  Future<void> rejectReservation({
    required int reservationId,
  }) async {
    final String url = '${dotenv.env['BASE_URL']}/Reservation/reject/$reservationId';
    final headers = await AuthService.getAuthHeaders();

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    print('rul ${url}');

    print('reservationId ${reservationId}');

    if (response.statusCode == 200) {
      print('Reservation rejected successfully.');
    } else {
      throw Exception(
          'Failed to reject reservation. Status Code: ${response.statusCode}');
    }
  }

}
