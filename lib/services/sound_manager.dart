import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../controllers/settings_manager.dart';
import 'package:provider/provider.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  
  Future<void> init() async {
    if (_isInitialized) return;
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _isInitialized = true;
  }
  
  void dispose() {
    _audioPlayer.dispose();
  }
  
  void playBallMoveSound(SettingsManager settings) {
    if (!settings.soundEnabled) return;
    _playSound('ball_hit2.mp3');
  }
  
  void playHoleCaptureSound(SettingsManager settings) {
    if (!settings.soundEnabled) return;
    _playSound('hole_hit.mp3');
  }
  
  void playVictorySound(SettingsManager settings) {
    if (!settings.soundEnabled) return;
    _playSound('good_job.mp3');
  }
  
  void _playSound(String fileName) async {
    try {
      await _audioPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}