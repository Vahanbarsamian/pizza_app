import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/preferences_service.dart';

class AdminOrderSettingsScreen extends StatefulWidget {
  const AdminOrderSettingsScreen({super.key});

  @override
  State<AdminOrderSettingsScreen> createState() => _AdminOrderSettingsScreenState();
}

class _AdminOrderSettingsScreenState extends State<AdminOrderSettingsScreen> {
  late bool _visualNotification;
  late bool _soundNotification;

  @override
  void initState() {
    super.initState();
    final prefs = context.read<PreferencesService>();
    _visualNotification = prefs.visualNotification;
    _soundNotification = prefs.soundNotification;
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.read<PreferencesService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réglages des Commandes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Notifications des Nouvelles Commandes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Notification visuelle'),
            subtitle: const Text('Affiche une bannière pour chaque nouvelle commande.'),
            value: _visualNotification,
            onChanged: (value) {
              setState(() => _visualNotification = value);
              prefs.setVisualNotification(value);
            },
          ),
          SwitchListTile(
            title: const Text('Notification sonore'),
            subtitle: const Text('Joue un son pour chaque nouvelle commande.'),
            value: _soundNotification,
            onChanged: (value) {
              setState(() => _soundNotification = value);
              prefs.setSoundNotification(value);
            },
          ),
        ],
      ),
    );
  }
}
