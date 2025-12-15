import 'package:collection/collection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import 'cart_service.dart';
import 'loyalty_service.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AppDatabase _db;
  final LoyaltyService _loyaltyService;

  OrderService({required AppDatabase db, required LoyaltyService loyaltyService})
      : _db = db,
        _loyaltyService = loyaltyService;

  Future<void> createOrderFromCart(CartService cart, String userId, String referenceName, String pickupTime, String paymentMethod) async {
    if (cart.items.isEmpty) {
      throw 'Le panier est vide.';
    }

    try {
      final now = DateTime.now();
      double finalTotal = cart.totalPrice;
      var itemsToInsert = cart.items.values.map((cartItem) {
        final options = <String>[];
        if (cartItem.selectedIngredients.isNotEmpty) {
          options.add(cartItem.selectedIngredients.map((i) => '+ ${i.name}').join(', '));
        }
        if (cartItem.removedIngredients.isNotEmpty) {
          options.add(cartItem.removedIngredients.map((i) => '(sans ${i.name})').join(', '));
        }

        return {
          'product_id': cartItem.product.id,
          'quantity': cartItem.quantity,
          'unit_price': cartItem.finalPrice,
          'product_name': cartItem.product.name,
          'options_description': options.join(', '),
        };
      }).toList();

      // --- ✅ LOGIQUE DE FIDÉLITÉ ENTIÈREMENT CORRIGÉE ---
      final settings = await _loyaltyService.watchLoyaltySettings().first;
      bool rewardApplied = false;
      int pointsChange = 0;

      final pizzaCountInCart = cart.items.values
          .where((item) => item.product.category == 'pizza')
          .fold<int>(0, (sum, item) => sum + item.quantity);

      if (settings != null && settings.isEnabled && settings.mode == 'free_pizza') {
        final userLoyalty = await _loyaltyService.watchUserLoyalty(userId).first;
        final currentPoints = userLoyalty?.points ?? 0;
        
        // Le client a-t-il assez de points AVANT cette commande ?
        if (currentPoints >= settings.threshold) {
          final pizzasInCart = cart.items.values.where((item) => item.product.category == 'pizza').toList();
          
          if (pizzasInCart.isNotEmpty) {
            rewardApplied = true;

            pizzasInCart.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
            final cheapestPizzaItem = pizzasInCart.first;

            final itemToDiscount = itemsToInsert.firstWhere((item) => item['product_id'] == cheapestPizzaItem.product.id);
            final originalPrice = itemToDiscount['unit_price'] as double;
            itemToDiscount['unit_price'] = 0.0; 
            finalTotal -= originalPrice; 

            // Calcule le changement de points : on retire le seuil, on ajoute les nouvelles pizzas
            pointsChange = pizzaCountInCart - settings.threshold;
            print('🎉 [OrderService] Récompense appliquée. Changement de points: $pointsChange');
          }
        }
      }
      
      // Si aucune récompense n'a été appliquée, on ajoute simplement les points
      if (!rewardApplied) {
        pointsChange = pizzaCountInCart;
        print('ℹ️ [OrderService] Pas de récompense. Changement de points: $pointsChange');
      }

      final orderResponse = await _supabase.from('orders').insert({
        'user_id': userId,
        'total': finalTotal, 
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

      for (var item in itemsToInsert) {
        item['order_id'] = orderId;
      }

      await _supabase.from('order_items').insert(itemsToInsert);
      
      // Applique la mise à jour des points à la toute fin
      if (pointsChange != 0) {
        await _loyaltyService.addPoints(userId, pointsChange);
      }
      // --- Fin de la correction ---

    } catch (e) {
      print('Erreur lors de la création de la commande: $e');
      rethrow;
    }
  }
}
