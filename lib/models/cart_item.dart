import '../database/app_database.dart';

class CartItem {
  final Product product;
  final List<Ingredient> selectedIngredients;
  final List<Ingredient> removedIngredients; // ✅ AJOUTÉ
  int quantity;

  CartItem({
    required this.product,
    this.selectedIngredients = const [],
    this.removedIngredients = const [], // ✅ AJOUTÉ
    this.quantity = 1,
  });

  double get finalPrice {
    double baseProductPrice = product.basePrice;
    if (product.discountPercentage > 0) {
      baseProductPrice = product.basePrice * (1 - product.discountPercentage);
    }

    final ingredientsPrice = selectedIngredients.fold<double>(0, (sum, ingredient) => sum + ingredient.price);

    return baseProductPrice + ingredientsPrice;
  }

  String get uniqueId {
    final supplements = selectedIngredients.map((i) => i.id).join('-');
    final removals = removedIngredients.map((i) => i.id).join('-');
    return '${product.id}-s$supplements-r$removals'; // ✅ MODIFIÉ
  }
}
