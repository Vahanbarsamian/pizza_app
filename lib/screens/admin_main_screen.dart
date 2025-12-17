import 'package:flutter/material.dart';

import 'admin_menu_tab.dart';
import 'admin_announcements_tab.dart';
import 'admin_info_tab.dart';
import 'admin_statistics_tab.dart';
import 'admin_payment_tab.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de la Pizzeria'),
        automaticallyImplyLeading: false,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildMenuCard(
            context,
            title: 'Menu & Produits',
            icon: Icons.restaurant_menu,
            color: Colors.orange,
            onTap: () => _navigateTo(context, const AdminMenuTab(), 'Admin / Menu'),
          ),
          _buildMenuCard(
            context,
            title: 'Annonces',
            icon: Icons.campaign,
            color: Colors.blue,
            onTap: () => _navigateTo(context, const AdminAnnouncementsTab(), 'Admin / Annonces'),
          ),
          _buildMenuCard(
            context,
            title: 'Statistiques',
            icon: Icons.bar_chart,
            color: Colors.purple,
            onTap: () => _navigateTo(context, const AdminStatisticsTab(), 'Admin / Statistiques'),
          ),
          _buildMenuCard(
            context,
            title: 'Infos Boutique',
            icon: Icons.business,
            color: Colors.teal,
            onTap: () => _navigateTo(context, const AdminInfoTab(), 'Admin / Infos'),
          ),
          _buildMenuCard(
            context,
            title: 'Paiement',
            icon: Icons.payment,
            color: Colors.green,
            onTap: () => _navigateTo(context, const AdminPaymentTab(), 'Admin / Paiement'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: screen,
        ),
      ),
    );
  }
}
