import '../models/admin.dart';

class AdminAuthService {
  static Admin? _currentUser;

  // ✅ Login avec gestion d'erreur
  static Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simu réseau
    if (Admin.authenticate(email, password)) {
      _currentUser = Admin(
        id: 1,
        email: email,
        password: password,
        role: 'superadmin',
      );
      print('✅ Admin connecté: $email');
      return true;
    }
    print('❌ Login échoué');
    return false;
  }

  // ✅ Logout
  static void logout() {
    _currentUser = null;
    print('✅ Admin déconnecté');
  }

  // ✅ Vérif admin connecté
  static bool get isLoggedIn => _currentUser != null;

  static Admin? get currentUser => _currentUser;
}
