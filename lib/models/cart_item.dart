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
    double baseProductPrice = product.basePrice;
    if (product.discountPercentage != null && product.discountPercentage! > 0) {
      baseProductPrice = product.basePrice * (1 - product.discountPercentage! / 100);
    }

    final ingredientsPrice = selectedIngredients.fold<double>(0, (sum, ingredient) => sum + ingredient.price);

    return baseProductPrice + ingredientsPrice;
  }

  String get uniqueId => '${product.id}-${selectedIngredients.map((i) => i.id).join('-')}';
}
