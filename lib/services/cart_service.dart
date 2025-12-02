import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/cart_item.dart';

class CartService extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  void addToCart(Product product, {List<Ingredient> ingredients = const []}) {
    final newItem = CartItem(product: product, selectedIngredients: ingredients);
    final itemId = newItem.uniqueId;

    if (_items.containsKey(itemId)) {
      _items.update(itemId, (existingItem) {
        existingItem.quantity++;
        return existingItem;
      });
    } else {
      _items[itemId] = newItem;
    }
    notifyListeners();
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (_items.containsKey(itemId)) {
      if (newQuantity > 0) {
        _items.update(itemId, (item) {
          item.quantity = newQuantity;
          return item;
        });
      } else {
        _items.remove(itemId);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String itemId) {
    _items.remove(itemId);
    notifyListeners();
  }

  double get totalPrice {
    return _items.values.fold(0, (total, item) => total + (item.finalPrice * item.quantity));
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
