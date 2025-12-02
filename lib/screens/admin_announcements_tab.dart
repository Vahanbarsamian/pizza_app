import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';
import '../database/app_database.dart';

class AdminAnnouncementsTab extends StatefulWidget {
  final Announcement? announcementToEdit;

  const AdminAnnouncementsTab({super.key, this.announcementToEdit});

  @override
  State<AdminAnnouncementsTab> createState() => _AdminAnnouncementsTabState();
}

class _AdminAnnouncementsTabState extends State<AdminAnnouncementsTab> {
  final _titleController = TextEditingController();
  final _announcementController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _conclusionController = TextEditingController();
  bool _isLoading = false;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.announcementToEdit != null;
    if (_isEditing) {
      _titleController.text = widget.announcementToEdit!.title;
      _announcementController.text = widget.announcementToEdit!.announcementText ?? '';
      _descriptionController.text = widget.announcementToEdit!.description ?? '';
      _imageUrlController.text = widget.announcementToEdit!.imageUrl ?? '';
      _conclusionController.text = widget.announcementToEdit!.conclusion ?? '';
    }
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final adminService = Provider.of<AdminService>(context, listen: false);
      final syncService = Provider.of<SyncService>(context, listen: false);

      if (_isEditing) {
        await adminService.updateAnnouncement(
          widget.announcementToEdit!.id,
          title: _titleController.text,
          announcementText: _announcementController.text,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          conclusion: _conclusionController.text,
        );
      } else {
        await adminService.addAnnouncement(
          title: _titleController.text,
          announcementText: _announcementController.text,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          conclusion: _conclusionController.text,
        );
      }

      await syncService.syncAll();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Opération réussie !')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  Future<void> _delete() async {
     if (!_isEditing) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer l\'annonce "${widget.announcementToEdit!.title}" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Supprimer', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    setState(() => _isLoading = true);
    try {
      final adminService = Provider.of<AdminService>(context, listen: false);
      final syncService = Provider.of<SyncService>(context, listen: false);
      await adminService.deleteAnnouncement(widget.announcementToEdit!.id);
      await syncService.syncAll();
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🗑️ Annonce supprimée.')));
        Navigator.of(context).pop();
      }
    } catch (e) {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Erreur: $e")));
      }
    } finally {
       if (mounted) setState(() => _isLoading = false);
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
                Text(_isEditing ? '✏️ Modifier l\'Annonce' : '📣 Nouvelle Annonce', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Titre (en gros)', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: _announcementController, decoration: const InputDecoration(labelText: 'Annonce', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 3),
                const SizedBox(height: 12),
                TextField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'URL de l\'image', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: _conclusionController, decoration: const InputDecoration(labelText: 'Conclusion (bas de page)', border: OutlineInputBorder())),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _submit,
                    icon: Icon(_isEditing ? Icons.save : Icons.add),
                    label: Text(_isLoading ? 'Enregistrement...' : (_isEditing ? 'Mettre à jour' : 'Ajouter l\'annonce')),
                  ),
                ),
                if (_isEditing)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: _isLoading ? null : _delete,
                        icon: const Icon(Icons.delete_forever, color: Colors.red),
                        label: const Text('Supprimer cette annonce', style: TextStyle(color: Colors.red)),
                      ),
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
