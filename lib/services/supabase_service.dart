import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/product.dart';
import '../main.dart';  // ✅ database global

class SupabaseService {
  static SupabaseClient get client => _supabase;
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://cwbrrsjtuaruzkedblil.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN3YnJyc2p0dWFydXprZWRibGlsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ0MTYxMTcsImV4cCI6MjA3OTk5MjExN30._McS1szep0uQElPDAZOrJLafyL5Ri_lp3RabURK3jlE',
    );
  }

  // ✅ MÉTHODE MANQUANTE #1
  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await client.from('products').select();
      print('📡 Supabase products: ${response.length}');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Supabase getProducts error: $e');
      return [];
    }
  }

  // ✅ MÉTHODE MANQUANTE #2
  static Future<void> syncProductsToFloor() async {
    final supabaseProducts = await getProducts();
    print('📡 Sync ${supabaseProducts.length} pizzas Supabase → Floor DB');

    for (var supaProduct in supabaseProducts) {
      try {
        final product = Product(
          id: supaProduct['id'] as int,
          name: supaProduct['name']?.toString() ?? 'Pizza inconnue',
          basePrice: (supaProduct['base_price'] as num?)?.toDouble() ?? 0.0,
          image: supaProduct['image']?.toString(),
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
    print('✅ Sync COMPLET ! ${supabaseProducts.length} pizzas locales');
  }
}