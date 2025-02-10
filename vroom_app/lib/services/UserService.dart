import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:vroom_app/services/AuthService.dart';
import 'package:vroom_app/services/config.dart';

class UserService {
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = await AuthService.getUserId();
      if (userId == null) return null;

      final headers = await AuthService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/User/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch user profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error while fetching user profile: $e');
    }
  }

  static Future<Map<String, dynamic>?> updateUserProfile({
    required int userId,
    required Map<String, dynamic> userData,
    File? profilePicture,
    bool isImageUpdated = false,
  }) async {
    try {
      final headers = await AuthService.getAuthHeaders();
      headers['Content-Type'] = 'multipart/form-data';

      print('profilePicture::: ${profilePicture}');

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$baseUrl/User/$userId'),
      )..headers.addAll(headers);
      userData.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          request.fields[key] = value.toString();
        }
      });

      if (isImageUpdated && profilePicture != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'ProfilePicture',
          profilePicture.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        throw Exception(
            'Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error while updating user profile: $e');
    }
  }
}
