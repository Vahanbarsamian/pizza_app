import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  static Future<Map<String, dynamic>> createPaymentIntent(double amount, String orderId) async {
    // IMPORTANT: L'URL ici doit pointer vers votre propre backend qui communique avec Stripe.
    // C'est une mesure de sécurité pour ne pas exposer votre clé secrète Stripe dans l'application.
    // final response = await http.post(
    //   Uri.parse('https://votre-backend.com/create-payment-intent'), 
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({
    //     'orderId': orderId,
    //     'amount': (amount * 100).toInt(), // Stripe travaille en centimes
    //     'paymentMethod': 'stripe'
    //   }),
    // );
    // if (response.statusCode == 200) {
    //   return jsonDecode(response.body);
    // } else {
    //   throw Exception('Failed to create payment intent.');
    // }

    // Pour le test, on retourne une valeur factice. NE PAS UTILISER EN PRODUCTION.
    print('ATTENTION: Utilisation d\'une client secret Stripe factice.');
    await Future.delayed(const Duration(seconds: 1)); 
    // Remplacez par une vraie client secret de test pour tester le flux.
    return {'clientSecret': 'sk_test_..._secret_...'}; 
  }

  static Future<void> initPaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Pizza App',
        testEnv: true, // Mettre à false en production
        merchantCountryCode: 'FR',
      ),
    );
  }

  static Future<void> presentPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }
}
