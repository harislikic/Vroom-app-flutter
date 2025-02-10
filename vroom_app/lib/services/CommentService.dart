import 'dart:convert';

import 'package:vroom_app/models/comment.dart';
import 'package:http/http.dart' as http;
import 'package:vroom_app/services/AuthService.dart';
import 'package:vroom_app/services/config.dart';

class CommentService {
  Future<List<Comment>> fetchCommentsByAutomobileId(int automobileId) async {
    final String url =
        '$baseUrl/Comment/automobile/$automobileId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is List) {
        return data.map((json) => Comment.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> editComment({
    required int commentId,
    required int userId,
    required String content,
  }) async {
    final String url =
        '$baseUrl/Comment/edit/$commentId?userId=$userId';

    final headers = await AuthService.getAuthHeaders();
    headers['Content-Type'] = 'application/json';

    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: json.encode({'content': content}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Comment updated successfully: ${responseData['message']}');
    } else {
      throw Exception(
          'Failed to edit comment. Status Code: ${response.statusCode}');
    }
  }

  Future<void> addComment({
    required String content,
    required int userId,
    required int automobileAdId,
  }) async {
    final String url = '$baseUrl/Comment';

    final headers = await AuthService.getAuthHeaders();
    headers['Content-Type'] = 'application/json';

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode({
        'content': content,
        'userId': userId,
        'automobileAdId': automobileAdId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Comment added successfully: ${responseData['message']}');
    } else {
      throw Exception(
          'Failed to add comment. Status Code: ${response.statusCode}');
    }
  }

  Future<void> deleteComment({
    required int commentId,
  }) async {
    final String url = '$baseUrl/Comment/$commentId';
    final headers = await AuthService.getAuthHeaders();

    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Comment deleted successfully.');
    } else {
      throw Exception(
          'Failed to delete comment. Status Code: ${response.statusCode}');
    }
  }
}
