import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseNotificationService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Appelle une Edge Function Supabase pour envoyer la notification (SMS ou Email)
  static Future<void> notifyOrderReady(int orderId) async {
    try {
      // On invoque la fonction 'notify-order-ready' sur votre serveur Supabase
      await _supabase.functions.invoke(
        'notify-order-ready',
        body: {'orderId': orderId},
      );
      print('🔔 Notification demandée pour la commande #$orderId');
    } catch (e) {
      // On ne bloque pas l'utilisateur si la notification échoue
      print('⚠️ Erreur lors du déclenchement de la notification: $e');
    }
  }
}
