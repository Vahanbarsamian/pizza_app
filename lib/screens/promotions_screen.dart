import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/app_database.dart';
import '../services/auth_service.dart';
import 'admin_screen.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return StreamBuilder<List<Announcement>>(
      stream: db.watchAllAnnouncements(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final announcements = snapshot.data ?? [];

        if (announcements.isEmpty) {
          return const Center(
            child: Text('Aucune promotion pour le moment.', style: TextStyle(fontSize: 18)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final announcement = announcements[index];
            // ✅ CORRIGÉ: Utilisation d'un widget dédié pour gérer l'effet de survol
            return PromotionCard(announcement: announcement);
          },
        );
      },
    );
  }
}

// Widget dédié pour la carte de promotion
class PromotionCard extends StatefulWidget {
  final Announcement announcement;

  const PromotionCard({super.key, required this.announcement});

  @override
  State<PromotionCard> createState() => _PromotionCardState();
}

class _PromotionCardState extends State<PromotionCard> {
  double _elevation = 4.0;

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final announcement = widget.announcement;

    return InkWell(
      onTap: () { /* Pour l'instant, les promos ne sont pas cliquables, mais on pourrait ajouter un détail */ },
      onHover: (isHovering) {
        setState(() {
          _elevation = isHovering ? 12.0 : 4.0;
        });
      },
      splashColor: Colors.orange.withOpacity(0.3),
      hoverColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: _elevation,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (announcement.imageUrl != null && announcement.imageUrl!.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: announcement.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => const SizedBox(height: 200, child: Icon(Icons.error)),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(announcement.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      if (announcement.announcementText != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(announcement.announcementText!, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.orange, fontWeight: FontWeight.bold)),
                        ),
                      if (announcement.description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(announcement.description!),
                        ),
                      if (announcement.conclusion != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(announcement.conclusion!, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (authService.isAdmin)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: Icon(Icons.edit, size: 20, color: Colors.orange),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => AdminScreen(announcementToEdit: announcement)),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
