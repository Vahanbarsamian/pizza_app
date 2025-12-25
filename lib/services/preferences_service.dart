import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService extends ChangeNotifier {
  late SharedPreferences _prefs;

  bool _visualNotification = true;
  bool _soundNotification = true;
  bool _biometricEnabled = false; // ✅ NOUVEAU

  bool get visualNotification => _visualNotification;
  bool get soundNotification => _soundNotification;
  bool get biometricEnabled => _biometricEnabled; // ✅ NOUVEAU

  PreferencesService() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _visualNotification = _prefs.getBool('visualNotification') ?? true;
    _soundNotification = _prefs.getBool('soundNotification') ?? true;
    _biometricEnabled = _prefs.getBool('biometricEnabled') ?? false; // ✅ NOUVEAU
    notifyListeners();
  }

  Future<void> setVisualNotification(bool value) async {
    _visualNotification = value;
    await _prefs.setBool('visualNotification', value);
    notifyListeners();
  }

  Future<void> setSoundNotification(bool value) async {
    _soundNotification = value;
    await _prefs.setBool('soundNotification', value);
    notifyListeners();
  }

  // ✅ NOUVEAU
  Future<void> setBiometricEnabled(bool value) async {
    _biometricEnabled = value;
    await _prefs.setBool('biometricEnabled', value);
    notifyListeners();
  }
}
