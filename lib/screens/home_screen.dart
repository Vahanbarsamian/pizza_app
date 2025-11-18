import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    final data = await ApiService().getProducts();
    setState(() {
      products = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notre Menu")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, index) {
          final p = products[index];
          return ListTile(
            leading: Image.network(p['image']),
            title: Text(p['name']),
            subtitle: Text('${p['price']} €'),
          );
        },
      ),
    );
  }
}

