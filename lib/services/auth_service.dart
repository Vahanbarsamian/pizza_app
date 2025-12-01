import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart' hide User;

class MfaRequiredException implements Exception {
  final String message;
  MfaRequiredException(this.message);
}

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;

  // ✅ CORRECTION: Le stream 'authStateChanges' a été restauré pour assurer la compatibilité
  // avec les écrans qui l'utilisent encore.
  Stream<User?> get authStateChanges =>
      _supabase.auth.onAuthStateChange.map((data) => data.session?.user);

  AuthService() {
    // Le service écoute son propre stream pour mettre à jour son état interne
    authStateChanges.listen((user) {
      _currentUser = user;
      if (_currentUser == null) {
        _isAdmin = false; // Réinitialise le statut admin lors de la déconnexion
      }
      notifyListeners(); // Notifie l'UI de tout changement d'état d'authentification
    });
  }

  Future<void> checkAdminStatus(AppDatabase db) async {
    final user = _currentUser;
    if (user == null) {
      _isAdmin = false;
    } else {
      final superAdminId = dotenv.env['ADMIN_USER_ID'];
      if (superAdminId != null && superAdminId.isNotEmpty && superAdminId == user.id) {
        _isAdmin = true;
      } else {
        _isAdmin = await db.isAdmin(user.id);
      }
    }
    notifyListeners();
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String postalCode}) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'postal_code': postalCode},
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      // Le listener s'occupera de mettre à jour le currentUser et de notifier l'UI
    } on AuthException catch (e) {
      if (e.message.contains('MFA')) {
        throw MfaRequiredException('Authentification multi-facteurs requise.');
      } else {
        rethrow;
      }
    }
  }

  Future<void> verifyMfa({required String code}) async {
    final factors = await _supabase.auth.mfa.listFactors();
    if (factors.totp.isEmpty) {
      throw Exception("Aucun facteur MFA de type TOTP n'est configuré pour cet utilisateur.");
    }
    final totpFactor = factors.totp.first;

    await _supabase.auth.mfa.challengeAndVerify(
      factorId: totpFactor.id,
      code: code,
    );
  }

  Future<void> sendPasswordReset({required String email}) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<void> signOut() async {
    debugPrint("[AuthService] Tentative de déconnexion...");
    try {
      await _supabase.auth.signOut();
      // Le listener s'occupera de mettre l'état à jour et de notifier l'UI
      debugPrint("[AuthService] ✅ Déconnexion réussie.");
    } catch (e) {
      debugPrint("[AuthService] ❌ Erreur lors de la déconnexion: $e");
    }
  }
}
