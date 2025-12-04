import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart' hide User;

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? _currentUser;
  bool _isAdmin = false;

  User? get currentUser => _currentUser;
  bool get isAdmin => _isAdmin;

  Stream<User?> get authStateChanges => _supabase.auth.onAuthStateChange.map((data) => data.session?.user);

  AuthService() {
    _supabase.auth.onAuthStateChange.listen((data) {
      _currentUser = data.session?.user;
      // Ne pas vérifier le statut admin automatiquement
      if (_currentUser == null) {
        _isAdmin = false;
      }
      notifyListeners();
    });
  }

  // Cette méthode n'est plus appelée automatiquement
  void _checkAdminStatus() {
    final adminUuid = dotenv.env['ADMIN_UUID'];
    if (adminUuid != null && _currentUser != null && adminUuid.isNotEmpty) {
      _isAdmin = (_currentUser!.id == adminUuid);
    } else {
      _isAdmin = false;
    }
  }

  Future<void> signInAsAdmin({required String email, required String password}) async {
    try {
      final authResponse = await _supabase.auth.signInWithPassword(email: email, password: password);
      if (authResponse.user == null) {
        throw 'Utilisateur ou mot de passe incorrect.';
      }

      final adminUuid = dotenv.env['ADMIN_UUID'];
      if (adminUuid == null || adminUuid.isEmpty || authResponse.user!.id != adminUuid) {
        await _supabase.auth.signOut();
        throw 'Accès refusé. Vous n\'êtes pas un administrateur.';
      }
      
      _currentUser = authResponse.user;
      _isAdmin = true; // ✅ Seule cette méthode met isAdmin à true
      notifyListeners();

    } catch (e) {
      await _supabase.auth.signOut().catchError((_) {});
      rethrow;
    }
  }

  Future<void> signInWithPassword({required String email, required String password}) async {
    try {
      final authResponse = await _supabase.auth.signInWithPassword(email: email, password: password);
      if (authResponse.user != null) {
        _currentUser = authResponse.user;
        _isAdmin = false; // ✅ Le login normal force le statut à USER
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur de connexion: $e');
      rethrow;
    }
  }

  Future<void> signUp({required String email, required String password, String? name, String? postalCode}) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'postal_code': postalCode},
      );
      if (response.user != null) {
        _currentUser = response.user;
        _isAdmin = false; // ✅ Un nouvel inscrit est toujours un USER
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur d\'inscription: $e');
      rethrow;
    }
  }

  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      debugPrint('Erreur de réinitialisation: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _isAdmin = false; // ✅ Réinitialisation du statut admin à la déconnexion
    notifyListeners();
  }
}
