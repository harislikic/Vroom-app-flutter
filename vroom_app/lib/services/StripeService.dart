import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:vroom_app/services/ApiConfig.dart';

class StripeService {
  final String backendUrl = ApiConfig.baseUrl;
  //final String stripeSecretKey = ApiConfig.stripeSecretKey;
  String stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';

  Future<void> makePayment({
    required double amount,
    required int highlightDays,
    required int automobileAdId,
  }) async {
    try {
      final result = await _createPaymentIntent(amount, "eur");
      if (result == null) {
        return;
      }

      final clientSecret = result["clientSecret"];
      final paymentIntentId = result["paymentIntentId"];

      if (clientSecret == null || paymentIntentId == null) {
        print("clientSecret ili paymentIntentId are null");
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Vroom',
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      await savePaymentToDatabase(
        automobileAdId: automobileAdId,
        amount: amount,
        highlightDays: highlightDays,
        paymentId: paymentIntentId,
      );
    } catch (e) {
      print("Greška pri plaćanju: $e");
      rethrow;
    }
  }

  Future<Map<String, String>?> _createPaymentIntent(
      double amount, String currency) async {
    try {
      final dio = Dio();
      final data = {
        "amount": (amount * 100).toInt(),
        "currency": currency,
        "payment_method_types[]": "card",
      };

      final response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );

      if (response.data == null) {
        print("Empty response data");
        return null;
      }

      final clientSecret = response.data["client_secret"];
      final paymentIntentId = response.data["id"];

      if (clientSecret == null || paymentIntentId == null) {
        return null;
      }

      return {
        "clientSecret": clientSecret,
        "paymentIntentId": paymentIntentId,
      };
    } catch (e) {
      print("Greska prilikom kreiranja PaymentIntent: $e");
      return null;
    }
  }

  Future<void> savePaymentToDatabase({
    required int automobileAdId,
    required double amount,
    required int highlightDays,
    required String paymentId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiConfig.baseUrl}/AutomobileAd/api/highlight-ad?id=$automobileAdId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'highlightDays': highlightDays,
          'amount': amount,
          'paymentId': paymentId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save payment to database: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saving payment to database: $e');
    }
  }
}
