import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/auth_service.dart';
import 'admin_menu_tab.dart';
import 'admin_announcements_tab.dart';
import 'admin_info_tab.dart';

class AdminScreen extends StatefulWidget {
  final Product? productToEdit;
  final Announcement? announcementToEdit;

  const AdminScreen({super.key, this.productToEdit, this.announcementToEdit});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.productToEdit != null) {
      _selectedIndex = 0; // Menu
    } else if (widget.announcementToEdit != null) {
      _selectedIndex = 1; // Annonces
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    // ✅ CORRIGÉ: La liste des widgets est simplifiée, l'onglet Options est retiré
    final List<Widget> widgetOptions = <Widget>[
      AdminMenuTab(productToEdit: widget.productToEdit),
      AdminAnnouncementsTab(announcementToEdit: widget.announcementToEdit),
      const AdminInfoTab(),
    ];

    const List<String> titles = <String>[
      'Admin / Menu & Options', // Titre mis à jour
      'Admin / Annonces',
      'Admin / Infos',
    ];

    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titles.elementAt(_selectedIndex)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour au site',
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.lightGreenAccent),
            tooltip: 'Déconnexion complète',
            onPressed: () {
              authService.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      // ✅ CORRIGÉ: La barre de navigation est simplifiée
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu & Options'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Annonces'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Infos'),
        ],
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
