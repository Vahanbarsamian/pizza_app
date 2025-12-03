
import 'package:flutter/material.dart';

class ClientAreaScreen extends StatelessWidget {
  const ClientAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Espace Client'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Bientôt ici : votre historique et vos avantages !'),
      ),
    );
  }
}
