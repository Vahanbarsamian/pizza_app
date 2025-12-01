import 'package:flutter/material.dart';
import '../database/app_database.dart';

/// Représente un article dans le panier
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.basePrice * quantity;
}

/// Gère l'état du panier d'achat
class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  // Permet de lire la liste des articles sans pouvoir la modifier de l'extérieur
  List<CartItem> get items => _items;

  // Calcule le prix total du panier
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  // Ajoute un produit au panier ou incrémente sa quantité
  void addToCart(Product product) {
    // Vérifie si le produit est déjà dans le panier
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      // Si oui, on incrémente juste la quantité
      _items[existingIndex].quantity++;
    } else {
      // Sinon, on ajoute un nouvel article
      _items.add(CartItem(product: product));
    }

    // Notifie les widgets qui écoutent que l'état a changé
    notifyListeners();
  }

  // Retire un article du panier ou décrémente sa quantité
  void removeFromCart(CartItem cartItem) {
    final existingIndex = _items.indexWhere((item) => item.product.id == cartItem.product.id);

    if (existingIndex != -1) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex].quantity--;
      } else {
        _items.removeAt(existingIndex);
      }
      notifyListeners();
    }
  }

  // Vide complètement le panier
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
