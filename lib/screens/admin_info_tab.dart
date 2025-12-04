import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';
import '../services/preferences_service.dart';

class AdminInfoTab extends StatefulWidget {
  const AdminInfoTab({super.key});

  @override
  State<AdminInfoTab> createState() => _AdminInfoTabState();
}

class _AdminInfoTabState extends State<AdminInfoTab> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _presentationController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _presentationController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _presentationController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges(CompanyInfoData initialData) async {
    if (_formKey.currentState!.validate()) {
      final adminService = Provider.of<AdminService>(context, listen: false);
      final syncService = Provider.of<SyncService>(context, listen: false);

      final updatedInfo = CompanyInfoCompanion(
        id: Value(initialData.id),
        name: Value(_nameController.text),
        presentation: Value(_presentationController.text),
        address: Value(_addressController.text),
        phone: Value(_phoneController.text),
        email: Value(_emailController.text),
      );

      await adminService.saveCompanyInfo(updatedInfo);
      await syncService.syncAll();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informations mises à jour')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final prefs = Provider.of<PreferencesService>(context);

    return StreamBuilder<CompanyInfoData>(
      stream: db.watchCompanyInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final info = snapshot.data!;
        _nameController.text = info.name ?? '';
        _presentationController.text = info.presentation ?? '';
        _addressController.text = info.address ?? '';
        _phoneController.text = info.phone ?? '';
        _emailController.text = info.email ?? '';

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Nom de l'établissement")),
                  TextFormField(controller: _presentationController, decoration: const InputDecoration(labelText: "Texte de présentation"), maxLines: 3),
                  TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Adresse')),
                  TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Téléphone')),
                  TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _saveChanges(info),
                    child: const Text('Enregistrer les modifications'),
                  ),
                ],
              ),
            ),
            const Divider(height: 32, thickness: 1),
            Text('Préférences de Notification', style: Theme.of(context).textTheme.titleLarge),
            SwitchListTile(
              title: const Text('Notification visuelle'),
              subtitle: const Text('Affiche une bannière pour chaque nouvelle commande.'),
              value: prefs.visualNotification,
              onChanged: (value) => prefs.setVisualNotification(value),
            ),
            SwitchListTile(
              title: const Text('Notification sonore'),
              subtitle: const Text('Joue un son pour chaque nouvelle commande.'),
              value: prefs.soundNotification,
              onChanged: (value) => prefs.setSoundNotification(value),
            ),
          ],
        );
      },
    );
  }
}
