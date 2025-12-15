import 'package:drift/drift.dart';
import './app_database.dart';

// Données initiales pour les produits (pizzas et boissons)

final initialProducts = [
  // PIZZAS (Exemples basés sur un projet de pizzeria typique)
  ProductsCompanion.insert(
    id: const Value(1),
    name: 'Margherita',
    description: const Value('Sauce tomate, mozzarella, basilic frais'),
    basePrice: 8.50,
    category: const Value('Classiques'),
    image: const Value('assets/images/margherita.png'),
    createdAt: DateTime.now(),
  ),
  ProductsCompanion.insert(
    id: const Value(2),
    name: 'Reine',
    description: const Value('Sauce tomate, mozzarella, jambon, champignons'),
    basePrice: 10.00,
    category: const Value('Classiques'),
    image: const Value('assets/images/reine.png'),
    createdAt: DateTime.now(),
  ),
  ProductsCompanion.insert(
    id: const Value(3),
    name: '4 Saisons',
    description: const Value('Sauce tomate, mozzarella, jambon, champignons, artichauts, poivrons'),
    basePrice: 11.50,
    category: const Value('Spécialités'),
    image: const Value('assets/images/4saisons.png'),
    createdAt: DateTime.now(),
  ),

  // BOISSONS
  ProductsCompanion.insert(
    id: const Value(101),
    name: 'Canette (Coca-Cola)',
    basePrice: 2.50,
    category: const Value('Boissons'),
    isDrink: const Value(true),
    image: const Value('assets/images/coca.png'), // Supposition
    createdAt: DateTime.now(),
  ),
  ProductsCompanion.insert(
    id: const Value(102),
    name: 'Bière (bouteille)',
    basePrice: 4.00,
    category: const Value('Boissons'),
    isDrink: const Value(true),
    image: const Value('assets/images/biere.png'), // Supposition
    createdAt: DateTime.now(),
  ),
  ProductsCompanion.insert(
    id: const Value(103),
    name: 'Jus de fruits',
    basePrice: 3.00,
    category: const Value('Boissons'),
    isDrink: const Value(true),
    image: const Value('assets/images/jus.png'), // Supposition
    createdAt: DateTime.now(),
  ),
    ProductsCompanion.insert(
    id: const Value(104),
    name: 'Eau (50cl)',
    basePrice: 1.50,
    category: const Value('Boissons'),
    isDrink: const Value(true),
    image: const Value('assets/images/eau.png'), // Supposition
    createdAt: DateTime.now(),
  ),
  ProductsCompanion.insert(
    id: const Value(105),
    name: 'Eau gazeuse (50cl)',
    basePrice: 1.80,
    category: const Value('Boissons'),
    isDrink: const Value(true),
    image: const Value('assets/images/eau_gazeuse.png'), // Supposition
    createdAt: DateTime.now(),
  ),
  ProductsCompanion.insert(
    id: const Value(106),
    name: 'Vin (verre)',
    basePrice: 4.50,
    category: const Value('Boissons'),
    isDrink: const Value(true),
    image: const Value('assets/images/vin.png'), // Supposition
    createdAt: DateTime.now(),
  ),
];
