import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/preferences_service.dart';

class AdminSecurityTab extends StatelessWidget {
  const AdminSecurityTab({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PreferencesService>();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Card(
            color: Color(0xFF2C3E50),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, color: Colors.white, size: 32),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Paramètres de sécurité de l\'administration',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'AUTHENTIFICATION BIOMÉTRIQUE',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: const Text('Accès rapide par empreinte'),
              subtitle: const Text('Demander l\'empreinte digitale pour accéder au Panneau Admin sur cet appareil.'),
              secondary: const Icon(Icons.fingerprint, color: Colors.blue, size: 32),
              value: prefs.biometricEnabled,
              onChanged: (value) => prefs.setBiometricEnabled(value),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Note : Ce réglage est propre à chaque appareil. Vous pouvez l\'activer sur votre téléphone et le laisser désactivé sur votre tablette.',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
