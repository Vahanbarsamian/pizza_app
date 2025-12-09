import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../services/sync_service.dart';
import '../services/cart_service.dart';
import 'main_screen.dart';

class PizzaSplashScreen extends StatefulWidget {
  const PizzaSplashScreen({super.key});

  @override
  State<PizzaSplashScreen> createState() => _PizzaSplashScreenState();
}

class _PizzaSplashScreenState extends State<PizzaSplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  String _loadingMessage = 'À table en quelques clics...';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    if (mounted) {
      setState(() {
        _hasError = false;
        _loadingMessage = 'Synchronisation des données...';
      });
    }

    try {
      final syncService = context.read<SyncService>();
      final cartService = context.read<CartService>();

      // Exécute les deux tâches lourdes en parallèle
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF6B35), // tomate mûre
              Color(0xFFF7931E), // pâte dorée  
              Color(0xFFFFD23F), // fromage fondu
            ],
            stops: [0.0, 0.6, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animation pizza Pro
                SizedBox(
                  height: 240,
                  child: Lottie.asset(
                    'assets/animations/pizza_pro_splash.json',
                    controller: _controller,
                    filterQuality: FilterQuality.high,
                    frameRate: FrameRate(60),
                    onLoaded: (composition) {
                      _controller
                        ..duration = const Duration(seconds: 3)
                        ..repeat();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Nom de l'app
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Pizza Mania le Puy en Velay',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _loadingMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                  textAlign: TextAlign.center, // ✅ AJOUTÉ: Pour centrer le message si il est sur plusieurs lignes
                ),
                if (_hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      onPressed: _initializeApp, 
                      label: const Text('Réessayer'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
