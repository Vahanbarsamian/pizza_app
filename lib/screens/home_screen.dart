import 'package:flutter/material.dart';
import '../database/app_database.dart';  // ✅ REMPLACE ApiService
import '../product.dart';
import '../option.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = fetchProducts();  // ✅ REMPLACE fetchProducts()
  }

  // ✅ NOUVEAU : Charge produits depuis Floor DB
  Future<List<Product>> fetchProducts() async {
    return await database.productDao.getAllProducts();
  }

  // ✅ NOUVEAU : Refresh manuel
  Future<void> refreshProducts() async {
    setState(() {
      productsFuture = fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notre Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshProducts,  // ✅ Bouton refresh
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun produit disponible'));
          }

          final products = snapshot.data!;

          return RefreshIndicator(
            onRefresh: fetchProducts,  // ✅ Pull to refresh
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: product.image != null
                        ? Image.network(product.image!,
                        width: 50, height: 50, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.pizza))
                        : const Icon(Icons.pizza, size: 50),
                    title: Text(product.name ?? 'Sans nom'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prix base: ${product.basePrice?.toStringAsFixed(2)} €'),
                        if (product.hasGlobalDiscount == true && product.discountPercentage != null)
                          Text(
                            'Promo: ${(product.discountPercentage!)}% - ${product.discountedPrice.toStringAsFixed(2)} €',
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

