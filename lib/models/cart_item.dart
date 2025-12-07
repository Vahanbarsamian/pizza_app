import '../database/app_database.dart';

class CartItem {
  final Product product;
  final List<Ingredient> selectedIngredients;
  int quantity;

  CartItem({
    required this.product,
    this.selectedIngredients = const [],
    this.quantity = 1,
  });

  double get finalPrice {
    // ✅ CORRIGÉ: La formule de calcul de la remise est maintenant correcte.
    double baseProductPrice = product.basePrice;
    if (product.discountPercentage > 0) {
      baseProductPrice = product.basePrice * (1 - product.discountPercentage);
    }

    final ingredientsPrice = selectedIngredients.fold<double>(0, (sum, ingredient) => sum + ingredient.price);

    return baseProductPrice + ingredientsPrice;
  }

  String get uniqueId => '${product.id}-${selectedIngredients.map((i) => i.id).join('-')}';
}
