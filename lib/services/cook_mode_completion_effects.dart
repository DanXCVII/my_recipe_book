import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

abstract interface class CookModeCompletionEffects {
  Future<void> signalCompletion();

  Future<void> dispose();
}

class DeviceCookModeCompletionEffects implements CookModeCompletionEffects {
  DeviceCookModeCompletionEffects({AudioPlayer? player})
    : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  @override
  Future<void> signalCompletion() async {
    await Future.wait<void>([
      _player.play(AssetSource('audio/timer_complete.wav')),
      HapticFeedback.vibrate(),
    ]);
  }

  @override
  Future<void> dispose() => _player.dispose();
}
