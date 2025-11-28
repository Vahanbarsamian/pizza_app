import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../database/app_database.dart';
import '../product.dart';
import '../option.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic> stats = {};
  late Future<List<Product>> productsFuture;
  late Future<List<Product>> promoProductsFuture;
  late Future<double> avgPriceFuture;
  TextEditingController discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadStats();
    productsFuture = database.productDao.getAllProducts();
    promoProductsFuture = database.productDao.getProductsWithDiscount();
    avgPriceFuture = database.productDao.getAveragePrice() ?? Future.value(0.0);
  }

  Future<void> loadStats() async {
    // Stats calculées depuis DB Floor
    final allProducts = await database.productDao.getAllProducts();
    final promoProducts = await database.productDao.getProductsWithDiscount();

    setState(() {
      stats = {
        'totalProducts': allProducts.length,
        'promoProducts': promoProducts.length,
        'totalRevenue': allProducts.fold(0.0, (sum, p) => sum + (p.discountedPrice)),
        'avgPrice': avgPriceFuture,
      };
    });
  }

  // ✅ REMISE GLOBALE 20% sur TOUS les produits
  Future<void> applyGlobalDiscount() async {
    final percentage = double.tryParse(discountController.text) ?? 0.0;
    if (percentage > 0) {
      await database.productDao.applyGlobalDiscount(percentage, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Remise globale $percentage% appliquée !')),
      );
      loadStats(); // Refresh stats
      discountController.clear();
    }
  }

  // ✅ Créer OPTION pour produit
  Future<void> createOptionForProduct(int productId) async {
    final name = 'Extra fromage'; // Exemple
    await database.optionDao.insertOption(Option(
      productId: productId,
      name: name,
      price: 2.5,
      type: 'add', // ou 'replace'
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
            // ✅ Cards stats avec Floor DB
            Row(
              children: [
                Expanded(child: StatCard(title: "Produits", value: stats['totalProducts']?.toString() ?? '0')),
                Expanded(child: StatCard(title: "En Promo", value: stats['promoProducts']?.toString() ?? '0')),
              ],
            ),
            Row(
              children: [
                Expanded(child: StatCard(title: "CA Total", value: '${stats['totalRevenue']?.toStringAsFixed(0) ?? 0}€')),
                Expanded(child: StatCard(title: "Prix Moyen", value: '${stats['avgPrice']?.toStringAsFixed(1) ?? 0}€')),
              ],
            ),

            // ✅ SECTION REMISES GLOBALES
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Remise Globale', style: Theme.of(context).textTheme.headlineSmall),
                    TextField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Pourcentage % (ex: 20)',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.apply_discount),
                          onPressed: applyGlobalDiscount,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Graphique ventes (inchangé)
            Container(
              height: 200,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(16),
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

            // ✅ Boutons navigation admin + NOUVEAUX
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/admin/products'), child: Text("Produits")),
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/admin/pages'), child: Text("Pages")),
                ElevatedButton(
                  onPressed: () async {
                    await loadStats();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Stats rechargées')));
                  },
                  child: Text("🔄 Refresh"),
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

// Widget StatCard (inchangé)
class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 12)),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}