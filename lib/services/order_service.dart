import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import 'cart_service.dart';
import 'loyalty_service.dart'; // ✅ AJOUTÉ

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AppDatabase _db;
  final LoyaltyService _loyaltyService; // ✅ AJOUTÉ

  // ✅ MODIFIÉ: Le constructeur accepte maintenant LoyaltyService
  OrderService({required AppDatabase db, required LoyaltyService loyaltyService})
      : _db = db,
        _loyaltyService = loyaltyService;

  Future<void> createOrderFromCart(CartService cart, String userId, String referenceName, String pickupTime, String paymentMethod) async {
    if (cart.items.isEmpty) {
      throw 'Le panier est vide.';
    }

    try {
      final now = DateTime.now();
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

      await _supabase.from('order_status_histories').insert({
        'order_id': orderId,
        'status': 'À faire',
        'created_at': now.toIso8601String(),
      });

      final itemsToInsert = cart.items.values.map((cartItem) {
        final options = <String>[];
        if (cartItem.selectedIngredients.isNotEmpty) {
          options.add(cartItem.selectedIngredients.map((i) => '+ ${i.name}').join(', '));
        }
        if (cartItem.removedIngredients.isNotEmpty) {
          options.add(cartItem.removedIngredients.map((i) => '(sans ${i.name})').join(', '));
        }

        return {
          'order_id': orderId,
          'product_id': cartItem.product.id,
          'quantity': cartItem.quantity,
          'unit_price': cartItem.finalPrice,
          'product_name': cartItem.product.name,
          'options_description': options.join(', '),
        };
      }).toList();

      await _supabase.from('order_items').insert(itemsToInsert);

      // --- ✅ AJOUTÉ: Mise à jour des points de fidélité ---
      final settings = await _loyaltyService.watchLoyaltySettings().first;
      if (settings != null && settings.isEnabled) {
        // On ne compte que les produits de la catégorie 'pizza'
        final pizzaCount = cart.items.values
            .where((item) => item.product.category == 'pizza')
            .fold<int>(0, (sum, item) => sum + item.quantity);

        await _loyaltyService.addPizzasToCount(userId, pizzaCount);
      }
      // --- Fin de l'ajout ---

    } catch (e) {
      print('Erreur lors de la création de la commande: $e');
      rethrow;
    }
  }
}
