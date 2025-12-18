import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';

class PaymentService {
  final AppDatabase db;
  final SupabaseClient _supabase = Supabase.instance.client;

  PaymentService({required this.db});

  // --- GESTION DU CLIENT STRIPE ---

  Future<String?> getOrCreateStripeCustomer() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      print('❌ Erreur: Aucun utilisateur Supabase connecté.');
      return null;
    }

    final localUser = await (db.select(db.users)..where((u) => u.id.equals(user.id))).getSingleOrNull();
    if (localUser?.stripeCustomerId != null) {
      return localUser!.stripeCustomerId;
    }

    try {
      final secretKey = dotenv.env['STRIPE_SECRET_KEY'];
      if (secretKey == null || secretKey.isEmpty) {
        print('❌ Erreur: STRIPE_SECRET_KEY est manquante dans le fichier .env');
        return null;
      }

      print('ℹ️ Tentative de création client Stripe pour: ${user.email}');
      
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': user.email ?? '',
          'metadata[user_id]': user.id,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final stripeId = data['id'] as String;
        await _supabase.from('users').update({'stripe_customer_id': stripeId}).eq('id', user.id);
        await (db.update(db.users)..where((u) => u.id.equals(user.id))).write(UsersCompanion(stripeCustomerId: Value(stripeId)));
        print('✅ Client Stripe créé: $stripeId');
        return stripeId;
      } else {
        print('❌ Erreur Stripe API (Code ${response.statusCode}): ${data['error']?['message'] ?? response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Erreur exceptionnelle création client Stripe: $e');
      return null;
    }
  }

  // --- RÉCUPÉRATION DÉTAILS CARTE ---

  Future<Map<String, String>?> getSavedCardDetails(String customerId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.stripe.com/v1/customers/$customerId/payment_methods?type=card'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final methods = data['data'] as List;
        if (methods.isNotEmpty) {
          final card = methods[0]['card'];
          return {
            'brand': card['brand'].toString().toUpperCase(),
            'last4': card['last4'].toString(),
          };
        }
      }
    } catch (e) {
      print('❌ Erreur récupération carte: $e');
    }
    return null;
  }

  // --- INITIALISATION PAIEMENT RÉEL ---

  Future<void> initPaymentSheet({
    required double amount,
    required bool saveCard,
  }) async {
    try {
      final customerId = await getOrCreateStripeCustomer();
      if (customerId == null) throw 'Impossible de récupérer ou créer le profil client Stripe.';
      
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (amount * 100).toInt().toString(),
          'currency': 'eur',
          'customer': customerId,
          'setup_future_usage': saveCard ? 'off_session' : '',
        },
      );

      final data = json.decode(response.body);
      if (data['client_secret'] == null) throw 'Erreur Stripe : Secret de paiement manquant. ${data['error']?['message'] ?? ''}';

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: data['client_secret'],
          merchantDisplayName: 'Pizza Mania',
          customerId: customerId,
          customerEphemeralKeySecret: await _getEphemeralKey(customerId),
          style: ThemeMode.light,
        ),
      );
    } catch (e) {
      print('❌ Erreur initialisation PaymentSheet: $e');
      rethrow;
    }
  }

  // --- INITIALISATION GARANTIE (SETUP INTENT) ---

  Future<void> initSetupIntent() async {
    try {
      final customerId = await getOrCreateStripeCustomer();
      if (customerId == null) throw 'Impossible de créer le profil client Stripe.';

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/setup_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'customer': customerId,
          'usage': 'off_session',
        },
      );

      final data = json.decode(response.body);
      if (data['client_secret'] == null) throw 'Erreur Stripe : Secret de garantie manquant. ${data['error']?['message'] ?? ''}';

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: data['client_secret'],
          merchantDisplayName: 'Pizza Mania (Garantie)',
          customerId: customerId,
          customerEphemeralKeySecret: await _getEphemeralKey(customerId),
        ),
      );
    } catch (e) {
      print('❌ Erreur initialisation Garantie: $e');
      rethrow;
    }
  }

  Future<bool> presentAndConfirm() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (e) {
      if (e is StripeException) {
        print('❌ Erreur Stripe: ${e.error.localizedMessage}');
      }
      return false;
    }
  }

  Future<String> _getEphemeralKey(String customerId) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/ephemeral_keys'),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Stripe-Version': '2023-10-16',
      },
      body: {
        'customer': customerId,
      },
    );
    final data = json.decode(response.body);
    if (data['secret'] == null) throw 'Erreur Stripe : Clé éphémère manquante. ${data['error']?['message'] ?? ''}';
    return data['secret'];
  }
}
