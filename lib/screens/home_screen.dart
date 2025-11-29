import 'package:flutter/material.dart';
import '../main.dart';
import '../database/product.dart';
import '../database/option.dart';

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
    productsFuture = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    return await database.productDao.getAllProducts();
  }

  Future<void> refreshProducts() async {
    setState(() {
      productsFuture = fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🍕 Notre Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshProducts,
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
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_pizza, size: 64, color: Colors.grey),
                Text('Aucun produit disponible\nAjoutez des pizzas !'),
              ],
            ),
          );
        }

        final products = snapshot.data!;

        return RefreshIndicator(
          onRefresh: refreshProducts,
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: product.image != null
                      ? Image.network(
                    product.image!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.local_pizza),
                  )
                      : const Icon(Icons.local_pizza, size: 50),
                  title: Text(product.name ?? 'Sans nom'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prix: ${product.basePrice?.toStringAsFixed(2)} €'),
                      if (product.hasGlobalDiscount == true &&
                          product.discountPercentage != null)
                        Text(
                          'Promo: ${product.discountPercentage!}%\n${product.discountedPrice?.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
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


