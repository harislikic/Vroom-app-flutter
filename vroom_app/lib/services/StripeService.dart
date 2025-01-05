import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:vroom_app/services/ApiConfig.dart';

class StripeService {
  final String backendUrl = ApiConfig.baseUrl;

  Future<void> makePayment({
    required double amount,
    required int highlightDays,
    required int automobileAdId,
  }) async {
    try {
      final clientSecret = await _createPaymentIntent(amount, "eur");
      if (clientSecret == null) {
        print("No client secret");
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Vroom',
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      await savePaymentToDatabase(automobileAdId, amount, highlightDays);
    } catch (e) {
      print("Greška pri plaćanju: $e");
      rethrow;
    }
  }

  Future<String?> _createPaymentIntent(double amount, String currency) async {
    try {
      final dio = Dio();
      final data = {
        "amount": (amount * 100).toInt(),
        "currency": currency,
        "payment_method_types[]": "card",
      };

      const String stripeSecretKey =
          "sk_test_51Qdx6BGPnCogdWxTtz9vVVF8h1Aa0ZPvKw2RCn2GXEVCiWhFrojWlMRGqEFRa1kgzqxYSkZU6KBHIUhmENKi4ILB00Ry22lyTU";

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

      if (response.data != null && response.data["client_secret"] != null) {
        return response.data["client_secret"] as String;
      } else {
        print("Nevalidan odgovor: ${response.data}");
        return null;
      }
    } catch (e) {
      print("Greska prilikom kreiranja PaymentIntent: $e");
      return null;
    }
  }

  Future<void> savePaymentToDatabase(
      int automobileAdId, double amount, int highlightDays) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$backendUrl/AutomobileAd/api/highlight-ad?id=$automobileAdId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'highlightDays': highlightDays,
          'amount': amount,
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
