import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/sync_service.dart';
import '../services/cart_service.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadingMessage = 'Synchronisation des données...';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Reset error state on retry
    if (_hasError) {
      setState(() {
        _hasError = false;
        _loadingMessage = 'Synchronisation des données...';
      });
    }

    try {
      final syncService = context.read<SyncService>();
      final cartService = context.read<CartService>();

      // Exécute les deux tâches en parallèle pour plus de rapidité
      await Future.wait([
        syncService.syncAll(),
        cartService.loadCart(),
      ]);
      
      // Une fois terminé, on navigue vers l'écran principal
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingMessage = 'La synchronisation a échoué. Veuillez vérifier votre connexion.';
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PulsatingIcon(icon: Icons.local_pizza_outlined),
            const SizedBox(height: 24),
            Text(
              _loadingMessage,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (_hasError)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: _initializeApp, 
                  label: const Text('Réessayer')
                ),
              )
          ],
        ),
      ),
    );
  }
}

// Une animation simple pour faire patienter
class PulsatingIcon extends StatefulWidget {
  final IconData icon;
  const PulsatingIcon({super.key, required this.icon});

  @override
  State<PulsatingIcon> createState() => _PulsatingIconState();
}

class _PulsatingIconState extends State<PulsatingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_controller),
      child: Icon(widget.icon, size: 80, color: Theme.of(context).primaryColor),
    );
  }
}
