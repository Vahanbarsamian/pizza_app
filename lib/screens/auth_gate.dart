import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Écoute les changements d'état d'authentification de Supabase
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Si une session est active, on affiche l'écran principal
        if (snapshot.hasData && snapshot.data?.session != null) {
          return const MainScreen();
        } else {
          // Sinon, on affiche l'écran de connexion
          return const LoginScreen();
        }
      },
    );
  }
}
