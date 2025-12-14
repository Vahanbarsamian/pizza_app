import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';

class AdminAnnouncementsTab extends StatefulWidget {
  const AdminAnnouncementsTab({super.key});

  @override
  State<AdminAnnouncementsTab> createState() => _AdminAnnouncementsTabState();
}

class _AdminAnnouncementsTabState extends State<AdminAnnouncementsTab> {
  Announcement? _editingAnnouncement;
  bool _isCreatingNew = false;

  // Un GlobalKey pour pouvoir scroller automatiquement quand le formulaire apparaît
  final _scrollController = ScrollController();

  void _editAnnouncement(Announcement announcement) {
    setState(() {
      _isCreatingNew = false;
      _editingAnnouncement = announcement;
      // Fait défiler vers le bas pour voir le formulaire
      _scrollToForm();
    });
  }

  void _newAnnouncement() {
    setState(() {
      _isCreatingNew = true;
      _editingAnnouncement = null;
      _scrollToForm();
    });
  }

  void _cancelEditing() {
    setState(() {
      _isCreatingNew = false;
      _editingAnnouncement = null;
    });
  }

  void _scrollToForm() {
    // Petite temporisation pour laisser le temps au formulaire de se construire
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    bool isFormVisible = _isCreatingNew || _editingAnnouncement != null;

    // ✅ CORRIGÉ: Le Scaffold est retiré et remplacé par un LayoutBuilder pour mieux gérer l'espace
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Espace en bas pour la nav bar et le FAB
        child: Column(
          children: [
            _buildAnnouncementsList(db),
            if (isFormVisible)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildAnnouncementForm(),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _newAnnouncement,
        tooltip: 'Nouvelle Annonce',
      ),
    );
  }

  Widget _buildAnnouncementsList(AppDatabase db) {
    return StreamBuilder<List<Announcement>>(
      stream: db.watchAllAnnouncementsForAdmin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final announcements = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final announcement = announcements[index];
            return Card(
              child: ListTile(
                title: Text(announcement.title, style: TextStyle(fontWeight: announcement.isActive ? FontWeight.bold : FontWeight.normal)),
                subtitle: Text(announcement.type, style: TextStyle(color: announcement.type == 'Promotion' ? Colors.green : Colors.blue)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(value: announcement.isActive, onChanged: (value) => _toggleActive(context, announcement, value)),
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editAnnouncement(announcement)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteAnnouncement(context, announcement)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAnnouncementForm() {
    return AnnouncementForm(
      key: ValueKey(_editingAnnouncement?.id ?? 'new'),
      announcement: _editingAnnouncement,
      isCreating: _isCreatingNew,
      onCancel: _cancelEditing,
      onSave: _cancelEditing,
    );
  }

  Future<void> _toggleActive(BuildContext context, Announcement announcement, bool value) async {
    final adminService = Provider.of<AdminService>(context, listen: false);
    await adminService.saveAnnouncement(
      id: announcement.id,
      title: announcement.title,
      announcementText: announcement.announcementText,
      description: announcement.description,
      imageUrl: announcement.imageUrl,
      conclusion: announcement.conclusion,
      isActive: value,
      type: announcement.type,
    );
    await Provider.of<SyncService>(context, listen: false).syncAll();
  }

  Future<void> _deleteAnnouncement(BuildContext context, Announcement announcement) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette annonce ? Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final adminService = context.read<AdminService>();
        await adminService.deleteAnnouncement(announcement.id);
        await context.read<SyncService>().syncAll();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Annonce supprimée.'), backgroundColor: Colors.green),
        );
        _cancelEditing(); // Pour cacher le formulaire après suppression
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class AnnouncementForm extends StatefulWidget {
  final Announcement? announcement;
  final bool isCreating;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;

  const AnnouncementForm({super.key, this.announcement, this.isCreating = false, this.onCancel, this.onSave});

  @override
  State<AnnouncementForm> createState() => _AnnouncementFormState();
}

class _AnnouncementFormState extends State<AnnouncementForm> {
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _conclusionController = TextEditingController();
  bool _isActive = true;
  bool _isPromotion = false;
  bool _isLoading = false;

  bool get _isEditing => widget.announcement != null;

  @override
  void initState() {
    super.initState();
    _updateFormState();
  }

  @override
  void didUpdateWidget(AnnouncementForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.announcement != oldWidget.announcement || widget.isCreating != oldWidget.isCreating) {
      _updateFormState();
    }
  }

  void _updateFormState() {
    if (!widget.isCreating && widget.announcement != null) {
      final an = widget.announcement!;
      _titleController.text = an.title;
      _textController.text = an.announcementText ?? '';
      _descriptionController.text = an.description ?? '';
      _imageUrlController.text = an.imageUrl ?? '';
      _conclusionController.text = an.conclusion ?? '';
      _isActive = an.isActive;
      _isPromotion = an.type == 'Promotion';
    } else {
      _titleController.clear();
      _textController.clear();
      _descriptionController.clear();
      _imageUrlController.clear();
      _conclusionController.clear();
      _isActive = true;
      _isPromotion = false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _conclusionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    final adminService = context.read<AdminService>();
    final syncService = context.read<SyncService>();

    try {
      await adminService.saveAnnouncement(
        id: _isEditing ? widget.announcement?.id : null,
        title: _titleController.text,
        announcementText: _textController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        conclusion: _conclusionController.text,
        isActive: _isActive,
        type: _isPromotion ? 'Promotion' : 'Annonce',
      );
      await syncService.syncAll();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Annonce sauvegardée.'), backgroundColor: Colors.green));
      widget.onSave?.call();
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = _isEditing 
        ? (_isPromotion ? 'Modifier la Promotion' : 'Modifier l\'Annonce')
        : 'Nouvelle Annonce';
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Titre', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _textController, decoration: const InputDecoration(labelText: "Texte de l'annonce", border: OutlineInputBorder()), maxLines: 3),
            const SizedBox(height: 12),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 2),
            const SizedBox(height: 12),
            TextField(controller: _imageUrlController, decoration: const InputDecoration(labelText: "URL de l'image", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _conclusionController, decoration: const InputDecoration(labelText: 'Conclusion', border: OutlineInputBorder())),
            SwitchListTile(title: const Text('Active'), value: _isActive, onChanged: (v) => setState(() => _isActive = v)),
            SwitchListTile(title: const Text('Définir comme Promotion'), value: _isPromotion, onChanged: (v) => setState(() => _isPromotion = v)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: widget.onCancel, child: const Text('Annuler')),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 3)) : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Sauvegarde...' : 'Sauvegarder'),
                  onPressed: _isLoading ? null : _save,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
