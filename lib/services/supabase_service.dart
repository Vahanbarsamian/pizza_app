import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/product.dart';
import '../main.dart';  // ✅ database global

class SupabaseService {
  static SupabaseClient get client => _supabase;
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Initialisation (déjà dans main.dart)
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://cwbrrsjtuaruzkedblil.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN3YnJyc2p0dWFydXprZWRibGlsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ0MTYxMTcsImV4cCI6MjA3OTk5MjExN30._McS1szep0uQElPDAZOrJLafyL5Ri_lp3RabURK3jlE',
    );
  }

  // ✅ GET PRODUCTS SUPABASE
  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await client.from('products').select();
      print('📡 Supabase products: ${response.length}');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Supabase getProducts error: $e');
      return [];  // ✅ Retourne vide en cas d'erreur
    }
  }

  // ✅ SYNC SUPABASE → FLOOR (avec OFFLINE GRÂCEUX)
  static Future<void> syncProductsToFloor() async {
    try {
      final supabaseProducts = await getProducts();
      print('📡 Sync ${supabaseProducts.length} pizzas Supabase → Floor DB');

      for (var supaProduct in supabaseProducts) {
        try {
          final product = Product(
            id: supaProduct['id'] as int,
            name: supaProduct['name']?.toString() ?? 'Pizza inconnue',
            basePrice: (supaProduct['base_price'] as num?)?.toDouble() ?? 12.99,
            image: supaProduct['image']?.toString() ?? 'https://via.placeholder.com/150?text=Pizza',
            category: supaProduct['category']?.toString() ?? 'pizza',
            discountPercentage: (supaProduct['discount_percentage'] as num?)?.toDouble() ?? 0.0,
            hasGlobalDiscount: supaProduct['has_global_discount'] == true,
          );
          await database.productDao.insertProduct(product);
          print('✅ Synced: ${product.name} (${product.basePrice}€)');
        } catch (e) {
          print('❌ Sync error ${supaProduct['id']}: $e');
        }
      }
      print('✅ Sync COMPLET ! ${supabaseProducts.length} pizzas');
    } catch (e) {
      print('⚠️  Supabase OFFLINE → Mode Floor DB local uniquement');
      print('💡 Ajoutez pizzas manuellement pour tester UI !');
      // ✅ Mode OFFLINE = Floor DB seule (PARFAIT !)
    }
  }
}