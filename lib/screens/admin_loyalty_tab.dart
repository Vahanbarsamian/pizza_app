import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';

enum LoyaltyMode { freePizza, discount }

class AdminLoyaltyTab extends StatefulWidget {
  const AdminLoyaltyTab({super.key});

  @override
  State<AdminLoyaltyTab> createState() => _AdminLoyaltyTabState();
}

class _AdminLoyaltyTabState extends State<AdminLoyaltyTab> {
  bool _isLoading = true;
  late LoyaltySetting _settings;

  final _thresholdController = TextEditingController();
  final _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final adminService = context.read<AdminService>();
    try {
      final settings = await adminService.getLoyaltySettings();
      if (settings != null) {
        setState(() {
          _settings = settings;
          _thresholdController.text = settings.threshold.toString();
          _discountController.text = (settings.discountPercentage * 100).round().toString();
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de chargement: $e')));
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveSettings() async {
    final adminService = context.read<AdminService>();
    final syncService = context.read<SyncService>();

    final newSettings = LoyaltySettingsCompanion(
      id: const Value(1),
      isEnabled: Value(_settings.isEnabled),
      mode: Value(_settings.mode),
      threshold: Value(int.tryParse(_thresholdController.text) ?? 10),
      discountPercentage: Value((double.tryParse(_discountController.text) ?? 10) / 100),
    );

    try {
      await adminService.saveLoyaltySettings(newSettings);
      await syncService.syncAll(); // Pour que les autres parties de l'app soient à jour
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Réglages sauvegardés avec succès.'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de sauvegarde: $e')));
    }
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              elevation: 2,
              child: SwitchListTile(
                title: const Text('Activer le système de fidélité', style: TextStyle(fontWeight: FontWeight.bold)),
                value: _settings.isEnabled,
                onChanged: (value) => setState(() => _settings = _settings.copyWith(isEnabled: value)),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _settings.isEnabled ? 1.0 : 0.4,
              child: AbsorbPointer(
                absorbing: !_settings.isEnabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Configuration de la récompense', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Pizza Gratuite'),
                            subtitle: const Text('La N-ième pizza est gratuite'),
                            value: 'free_pizza',
                            groupValue: _settings.mode,
                            onChanged: (value) => setState(() => _settings = _settings.copyWith(mode: value!)),
                          ),
                          RadioListTile<String>(
                            title: const Text('Réduction en pourcentage'),
                            subtitle: const Text('Après N pizzas, une réduction s\'applique'),
                            value: 'discount',
                            groupValue: _settings.mode,
                            onChanged: (value) => setState(() => _settings = _settings.copyWith(mode: value!)),
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text('Seuil de déclenchement (nombre de pizzas)'),
                                TextField(
                                  controller: _thresholdController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(suffixText: 'pizzas'),
                                ),
                                if (_settings.mode == 'discount') ...[
                                  const SizedBox(height: 16),
                                  const Text('Pourcentage de réduction'),
                                  TextField(
                                    controller: _discountController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(suffixText: '%'),
                                  ),
                                ],
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save_alt),
            label: const Text('Sauvegarder les réglages'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            onPressed: _saveSettings,
          ),
        ),
      ),
    );
  }
}
