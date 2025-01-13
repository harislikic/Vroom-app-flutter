import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastUtils {
  static void showToast({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.green,
    Color textColor = Colors.white,
    Toast toastLength = Toast.LENGTH_LONG,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  static void showErrorToast({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    double fontSize = 16.0,
  }) {
    showToast(
      message: message,
      gravity: gravity,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      fontSize: fontSize,
    );
  }

  static void showInfoToast({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    double fontSize = 16.0,
  }) {
    showToast(
      message: message,
      gravity: gravity,
      backgroundColor: Colors.amberAccent,
      textColor: Colors.black,
      toastLength: Toast.LENGTH_LONG,
      fontSize: fontSize,
    );
  }
}
