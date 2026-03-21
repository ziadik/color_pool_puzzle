import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/localization.dart';

class SettingsManager extends ChangeNotifier {
  final SharedPreferences _prefs;

  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  int _vibrationStrength = 1;
  Locale _currentLocale = const Locale('en');
  ThemeMode _currentTheme = ThemeMode.system;
  Map<int, LevelRecord> _records = {};
  int _maxOpenedLevel = 0;

  SettingsManager(this._prefs);

  // Getters
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  int get vibrationStrength => _vibrationStrength;
  Locale get currentLocale => _currentLocale;
  ThemeMode get currentTheme => _currentTheme;
  Map<int, LevelRecord> get records => _records;
  int get maxOpenedLevel => _maxOpenedLevel;

  // Setters
  set soundEnabled(bool value) {
    _soundEnabled = value;
    _prefs.setBool('sound_enabled', value);
    notifyListeners();
  }

  set vibrationEnabled(bool value) {
    _vibrationEnabled = value;
    _prefs.setBool('vibration_enabled', value);
    notifyListeners();
  }

  set vibrationStrength(int value) {
    _vibrationStrength = value.clamp(0, 2);
    _prefs.setInt('vibration_strength', value);
    notifyListeners();
  }

  set currentLocale(Locale locale) {
    _currentLocale = locale;
    _prefs.setString('language_code', locale.languageCode);
    // Обновляем язык в Localization
    Localization.setLanguage(locale.languageCode);
    notifyListeners();
  }

  set currentTheme(ThemeMode theme) {
    _currentTheme = theme;
    _prefs.setInt('theme_mode', theme.index);
    notifyListeners();
  }

  set maxOpenedLevel(int value) {
    if (value > _maxOpenedLevel) {
      _maxOpenedLevel = value;
      _prefs.setInt('max_opened_level', value);
      notifyListeners();
    }
  }

  Future<void> loadSettings() async {
    _soundEnabled = _prefs.getBool('sound_enabled') ?? true;
    _vibrationEnabled = _prefs.getBool('vibration_enabled') ?? true;
    _vibrationStrength = _prefs.getInt('vibration_strength') ?? 1;
    _maxOpenedLevel = _prefs.getInt('max_opened_level') ?? 0;

    // Загружаем язык
    final languageCode = _prefs.getString('language_code');
    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
    } else {
      // Определяем системный язык
      final systemLocale = PlatformDispatcher.instance.locale;
      if (systemLocale.languageCode == 'ru' || systemLocale.languageCode == 'uk' || systemLocale.languageCode == 'kk' || systemLocale.languageCode == 'be') {
        _currentLocale = Locale(systemLocale.languageCode);
      } else {
        _currentLocale = const Locale('en');
      }
    }

    // Устанавливаем язык в Localization
    Localization.setLanguage(_currentLocale.languageCode);

    final themeModeIndex = _prefs.getInt('theme_mode');
    if (themeModeIndex != null && themeModeIndex >= 0 && themeModeIndex <= 2) {
      _currentTheme = ThemeMode.values[themeModeIndex];
    }

    await _loadRecords();
    notifyListeners();
  }

  Future<void> _loadRecords() async {
    final recordsString = _prefs.getString('records');
    if (recordsString != null) {
      try {
        // Простая реализация - в реальном проекте используйте jsonDecode
        _records = {};
      } catch (e) {
        print('Error loading records: $e');
      }
    }
    notifyListeners();
  }

  void saveRecord(int levelIndex, int moves) {
    final newRecord = LevelRecord(moves: moves, date: DateTime.now());
    final existing = _records[levelIndex];

    if (existing == null || moves < existing.moves) {
      _records[levelIndex] = newRecord;
      // В реальном проекте сохраняйте в JSON
      notifyListeners();
    }
  }

  LevelRecord? getRecord(int levelIndex) {
    return _records[levelIndex];
  }

  void resetProgress() {
    _records.clear();
    _maxOpenedLevel = 0;
    _prefs.remove('records');
    _prefs.remove('max_opened_level');
    notifyListeners();
  }

  String vibrationStrengthDescription() {
    switch (_vibrationStrength) {
      case 0:
        return Localization.getString('vibrationLight');
      case 1:
        return Localization.getString('vibrationMedium');
      case 2:
        return Localization.getString('vibrationStrong');
      default:
        return Localization.getString('vibrationMedium');
    }
  }
}

class LevelRecord {
  final int moves;
  final DateTime date;
  final double? time;

  LevelRecord({
    required this.moves,
    required this.date,
    this.time,
  });

  Map<String, dynamic> toJson() => {
        'moves': moves,
        'date': date.toIso8601String(),
        'time': time,
      };

  factory LevelRecord.fromJson(Map<String, dynamic> json) {
    return LevelRecord(
      moves: json['moves'],
      date: DateTime.parse(json['date']),
      time: json['time'],
    );
  }
}
