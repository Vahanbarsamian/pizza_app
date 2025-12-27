import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'cart_service.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AppDatabase _db;

  OrderService({required AppDatabase db}) : _db = db;

  Future<int> createOrderFromCart(
    CartService cart,
    String userId,
    String referenceName,
    String pickupTime,
    String paymentMethod, {
    String notificationPreference = 'none', // ✅ AJOUT
    String? notificationPhone, // ✅ AJOUT
  }) async {
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

      final response = await _supabase.rpc(
        'create_order_with_loyalty',
        params: {
          'p_user_id': userId,
          'p_reference_name': referenceName,
          'p_pickup_time': pickupTime,
          'p_payment_method': paymentMethod,
          'p_order_items': orderItemsForRpc,
          'p_notification_preference': notificationPreference, // ✅ AJOUT RPC
          'p_notification_phone': notificationPhone, // ✅ AJOUT RPC
        },
      );

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

  Future<void> updatePaymentStatus(int orderId, String status) async {
    try {
      await _supabase
          .from('orders')
          .update({'payment_status': status})
          .eq('id', orderId);
      
      await (_db.update(_db.orders)..where((o) => o.id.equals(orderId)))
          .write(OrdersCompanion(paymentStatus: Value(status)));
          
      print('✅ [OrderService] Statut paiement mis à jour : $status');
    } catch (e) {
      print('❌ [OrderService] Erreur mise à jour statut paiement: $e');
      rethrow;
    }
  }
}
