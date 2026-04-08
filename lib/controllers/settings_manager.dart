import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/localization.dart';

class SettingsManager extends ChangeNotifier {
  final SharedPreferences _prefs;

  bool _holes3DEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  int _vibrationStrength = 1;
  Locale _currentLocale = const Locale('en');
  ThemeMode _currentTheme = ThemeMode.system;
  Map<int, LevelRecord> _records = {};
  int _maxOpenedLevel = 0;

  SettingsManager(this._prefs);

  // Getters
  bool get holes3DEnabled => _holes3DEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  int get vibrationStrength => _vibrationStrength;
  Locale get currentLocale => _currentLocale;
  ThemeMode get currentTheme => _currentTheme;
  Map<int, LevelRecord> get records => _records;
  int get maxOpenedLevel => _maxOpenedLevel;

  // Setters
  set holes3DEnabled(bool value) {
    _holes3DEnabled = value;
    _prefs.setBool('holes_3d_enabled', value);
    notifyListeners();
  }

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
    Localization.setLanguage(locale.languageCode);
    notifyListeners();
  }

  set currentTheme(ThemeMode theme) {
    _currentTheme = theme;
    _prefs.setInt('theme_mode', theme.index);
    notifyListeners();
  }

  set maxOpenedLevel(int value) {
    if (kDebugMode) {
      value = 61;
    }
    if (value > _maxOpenedLevel) {
      _maxOpenedLevel = value;
      _prefs.setInt('max_opened_level', value);
      notifyListeners();
    }
  }

  Future<void> loadSettings() async {
    _holes3DEnabled = _prefs.getBool('holes_3d_enabled') ?? true;
    _soundEnabled = _prefs.getBool('sound_enabled') ?? true;
    _vibrationEnabled = _prefs.getBool('vibration_enabled') ?? true;
    _vibrationStrength = _prefs.getInt('vibration_strength') ?? 1;
    _maxOpenedLevel = _prefs.getInt('max_opened_level') ?? 0;
    if (kDebugMode) {
      _maxOpenedLevel = 61;
    }

    final languageCode = _prefs.getString('language_code');
    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
    } else {
      final systemLocale = PlatformDispatcher.instance.locale;
      if (systemLocale.languageCode == 'ru' ||
          systemLocale.languageCode == 'uk' ||
          systemLocale.languageCode == 'kk' ||
          systemLocale.languageCode == 'be') {
        _currentLocale = Locale(systemLocale.languageCode);
      } else {
        _currentLocale = const Locale('en');
      }
    }

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
    print('📖 Loading records from SharedPreferences: $recordsString');

    if (recordsString != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(recordsString);
        print('📖 Decoded: $decoded');
        _records = {};
        decoded.forEach((key, value) {
          final levelIndex = int.parse(key);
          _records[levelIndex] = LevelRecord.fromJson(value);
          print(
              '📖 Loaded level $levelIndex: ${_records[levelIndex]!.moves} moves');
        });
      } catch (e) {
        print('❌ Error loading records: $e');
        _records = {};
      }
    } else {
      print('📖 No records found in SharedPreferences');
      _records = {};
    }
  }

  Future<void> saveRecord(int levelIndex, int moves) async {
    print('📝 Saving record - Level: $levelIndex, Moves: $moves');

    final newRecord = LevelRecord(moves: moves, date: DateTime.now());
    final existing = _records[levelIndex];

    print('📝 Existing record: ${existing?.moves}');

    if (existing == null || moves < existing.moves) {
      print('✅ Saving new record (better or first)');
      _records[levelIndex] = newRecord;
      await _saveRecords();
      print('✅ Records saved to SharedPreferences');
      print('📊 Current records: $_records');
      notifyListeners();
    } else {
      print('❌ Not saving - existing record is better');
    }
  }

  Future<void> _saveRecords() async {
    try {
      final Map<String, dynamic> toSave = {};
      _records.forEach((key, value) {
        toSave[key.toString()] = value.toJson();
      });
      final jsonString = jsonEncode(toSave);
      print('💾 Saving records JSON: $jsonString');
      await _prefs.setString('records', jsonString);
      print('✅ Records saved successfully');
    } catch (e) {
      print('❌ Error saving records: $e');
    }
  }

  LevelRecord? getRecord(int levelIndex) {
    return _records[levelIndex];
  }

  Future<void> resetProgress() async {
    _records.clear();
    _maxOpenedLevel = 0;
    await _prefs.remove('records');
    await _prefs.remove('max_opened_level');
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
