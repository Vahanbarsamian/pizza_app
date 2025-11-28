import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  static Future<Map<String, dynamic>> createPaymentIntent(double amount, String orderId) async {
    final response = await http.post(
      Uri.parse('http://your-api.com/api/orders/payment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'orderId': orderId,
        'amount': amount,
        'paymentMethod': 'stripe'
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<void> initPaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'PizzaApp',
      ),
    );
  }

  static Future<void> presentPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }
}