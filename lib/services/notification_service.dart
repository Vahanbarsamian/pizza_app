import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final AudioPlayer _player = AudioPlayer();
  
  static Future<void> playNotification() async {
    try {
      await _player.play(AssetSource('sounds/notification.mp3'));
      debugPrint('[NotificationService] ✅ Son joué');
    } catch (e) {
      debugPrint('[NotificationService] ❌ Erreur: $e');
    }
  }
  
  static Future<void> stop() async {
    await _player.stop();
  }
}
