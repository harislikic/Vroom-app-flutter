import 'package:flutter/material.dart';
import 'user.dart';

class Comment {
  final int commentId;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final User user;

  Comment({
    required this.commentId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updateAt'] != null
          ? DateTime.parse(json['updateAt'])
          : null,
      user: User(
        id: json['user']['id'],
        userName: json['user']['username'],
        profilePicture: json['user']['profilePicture'],
        firstName: null,
        lastName: null,
        email: null,
        phoneNumber: null,
        address: null,
        gender: null,
        isAdmin: false,
        dateOfBirth: null,
        cityId: null,
        city: null,
      ),
    );
  }
}
