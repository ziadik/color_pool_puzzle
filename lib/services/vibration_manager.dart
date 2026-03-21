import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../controllers/settings_manager.dart';

class VibrationManager {
  static final VibrationManager _instance = VibrationManager._internal();
  factory VibrationManager() => _instance;
  VibrationManager._internal();

  Future<bool> get isSupported => Vibration.hasVibrator();

  void lightImpact(SettingsManager settings) {
    if (!settings.vibrationEnabled) return;
    _vibrate(settings.vibrationStrength, 30);
  }

  void mediumImpact(SettingsManager settings) {
    if (!settings.vibrationEnabled) return;
    _vibrate(settings.vibrationStrength, 50);
  }

  void heavyImpact(SettingsManager settings) {
    if (!settings.vibrationEnabled) return;
    _vibrate(settings.vibrationStrength, 80);
  }

  void success(SettingsManager settings) {
    if (!settings.vibrationEnabled) return;
    _vibrate(settings.vibrationStrength, 60);
  }

  void error(SettingsManager settings) {
    if (!settings.vibrationEnabled) return;
    _vibrate(settings.vibrationStrength, 100);
  }

  void _vibrate(int strength, int duration) async {
    final hasVibrator = await Vibration.hasVibrator();
    if (!hasVibrator) return;

    final adjustedDuration = (duration * (strength + 1) / 3).round();
    await Vibration.vibrate(duration: adjustedDuration);
  }

  void preview(SettingsManager settings) async {
    if (!settings.vibrationEnabled) return;

    lightImpact(settings);
    await Future.delayed(const Duration(milliseconds: 200));
    mediumImpact(settings);
    await Future.delayed(const Duration(milliseconds: 200));
    heavyImpact(settings);
  }
}
