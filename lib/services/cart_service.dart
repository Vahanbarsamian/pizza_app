import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';

import '../models/cart_item.dart';
import '../database/app_database.dart';

class CartService extends ChangeNotifier {
  final AppDatabase _db;
  final Map<String, CartItem> _items = {};

  String? temporaryReferenceName;
  String? temporaryPickupTime;

  CartService(this._db) {
    _loadCartFromDb();
  }

  Future<void> _loadCartFromDb() async {
    final savedItems = await _db.getAllSavedCartItems();
    // ✅ CORRIGÉ: Il faut exécuter la requête avec .get()
    final allProducts = await _db.getAllProducts(); 
    final allIngredients = await _db.getAllIngredients();

    for (var savedItem in savedItems) {
      try {
        final product = allProducts.firstWhere((p) => p.id == savedItem.productId);
        final ingredientIds = savedItem.selectedIngredients.split(',').where((id) => id.isNotEmpty).map(int.parse).toList();
        final ingredients = allIngredients.where((i) => ingredientIds.contains(i.id)).toList();

        _items[savedItem.uniqueId] = CartItem(
          product: product,
          selectedIngredients: ingredients,
          quantity: savedItem.quantity,
        );
      } catch (e) {
        // Le produit/ingrédient n'existe plus, on le supprime du panier local
        _db.deleteCartItem(savedItem.uniqueId);
      }
    }
    notifyListeners();
  }

  Map<String, CartItem> get items => {..._items};
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

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
    _saveItemToDb(_items[itemId]!);
    notifyListeners();
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      _items.remove(itemId);
      _db.deleteCartItem(itemId);
    } else {
      _items.update(itemId, (existingItem) => CartItem(
        product: existingItem.product,
        selectedIngredients: existingItem.selectedIngredients,
        quantity: newQuantity,
      ));
       _saveItemToDb(_items[itemId]!);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _db.clearSavedCart();
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.remove(itemId);
    _db.deleteCartItem(itemId);
    notifyListeners();
  }

  Future<void> _saveItemToDb(CartItem item) {
    final companion = SavedCartItemsCompanion(
      uniqueId: Value(item.uniqueId),
      productId: Value(item.product.id),
      quantity: Value(item.quantity),
      selectedIngredients: Value(item.selectedIngredients.map((i) => i.id).join(',')),
    );
    return _db.saveCartItem(companion);
  }
}
