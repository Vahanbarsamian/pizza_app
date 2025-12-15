import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import 'cart_service.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AppDatabase _db;

  OrderService({required AppDatabase db}) : _db = db;

  // ✅ LOGIQUE ENTIÈREMENT DÉPLACÉE CÔTÉ SERVEUR VIA UNE FONCTION RPC
  Future<void> createOrderFromCart(
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
      // 1. Prépare la liste des articles pour la fonction RPC
      final orderItemsForRpc = cart.items.values.map((cartItem) {
        return {
          'product_id': cartItem.product.id,
          'quantity': cartItem.quantity,
          'unit_price': cartItem.finalPrice,
          'is_drink': cartItem.product.isDrink,
        };
      }).toList();

      // 2. Appelle la fonction Supabase qui s'occupe de tout
      await _supabase.rpc(
        'create_order_with_loyalty',
        params: {
          'p_user_id': userId,
          'p_reference_name': referenceName,
          'p_pickup_time': pickupTime,
          'p_payment_method': paymentMethod,
          'p_order_items': orderItemsForRpc,
        },
      );

      print('✅ [OrderService] Appel RPC à create_order_with_loyalty réussi.');

    } on PostgrestException catch (e) {
      print('❌ [OrderService] Erreur Postgrest lors de la création de la commande: ${e.message}');
      print('Détails: ${e.details}');
      rethrow;
    } catch (e) {
      print('❌ [OrderService] Erreur inattendue: $e');
      rethrow;
    }
  }
}
