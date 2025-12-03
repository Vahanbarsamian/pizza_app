import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import 'order_history_screen.dart';

class ClientAreaScreen extends StatelessWidget {
  const ClientAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Espace Client'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildMenuOption(
            context,
            icon: Icons.history,
            title: 'Mes Commandes',
            subtitle: 'Voir l\'historique de vos commandes',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
            },
          ),
          _buildMenuOption(
            context,
            icon: Icons.credit_card,
            title: 'Mon Moyen de Paiement',
            subtitle: 'Gérer vos cartes de crédit (bientôt disponible)',
            onTap: null, // Désactivé pour le moment
          ),
          _buildMenuOption(
            context,
            icon: Icons.reviews_outlined,
            title: 'Mes Avis',
            subtitle: 'Voir et gérer vos avis (bientôt disponible)',
            onTap: null, // Désactivé pour le moment
          ),
          // La carte de fidélité sera ajoutée ici conditionnellement plus tard
        ],
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, {required IconData icon, required String title, required String subtitle, VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
        onTap: onTap,
        enabled: onTap != null,
      ),
    );
  }
}
