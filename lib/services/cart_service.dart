import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../database/app_database.dart';

class CartService extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  // ✅ NOUVEAU: Pour mémoriser les informations de commande
  String? temporaryReferenceName;
  String? temporaryPickupTime;

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.finalPrice * cartItem.quantity;
    });
    return total;
  }

  void addToCart(Product product, {List<Ingredient> ingredients = const []}) {
    final cartItem = CartItem(product: product, selectedIngredients: ingredients);
    final itemId = cartItem.uniqueId;

    if (_items.containsKey(itemId)) {
      _items.update(itemId, (existingItem) => CartItem(
        product: existingItem.product,
        selectedIngredients: existingItem.selectedIngredients,
        quantity: existingItem.quantity + 1,
      ));
    } else {
      _items.putIfAbsent(itemId, () => cartItem);
    }
    notifyListeners();
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      _items.remove(itemId);
    } else {
      _items.update(itemId, (existingItem) => CartItem(
        product: existingItem.product,
        selectedIngredients: existingItem.selectedIngredients,
        quantity: newQuantity,
      ));
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    // On ne vide pas les infos temporaires, au cas où l'utilisateur fait une autre commande dans la foulée
    notifyListeners();
  }

  // ✅ NOUVEAU: Pour supprimer complètement un article
  void removeItem(String itemId) {
    _items.remove(itemId);
    notifyListeners();
  }
}
