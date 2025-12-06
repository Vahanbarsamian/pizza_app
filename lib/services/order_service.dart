import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import 'cart_service.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AppDatabase _db;

  OrderService({required AppDatabase db}) : _db = db;

  Future<void> createOrderFromCart(CartService cart, String userId, String referenceName, String pickupTime, String paymentMethod) async {
    if (cart.items.isEmpty) {
      throw 'Le panier est vide.';
    }

    try {
      final now = DateTime.now();
      // Étape 1: Créer la commande principale (sans le statut)
      final orderResponse = await _supabase.from('orders').insert({
        'user_id': userId,
        'total': cart.totalPrice,
        'reference_name': referenceName,
        'pickup_time': pickupTime,
        'payment_method': paymentMethod,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      }).select();

      final orderId = orderResponse.first['id'] as int;

      // ✅ Étape 2: Créer l'entrée initiale dans l'historique des statuts
      await _supabase.from('order_status_histories').insert({
        'order_id': orderId,
        'status': 'À faire',
        'created_at': now.toIso8601String(),
      });

      // Étape 3: Insérer les articles de la commande
      final itemsToInsert = cart.items.values.map((cartItem) => {
        'order_id': orderId,
        'product_id': cartItem.product.id,
        'quantity': cartItem.quantity,
        'unit_price': cartItem.finalPrice,
        'product_name': cartItem.product.name,
        'options_description': cartItem.selectedIngredients.map((i) => i.name).join(', '),
      }).toList();

      await _supabase.from('order_items').insert(itemsToInsert);

    } catch (e) {
      print('Erreur lors de la création de la commande: $e');
      rethrow;
    }
  }
}
