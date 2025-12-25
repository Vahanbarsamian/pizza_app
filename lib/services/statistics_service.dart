import 'package:supabase_flutter/supabase_flutter.dart';

// Modèle pour l'aperçu des ventes
class SalesOverview {
  final double totalRevenue;
  final int totalOrdersCount;
  final int totalProductsSold;
  final int totalPizzasSold;
  final int totalDrinksSold;
  final double averageCartValue;
  final double revenueFromPizzas;
  final double revenueFromDrinks;
  final double averagePizzaPrice;

  SalesOverview.fromJson(Map<String, dynamic> json)
      : totalRevenue = (json['total_revenue'] as num? ?? 0).toDouble(),
        totalOrdersCount = json['total_orders_count'] as int? ?? 0,
        totalProductsSold = json['total_products_sold'] as int? ?? 0,
        totalPizzasSold = json['total_pizzas_sold'] as int? ?? 0,
        totalDrinksSold = json['total_drinks_sold'] as int? ?? 0,
        averageCartValue = (json['average_cart_value'] as num? ?? 0).toDouble(),
        revenueFromPizzas = (json['revenue_from_pizzas'] as num? ?? 0).toDouble(),
        revenueFromDrinks = (json['revenue_from_drinks'] as num? ?? 0).toDouble(),
        averagePizzaPrice = (json['average_pizza_price'] as num? ?? 0).toDouble();
}

// Modèle pour un produit best-seller
class BestSellerProduct {
  final int id;
  final String name;
  final String? image;
  final int totalSold;
  final bool isDrink; // ✅ AJOUTÉ

  BestSellerProduct.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String? ?? 'Produit inconnu',
        image = json['image'] as String?,
        totalSold = json['total_sold'] as int? ?? 0,
        isDrink = json['is_drink'] as bool? ?? false; // ✅ AJOUTÉ
}

class TimeSeriesSales {
  final int timeUnit;
  final double totalRevenue;

  TimeSeriesSales.fromJson(Map<String, dynamic> json)
      : timeUnit = (json['time_unit'] as num).toInt(),
        totalRevenue = (json['total_revenue'] as num? ?? 0).toDouble();
}

class StatisticsService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<SalesOverview> getSalesOverview({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _supabase.rpc(
        'get_sales_overview',
        params: {
          'start_date': startDate.toIso8601String(),
          'end_date': DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59).toIso8601String(),
        },
      );
      return SalesOverview.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Erreur (getSalesOverview): $e');
      rethrow;
    }
  }

  Future<List<BestSellerProduct>> getBestSellers({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 5,
  }) async {
    try {
      final response = await _supabase.rpc(
        'get_best_sellers',
        params: {
          'start_date': startDate.toIso8601String(),
          'end_date': DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59).toIso8601String(),
          'p_limit': limit,
        },
      );
      
      if (response == null) return [];

      return (response as List).map((item) => BestSellerProduct.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Erreur (getBestSellers): $e');
      rethrow;
    }
  }

  Future<List<TimeSeriesSales>> getSalesByTime({
    required DateTime startDate,
    required DateTime endDate,
    required String groupByUnit,
  }) async {
    try {
      final response = await _supabase.rpc(
        'get_sales_by_time',
        params: {
          'start_date': startDate.toIso8601String(),
          'end_date': DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59).toIso8601String(),
          'group_by_unit': groupByUnit,
        },
      );

      if (response == null) return [];

      return (response as List).map((item) => TimeSeriesSales.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Erreur (getSalesByTime): $e');
      rethrow;
    }
  }
}
