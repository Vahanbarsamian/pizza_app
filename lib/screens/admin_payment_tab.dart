import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';

class AdminPaymentTab extends StatefulWidget {
  const AdminPaymentTab({super.key});

  @override
  State<AdminPaymentTab> createState() => _AdminPaymentTabState();
}

class _AdminPaymentTabState extends State<AdminPaymentTab> {
  bool _isSaving = false;

  Future<void> _togglePayment(bool newValue, CompanyInfoData info) async {
    setState(() => _isSaving = true);
    final adminService = context.read<AdminService>();
    final syncService = context.read<SyncService>();

    final updatedInfo = CompanyInfoCompanion(
      id: Value(info.id),
      isPaymentEnabled: Value(newValue),
    );

    try {
      await adminService.saveCompanyInfo(updatedInfo);
      await syncService.syncAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newValue ? '✅ Paiement Stripe activé' : 'ℹ️ Paiement Stripe désactivé (Mode test)'),
            backgroundColor: newValue ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    return StreamBuilder<CompanyInfoData?>(
      stream: db.watchCompanyInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final info = snapshot.data!;
        final isEnabled = info.isPaymentEnabled;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.payment, size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      'Réglages du Paiement',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Activez le paiement réel pour que les clients puissent payer par carte bancaire. Si désactivé, seul le paiement sur place sera disponible.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Divider(height: 40),
                    SwitchListTile(
                      title: const Text('Paiement en ligne (Stripe)', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(isEnabled ? 'ACTIF (Mode Réel)' : 'INACTIF (Mode Test / Sur place)'),
                      value: isEnabled,
                      activeColor: Colors.green,
                      onChanged: _isSaving ? null : (val) => _togglePayment(val, info),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              color: Colors.blueGrey,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'En mode test, vous pouvez simuler des paiements sans utiliser de l\'argent réel.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
