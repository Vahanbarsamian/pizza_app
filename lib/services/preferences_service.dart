import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService extends ChangeNotifier {
  late SharedPreferences _prefs;

  bool _visualNotification = true;
  bool _soundNotification = true;

  bool get visualNotification => _visualNotification;
  bool get soundNotification => _soundNotification;

  PreferencesService() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _visualNotification = _prefs.getBool('visualNotification') ?? true;
    _soundNotification = _prefs.getBool('soundNotification') ?? true;
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
}
