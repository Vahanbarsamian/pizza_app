import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playNotification() async {
    try {
      await _player.play(
        AssetSource('sounds/notification.mp3'),
      );
    } catch (e) {
      debugPrint('Erreur lecture son notification: $e');
    }
  }
}
