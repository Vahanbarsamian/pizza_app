import 'package:drift/drift.dart' hide Column;
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
  bool _isSaving = false; // ✅ État pour l'animation du bouton
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
    setState(() => _isSaving = true); // ✅ Début animation
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
      await syncService.syncAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Réglages sauvegardés avec succès.'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de sauvegarde: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false); // ✅ Fin animation
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
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin / Fidélité'), 
          centerTitle: true, 
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin / Fidélité'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
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
          // ✅ MODIFIÉ: Bouton stylisé avec fond vert, texte blanc et animation
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            onPressed: _isSaving ? null : _saveSettings,
            child: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 8),
                      Text(
                        'Sauvegarder les réglages',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

extension on LoyaltySetting {
    LoyaltySetting copyWith({bool? isEnabled, String? mode}) {
        return LoyaltySetting(
            id: id,
            isEnabled: isEnabled ?? this.isEnabled,
            mode: mode ?? this.mode,
            threshold: threshold,
            discountPercentage: discountPercentage,
        );
    }
}
