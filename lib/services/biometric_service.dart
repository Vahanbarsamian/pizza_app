import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  // Vérifie si le téléphone possède un capteur et s'il est configuré
  Future<bool> canCheckBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();
      return canAuthenticateWithBiometrics && isDeviceSupported;
    } on PlatformException catch (e) {
      print('❌ Erreur vérification biométrie: $e');
      return false;
    }
  }

  // Lance la demande d'empreinte
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Veuillez scanner votre empreinte pour accéder au Panneau Admin',
        options: const AuthenticationOptions(
          stickyAuth: true, // Garde l'authentification active si l'app passe en arrière-plan
          biometricOnly: true, // Utilise uniquement empreinte/visage
        ),
      );
    } on PlatformException catch (e) {
      print('❌ Erreur authentification: $e');
      return false;
    }
  }
}
