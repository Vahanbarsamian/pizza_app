import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';

class AdminAnnouncementsTab extends StatelessWidget {
  const AdminAnnouncementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: StreamBuilder<List<Announcement>>(
        stream: db.watchAllAnnouncementsForAdmin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final announcements = snapshot.data!;
          return ListView.builder(
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];
              return ListTile(
                title: Text(announcement.title),
                subtitle: Text(announcement.type, style: TextStyle(color: announcement.type == 'Promotion' ? Colors.green : Colors.blue)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: announcement.isActive,
                      onChanged: (value) async {
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
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAnnouncement(context, announcement),
                    ),
                  ],
                ),
                onTap: () => _showEditAnnouncementDialog(context, announcement),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showEditAnnouncementDialog(context, null),
      ),
    );
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
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showEditAnnouncementDialog(BuildContext context, Announcement? announcement) {
    final isEditing = announcement != null;
    final titleController = TextEditingController(text: announcement?.title ?? '');
    final textController = TextEditingController(text: announcement?.announcementText ?? '');
    final descriptionController = TextEditingController(text: announcement?.description ?? '');
    final imageUrlController = TextEditingController(text: announcement?.imageUrl ?? '');
    final conclusionController = TextEditingController(text: announcement?.conclusion ?? '');
    bool isActive = announcement?.isActive ?? true;
    bool isPromotion = announcement?.type == 'Promotion';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final String dialogTitle = isEditing
                ? (isPromotion ? 'Modifier la Promotion' : 'Modifier l\'Annonce')
                : (isPromotion ? 'Nouvelle Promotion' : 'Nouvelle Annonce');

            return AlertDialog(
              title: Text(dialogTitle),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Titre')),
                    TextField(controller: textController, decoration: const InputDecoration(labelText: "Texte de l'annonce"), maxLines: 3),
                    TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 2),
                    TextField(controller: imageUrlController, decoration: const InputDecoration(labelText: "URL de l'image")),
                    TextField(controller: conclusionController, decoration: const InputDecoration(labelText: 'Conclusion')),
                    SwitchListTile(
                      title: const Text('Active'),
                      value: isActive,
                      onChanged: (value) => setState(() => isActive = value),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Définir comme Promotion'),
                      subtitle: Text(isPromotion ? 'Sera visible dans la section Promotions' : 'Sera visible comme une simple Annonce'),
                      value: isPromotion,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          isPromotion = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
                ElevatedButton(
                  child: const Text('Sauvegarder'),
                  onPressed: () async {
                    final adminService = Provider.of<AdminService>(context, listen: false);
                    final syncService = Provider.of<SyncService>(context, listen: false);

                    await adminService.saveAnnouncement(
                      id: announcement?.id,
                      title: titleController.text,
                      announcementText: textController.text,
                      description: descriptionController.text,
                      imageUrl: imageUrlController.text,
                      conclusion: conclusionController.text,
                      isActive: isActive,
                      type: isPromotion ? 'Promotion' : 'Annonce',
                    );

                    await syncService.syncAll();
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
