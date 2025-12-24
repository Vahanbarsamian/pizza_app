import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:image_picker/image_picker.dart';

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';
import '../services/preferences_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class AdminInfoTab extends StatefulWidget {
  const AdminInfoTab({super.key});

  @override
  State<AdminInfoTab> createState() => _AdminInfoTabState();
}

class _AdminInfoTabState extends State<AdminInfoTab> {
  final _formKey = GlobalKey<FormState>();
  bool _isUploading = false;
  bool _isSaving = false;
  bool _initialDataLoaded = false; // ✅ AJOUT : Empêche l'écrasement des saisies
  
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
  final _logoUrlController = TextEditingController();
  final _tvaRateController = TextEditingController();
  final _googleUrlController = TextEditingController();
  final _pagesJaunesUrlController = TextEditingController();

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
    _logoUrlController.dispose();
    _tvaRateController.dispose();
    _googleUrlController.dispose();
    _pagesJaunesUrlController.dispose();
    super.dispose();
  }

  void _updateControllers(CompanyInfoData? data) {
    // ✅ MODIFIÉ : On ne met à jour que si les données ne sont pas encore chargées
    if (data == null || _isSaving || _initialDataLoaded) return;
    
    _initialDataLoaded = true; // Marquer comme chargé
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
    _logoUrlController.text = data.logoUrl ?? '';
    _tvaRateController.text = data.tvaRate != null ? (data.tvaRate! * 100).toString() : '';
    _googleUrlController.text = data.googleUrl ?? '';
    _pagesJaunesUrlController.text = data.pagesJaunesUrl ?? '';
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final adminService = context.read<AdminService>();
      final syncService = context.read<SyncService>();

      final tvaRateFromInput = double.tryParse(_tvaRateController.text) ?? 0.0;
      final tvaRateForDb = tvaRateFromInput / 100.0;

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
        logoUrl: Value(_logoUrlController.text),
        tvaRate: Value(tvaRateForDb),
        googleUrl: Value(_googleUrlController.text),
        pagesJaunesUrl: Value(_pagesJaunesUrlController.text),
      );

      try {
        await adminService.saveCompanyInfo(updatedInfo);
        await syncService.syncAll();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Informations mises à jour !'), backgroundColor: Colors.green,));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erreur: $e'), backgroundColor: Colors.red,));
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final storageService = context.read<StorageService>();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      setState(() => _isUploading = true);
      try {
        final imageUrl = await storageService.uploadProductImage(pickedFile);
        setState(() {
          _logoUrlController.text = imageUrl; // ✅ Remplacera maintenant correctement le champ
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image uploadée avec succès !'), backgroundColor: Colors.green));
      } catch (e) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur lors de l'upload de l'image: $e"), backgroundColor: Colors.red));
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

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionCard(
            context,
            title: 'Informations Générales',
            icon: Icons.storefront,
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Nom de l'établissement")),
              TextFormField(controller: _logoUrlController, decoration: const InputDecoration(labelText: "URL du logo")),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : OutlinedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Uploader une image depuis l\'appareil'),
                      onPressed: _pickAndUploadImage,
                    ),
              ),
              TextFormField(controller: _presentationController, decoration: const InputDecoration(labelText: "Texte de présentation"), maxLines: 3),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Adresse')),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Téléphone')),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            ]
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            title: 'Réseaux Sociaux',
            icon: Icons.public,
            children: [
              TextFormField(controller: _facebookController, decoration: const InputDecoration(labelText: 'Lien Facebook')),
              TextFormField(controller: _instagramController, decoration: const InputDecoration(labelText: 'Lien Instagram')),
              TextFormField(controller: _xController, decoration: const InputDecoration(labelText: 'Lien X (Twitter)')),
              TextFormField(controller: _whatsappController, decoration: const InputDecoration(labelText: 'Numéro WhatsApp')),
              TextFormField(controller: _googleUrlController, decoration: const InputDecoration(labelText: 'Lien Google')),
              TextFormField(controller: _pagesJaunesUrlController, decoration: const InputDecoration(labelText: 'Lien Pages Jaunes')),
            ]
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            title: 'Coordonnées & Fiscalité',
            icon: Icons.map_outlined,
            children: [
              TextFormField(controller: _latitudeController, decoration: const InputDecoration(labelText: 'Latitude'), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
              TextFormField(controller: _longitudeController, decoration: const InputDecoration(labelText: 'Longitude'), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
              TextFormField(controller: _tvaRateController, decoration: const InputDecoration(labelText: 'Taux de TVA en %', hintText: '10'), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            ]
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            title: 'Préférences de Notification',
            icon: Icons.notifications_active,
            children: [
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: NotificationService.playNotification,
                    child: const Text('🔊 Tester le son'),
                  ),
                ),
              ),
            ]
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            onPressed: _isSaving ? null : _saveChanges,
            child: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                : const Text(
                    'Enregistrer les modifications',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: children.expand((widget) => [widget, const SizedBox(height: 12)]).toList()..removeLast(),
            ),
          ),
        ],
      ),
    );
  }
}
