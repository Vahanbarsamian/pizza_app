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
  
  final _nameController = TextEditingController();
  final _presentationController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _xController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  // ✅ AJOUTÉ
  final _logoUrlController = TextEditingController();
  final _tvaRateController = TextEditingController();


  @override
  void dispose() {
    _nameController.dispose();
    _presentationController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _xController.dispose();
    _whatsappController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _logoUrlController.dispose(); // ✅ AJOUTÉ
    _tvaRateController.dispose(); // ✅ AJOUTÉ
    super.dispose();
  }

  void _updateControllers(CompanyInfoData? data) {
    if (data == null) return;
    _nameController.text = data.name ?? '';
    _presentationController.text = data.presentation ?? '';
    _addressController.text = data.address ?? '';
    _phoneController.text = data.phone ?? '';
    _emailController.text = data.email ?? '';
    _facebookController.text = data.facebookUrl ?? '';
    _instagramController.text = data.instagramUrl ?? '';
    _xController.text = data.xUrl ?? '';
    _whatsappController.text = data.whatsappPhone ?? '';
    _latitudeController.text = data.latitude?.toString() ?? '';
    _longitudeController.text = data.longitude?.toString() ?? '';
    _logoUrlController.text = data.logoUrl ?? ''; // ✅ AJOUTÉ
    _tvaRateController.text = data.tvaRate?.toString() ?? ''; // ✅ AJOUTÉ
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final adminService = context.read<AdminService>();
      final syncService = context.read<SyncService>();

      final updatedInfo = CompanyInfoCompanion(
        id: const Value(1),
        name: Value(_nameController.text),
        presentation: Value(_presentationController.text),
        address: Value(_addressController.text),
        phone: Value(_phoneController.text),
        email: Value(_emailController.text),
        facebookUrl: Value(_facebookController.text),
        instagramUrl: Value(_instagramController.text),
        xUrl: Value(_xController.text),
        whatsappPhone: Value(_whatsappController.text),
        latitude: Value(double.tryParse(_latitudeController.text)),
        longitude: Value(double.tryParse(_longitudeController.text)),
        logoUrl: Value(_logoUrlController.text), // ✅ AJOUTÉ
        tvaRate: Value(double.tryParse(_tvaRateController.text)), // ✅ AJOUTÉ
      );

      try {
        await adminService.saveCompanyInfo(updatedInfo);
        await syncService.syncAll();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informations mises à jour'), backgroundColor: Colors.green,));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red,));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return StreamBuilder<CompanyInfoData?>(
      stream: db.watchCompanyInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Aucune information sur l\'entreprise trouvée. Ajoutez-en une via Supabase.'));
        }

        _updateControllers(snapshot.data);

        return _buildForm();
      },
    );
  }

  Widget _buildForm() {
    final prefs = context.watch<PreferencesService>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Informations Générales', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Nom de l'établissement")),
              const SizedBox(height: 12),
              // ✅ AJOUTÉ: Champ pour l'URL du logo
              TextFormField(controller: _logoUrlController, decoration: const InputDecoration(labelText: "URL du logo")),
              const SizedBox(height: 12),
              TextFormField(controller: _presentationController, decoration: const InputDecoration(labelText: "Texte de présentation"), maxLines: 3),
              const SizedBox(height: 12),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Adresse')),
              const SizedBox(height: 12),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Téléphone')),
              const SizedBox(height: 12),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
              const Divider(height: 32),
              Text('Réseaux Sociaux', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(controller: _facebookController, decoration: const InputDecoration(labelText: 'Lien Facebook')),
              const SizedBox(height: 12),
              TextFormField(controller: _instagramController, decoration: const InputDecoration(labelText: 'Lien Instagram')),
              const SizedBox(height: 12),
              TextFormField(controller: _xController, decoration: const InputDecoration(labelText: 'Lien X (Twitter)')),
              const SizedBox(height: 12),
              TextFormField(controller: _whatsappController, decoration: const InputDecoration(labelText: 'Numéro WhatsApp')),
              const Divider(height: 32),
              Text('Coordonnées & Fiscalité', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(controller: _latitudeController, decoration: const InputDecoration(labelText: 'Latitude'), keyboardType: TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 12),
              TextFormField(controller: _longitudeController, decoration: const InputDecoration(labelText: 'Longitude'), keyboardType: TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 12),
              // ✅ AJOUTÉ: Champ pour le taux de TVA
              TextFormField(controller: _tvaRateController, decoration: const InputDecoration(labelText: 'Taux de TVA (ex: 0.1 pour 10%)', hintText: '0.1'), keyboardType: TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                onPressed: _saveChanges,
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
  }
}
