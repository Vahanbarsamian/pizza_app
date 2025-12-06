import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/preferences_service.dart';
import '../widgets/admin_section_title.dart';
import 'company_info_edit_screen.dart';
import 'announcements_list_screen.dart';

class AdminInfoTab extends StatefulWidget {
  const AdminInfoTab({super.key});

  @override
  State<AdminInfoTab> createState() => _AdminInfoTabState();
}

class _AdminInfoTabState extends State<AdminInfoTab> {
  late bool _visualNotificationState;
  late bool _soundNotificationState;

  @override
  void initState() {
    super.initState();
    final prefs = context.read<PreferencesService>();
    _visualNotificationState = prefs.visualNotification;
    _soundNotificationState = prefs.soundNotification;
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.read<PreferencesService>();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const AdminSectionTitle(title: 'Gestion du Contenu'),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.business_outlined),
                title: const Text('Informations de l\'établissement'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CompanyInfoEditScreen(),
                  ));
                },
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.campaign_outlined),
                title: const Text('Annonces et Nouveautés'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AnnouncementsListScreen(),
                  ));
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const AdminSectionTitle(title: 'Réglages des Notifications'),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Notification visuelle'),
                subtitle: const Text('Affiche un bandeau à l\'arrivée d\'une commande'),
                secondary: const Icon(Icons.visibility_outlined),
                value: _visualNotificationState,
                onChanged: (value) {
                  setState(() => _visualNotificationState = value);
                  prefs.setVisualNotification(value);
                },
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              SwitchListTile(
                title: const Text('Notification sonore'),
                subtitle: const Text('Joue un son à l\'arrivée d\'une commande'),
                secondary: const Icon(Icons.volume_up_outlined),
                value: _soundNotificationState,
                onChanged: (value) {
                  setState(() => _soundNotificationState = value);
                  prefs.setSoundNotification(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
