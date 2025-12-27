import 'package:flutter/material.dart'; // ✅ Changé de foundation à material pour ThemeMode
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService extends ChangeNotifier {
  late SharedPreferences _prefs;

  bool _visualNotification = true;
  bool _soundNotification = true;
  bool _biometricEnabled = false;
  
  // ✅ NOUVEAU : Gestion du thème
  ThemeMode _themeMode = ThemeMode.light;

  bool get visualNotification => _visualNotification;
  bool get soundNotification => _soundNotification;
  bool get biometricEnabled => _biometricEnabled;
  ThemeMode get themeMode => _themeMode;

  PreferencesService() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _visualNotification = _prefs.getBool('visualNotification') ?? true;
    _soundNotification = _prefs.getBool('soundNotification') ?? true;
    _biometricEnabled = _prefs.getBool('biometricEnabled') ?? false;
    
    // Charger le thème (0 = light, 1 = dark)
    final themeIndex = _prefs.getInt('themeMode') ?? 0;
    _themeMode = themeIndex == 0 ? ThemeMode.light : ThemeMode.dark;
    
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

  Future<void> setBiometricEnabled(bool value) async {
    _biometricEnabled = value;
    await _prefs.setBool('biometricEnabled', value);
    notifyListeners();
  }

  // ✅ NOUVEAU : Changer le thème
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _prefs.setInt('themeMode', _themeMode == ThemeMode.light ? 0 : 1);
    notifyListeners();
  }
}
