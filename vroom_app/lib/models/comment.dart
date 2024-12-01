import 'package:flutter/material.dart';
import 'user.dart'; // Ovo pretpostavlja da imate `User` model u vašem projektu.
import 'automobileAd.dart'; // Ovo pretpostavlja da imate `AutomobileAd` model u vašem projektu.

class Comment {
  final int id;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int userId;
  final User user;
  final int? automobileAdId;
  final AutomobileAd? automobileAd;

  Comment({
    required this.id,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.userId,
    required this.user,
    this.automobileAdId,
    this.automobileAd,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      userId: json['userId'],
      user: User.fromJson(
          json['user']),
      automobileAdId: json['automobileAdId'],
      automobileAd: json['automobileAd'] != null
          ? AutomobileAd.fromJson(json['automobileAd'])
          : null,
    );
  }
}
