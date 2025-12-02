import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';

class AdminInfoTab extends StatefulWidget {
  const AdminInfoTab({super.key});

  @override
  State<AdminInfoTab> createState() => _AdminInfoTabState();
}

class _AdminInfoTabState extends State<AdminInfoTab> {
  final _nameController = TextEditingController();
  final _presentationController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _xController = TextEditingController();
  final _whatsappController = TextEditingController();
  // ✅ Nouveaux contrôleurs pour les coordonnées
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = Provider.of<AppDatabase>(context, listen: false);
    db.watchCompanyInfo().first.then((info) {
      if (info != null && mounted) {
        setState(() {
          _nameController.text = info.name ?? '';
          _presentationController.text = info.presentation ?? '';
          _addressController.text = info.address ?? '';
          _phoneController.text = info.phone ?? '';
          _emailController.text = info.email ?? '';
          _facebookController.text = info.facebookUrl ?? '';
          _instagramController.text = info.instagramUrl ?? '';
          _xController.text = info.xUrl ?? '';
          _whatsappController.text = info.whatsappPhone ?? '';
          // ✅ Pré-remplissage des coordonnées
          _latitudeController.text = info.latitude?.toString() ?? '';
          _longitudeController.text = info.longitude?.toString() ?? '';
        });
      }
    });
  }

  Future<void> _updateInfo() async {
    setState(() => _isLoading = true);
    try {
      final adminService = Provider.of<AdminService>(context, listen: false);
      final syncService = Provider.of<SyncService>(context, listen: false);

      await adminService.updateCompanyInfo(
        name: _nameController.text,
        presentation: _presentationController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        facebookUrl: _facebookController.text,
        instagramUrl: _instagramController.text,
        xUrl: _xController.text,
        whatsappPhone: _whatsappController.text,
        // ✅ Envoi des nouvelles coordonnées
        latitude: double.tryParse(_latitudeController.text),
        longitude: double.tryParse(_longitudeController.text),
      );

      await syncService.syncAll();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Informations mises à jour !'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erreur: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(radius: 30, backgroundColor: Colors.blue, child: Icon(Icons.info_outline, color: Colors.white, size: 30)),
                const SizedBox(height: 12),
                const Text("Informations de l'entreprise", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nom de l\'entreprise', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: _presentationController, decoration: const InputDecoration(labelText: 'Texte de présentation', border: OutlineInputBorder()), maxLines: 4),
                const Divider(height: 32),
                const Text('Localisation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                 const SizedBox(height: 12),
                TextField(controller: _addressController, decoration: const InputDecoration(labelText: 'Adresse', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextField(controller: _latitudeController, decoration: const InputDecoration(labelText: 'Latitude', border: OutlineInputBorder()))),
                    const SizedBox(width: 12),
                    Expanded(child: TextField(controller: _longitudeController, decoration: const InputDecoration(labelText: 'Longitude', border: OutlineInputBorder()))),
                  ],
                ),
                const Divider(height: 32),
                const Text('Contact', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email de contact', border: OutlineInputBorder())),
                const Divider(height: 32),
                const Text('Réseaux Sociaux', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(controller: _facebookController, decoration: const InputDecoration(labelText: 'URL Facebook', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: _instagramController, decoration: const InputDecoration(labelText: 'URL Instagram', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: _xController, decoration: const InputDecoration(labelText: 'URL X (Twitter)', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: _whatsappController, decoration: const InputDecoration(labelText: 'Numéro WhatsApp (ex: 33612345678)', border: OutlineInputBorder())),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _updateInfo,
                    icon: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                    label: Text(_isLoading ? 'Enregistrement...' : 'Enregistrer les modifications'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
