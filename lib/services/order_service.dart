import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'cart_service.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AppDatabase _db;

  OrderService({required AppDatabase db}) : _db = db;

  // ✅ LOGIQUE DE CRÉATION
  Future<int> createOrderFromCart(
    CartService cart,
    String userId,
    String referenceName,
    String pickupTime,
    String paymentMethod,
  ) async {
    if (cart.items.isEmpty) {
      throw 'Le panier est vide.';
    }

    try {
      final orderItemsForRpc = cart.items.values.map((cartItem) {
        return {
          'product_id': cartItem.product.id,
          'quantity': cartItem.quantity,
          'unit_price': cartItem.finalPrice,
          'is_drink': cartItem.product.isDrink,
        };
      }).toList();

      // On appelle la fonction RPC qui crée la commande et nous renvoie son ID
      final response = await _supabase.rpc(
        'create_order_with_loyalty',
        params: {
          'p_user_id': userId,
          'p_reference_name': referenceName,
          'p_pickup_time': pickupTime,
          'p_payment_method': paymentMethod,
          'p_order_items': orderItemsForRpc,
        },
      );

      // On suppose que la fonction RPC renvoie l'ID de la commande créée
      final orderId = response as int;
      print('✅ [OrderService] Commande #$orderId créée.');
      return orderId;

    } on PostgrestException catch (e) {
      print('❌ [OrderService] Erreur Postgrest: ${e.message}');
      rethrow;
    } catch (e) {
      print('❌ [OrderService] Erreur: $e');
      rethrow;
    }
  }

  // ✅ NOUVEAU: Mettre à jour le statut du paiement (paid, guaranteed, pending)
  Future<void> updatePaymentStatus(int orderId, String status) async {
    try {
      await _supabase
          .from('orders')
          .update({'payment_status': status})
          .eq('id', orderId);
      
      // Mise à jour locale
      await (_db.update(_db.orders)..where((o) => o.id.equals(orderId)))
          .write(OrdersCompanion(paymentStatus: Value(status)));
          
      print('✅ [OrderService] Statut paiement mis à jour : $status');
    } catch (e) {
      print('❌ [OrderService] Erreur mise à jour statut paiement: $e');
      rethrow;
    }
  }
}
