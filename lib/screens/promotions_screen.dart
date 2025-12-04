import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pizza_app/screens/admin_announcements_tab.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final authService = context.watch<AuthService>();

    return Scaffold(
      body: StreamBuilder<List<Announcement>>(
        stream: db.watchAllAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Il n'y a aucune promotion ou annonce pour le moment."));
          }

          final allItems = snapshot.data!;
          final promotions = allItems.where((item) => item.type == 'Promotion').toList();
          final announcements = allItems.where((item) => item.type == 'Annonce').toList();

          if (promotions.isEmpty && announcements.isEmpty) {
            return const Center(child: Text("Il n'y a aucune promotion ou annonce pour le moment."));
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (promotions.isNotEmpty)
                _buildSection(context, 'Promotions', promotions, authService.isAdmin),
              
              if (promotions.isNotEmpty && announcements.isNotEmpty)
                const Divider(height: 32, thickness: 1, indent: 20, endIndent: 20),

              if (announcements.isNotEmpty)
                _buildSection(context, 'Annonces', announcements, authService.isAdmin),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Announcement> items, bool isAdmin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => AnnouncementCard(announcement: item, isAdmin: isAdmin)),
      ],
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final bool isAdmin;

  const AnnouncementCard({super.key, required this.announcement, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (announcement.imageUrl != null && announcement.imageUrl!.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: announcement.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                  placeholder: (context, url) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(announcement.title, style: Theme.of(context).textTheme.titleLarge),
                    if (announcement.announcementText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(announcement.announcementText!),
                      ),
                    if (announcement.description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(announcement.description!, style: Theme.of(context).textTheme.bodySmall),
                      ),
                    if (announcement.conclusion != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(announcement.conclusion!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (announcement.type == 'Promotion')
            _buildBanner('PROMO', Colors.amber, Colors.black),
          if (isAdmin)
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.6),
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                  onPressed: () {
                    // Navigue vers l'écran admin pour l'édition
                    // Note: Cela nécessite une méthode pour naviguer et afficher le dialogue, 
                    // que nous allons placer dans admin_announcements_tab.dart pour la réutiliser.
                    // Pour l'instant, on fait une navigation simple, on affinera si besoin.
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminAnnouncementsTab()));
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBanner(String text, Color backgroundColor, Color textColor) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: 80,
        height: 80,
        child: ClipRect(
          child: Banner(
            message: text,
            location: BannerLocation.topStart,
            color: backgroundColor,
            textStyle: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
