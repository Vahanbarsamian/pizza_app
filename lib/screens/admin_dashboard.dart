import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../product.dart';
import '../option.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic> stats = {};
  //late Future<List<Product>> productsFuture;
  //late Future<List<Product>> promoProductsFuture;
  //late Future<double?> avgPriceFuture;
  TextEditingController discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Defer database access until context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadStats();
    });
  }

  Future<void> loadStats() async {
    if (!mounted) return;
    final database = Provider.of<AppDatabase>(context, listen: false);
    final allProducts = await database.productDao.getAllProducts();
    final promoProducts = await database.productDao.getProductsWithDiscount();
    final avgPrice = await database.productDao.getAveragePrice();

    setState(() {
      stats = {
        'totalProducts': allProducts.length,
        'promoProducts': promoProducts.length,
        'totalRevenue': allProducts.fold(0.0, (sum, p) => sum + (p.price * (p.hasGlobalDiscount ? (1 - (p.discountPercentage ?? 0) / 100) : 1))),
        'avgPrice': avgPrice ?? 0.0,
      };
    });
  }

  Future<void> applyGlobalDiscount() async {
    if (!mounted) return;
    final database = Provider.of<AppDatabase>(context, listen: false);
    final percentage = double.tryParse(discountController.text) ?? 0.0;
    if (percentage > 0) {
      await database.productDao.applyGlobalDiscount(percentage, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Remise globale $percentage% appliquée !')),
      );
      await loadStats();
      discountController.clear();
    }
  }

  Future<void> createOptionForProduct(int productId) async {
    if (!mounted) return;
    final database = Provider.of<AppDatabase>(context, listen: false);
    final name = 'Extra fromage';
    await database.optionDao.insertOption(OptionsCompanion.insert(
      productId: productId,
      name: name,
      price: 2.5,
      type: 'add',
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Option "$name" créée !')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: StatCard(title: "Produits", value: stats['totalProducts']?.toString() ?? '0')),
                Expanded(child: StatCard(title: "En Promo", value: stats['promoProducts']?.toString() ?? '0')),
              ],
            ),
            Row(
              children: [
                Expanded(child: StatCard(title: "CA Total", value: stats['totalRevenue']?.toStringAsFixed(2) ?? '0.00', isPrice: true)),
                Expanded(child: StatCard(title: "Prix Moyen", value: stats['avgPrice']?.toStringAsFixed(2) ?? '0.00', isPrice: true)),
              ],
            ),

            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Remise Globale', style: Theme.of(context).textTheme.headlineSmall),
                    TextField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Pourcentage % (ex: 20)',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.percent),
                          onPressed: applyGlobalDiscount,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              height: 200,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(16),
              child: BarChart(
                BarChartData(
                  barGroups: [
                    makeGroupData(0, 12),
                    makeGroupData(1, 19),
                    makeGroupData(2, 30),
                    makeGroupData(3, 50),
                    makeGroupData(4, 20),
                  ],
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/admin/products'), child: const Text("Produits")),
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/admin/pages'), child: const Text("Pages")),
                ElevatedButton(
                  onPressed: () async {
                    await loadStats();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Stats rechargées')));
                  },
                  child: const Text("🔄 Refresh"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [BarChartRodData(toY: y)],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isPrice;

  const StatCard({Key? key, required this.title, required this.value, this.isPrice = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 12)),
            isPrice
                ? Text.rich(
                    TextSpan(
                      style: Theme.of(context).textTheme.headlineMedium,
                      children: [
                        TextSpan(text: value),
                        const TextSpan(text: ' € TTC', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                      ],
                    ),
                  )
                : Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
