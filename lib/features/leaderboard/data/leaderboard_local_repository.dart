import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

import '../domain/i_leaderboard_repository.dart';
import '../domain/leaderboard_entity.dart';
import 'leaderboard_dto.dart';

/// Ключи для хранения данных в SharedPreferences
const _kLeaderboardData = 'leaderboard_data';
const _kLeaderboardCounter = 'leaderboard_id_counter';

/// Реализация репозитория для таблицы лидеров с локальным хранением
final class LeaderboardLocalRepository implements ILeaderboardRepository {
  late SharedPreferences _prefs;

  LeaderboardLocalRepository() {
    _initPrefs();
  }

  /// Инициализация SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Получение всех записей лидерборда из хранилища
  Map<String, dynamic> _getAllLeaderboardEntries() {
    final entriesJson = _prefs.getString(_kLeaderboardData);
    if (entriesJson == null || entriesJson.isEmpty) {
      return {};
    }
    return Map<String, dynamic>.from(json.decode(entriesJson));
  }

  /// Сохранение всех записей лидерборда в хранилище
  Future<void> _saveAllLeaderboardEntries(Map<String, dynamic> entries) async {
    await _prefs.setString(_kLeaderboardData, json.encode(entries));
  }

  /// Генерация уникального ID для записи
  String _generateEntryId() {
    final counter = _prefs.getInt(_kLeaderboardCounter) ?? 0;
    final newCounter = counter + 1;
    _prefs.setInt(_kLeaderboardCounter, newCounter);
    return 'entry_$newCounter';
  }

  /// Получение текущего ID пользователя
  Future<String?> _getCurrentUserId() async {
    await _initPrefs();
    return _prefs.getString('current_user_id');
  }

  /// Получение информации о пользователе (имитация JOIN с Profiles)
  Future<Map<String, dynamic>?> _getUserProfile(String userId) async {
    await _initPrefs();
    final usersJson = _prefs.getString('users_data');
    if (usersJson == null || usersJson.isEmpty) {
      return null;
    }

    final users = Map<String, dynamic>.from(json.decode(usersJson));
    final userData = users[userId] as Map<String, dynamic>?;

    if (userData == null) {
      return null;
    }

    return {
      'username': userData['username'] ?? 'Аноним',
      'avatar_url': userData['avatar_url'],
      'profiles': {'username': userData['username'] ?? 'Аноним', 'avatar_url': userData['avatar_url']},
    };
  }

  @override
  Future<Iterable<LeaderboardEntity>> fetchLeaderboard() async {
    await _initPrefs();

    try {
      final entries = _getAllLeaderboardEntries();

      // Преобразуем записи в список сущностей
      final List<LeaderboardEntity> leaderboard = [];

      for (final entry in entries.values) {
        final entryData = entry as Map<String, dynamic>;

        // Получаем информацию о пользователе
        final userId = entryData['userId'];
        final userProfile = await _getUserProfile(userId);

        // Создаем объединенные данные (имитация SQL JOIN)
        final combinedData = Map<String, dynamic>.from(entryData);
        if (userProfile != null) {
          combinedData['profiles'] = userProfile['profiles'];
        } else {
          combinedData['profiles'] = {'username': 'Неизвестный игрок', 'avatar_url': null};
        }

        leaderboard.add(LeaderboardDto.fromJson(combinedData).toEntity());
      }

      // Сортируем: сначала по шагам (по возрастанию), потом по времени (по возрастанию)
      leaderboard.sort((a, b) {
        if (a.userSteps != b.userSteps) {
          return a.userSteps.compareTo(b.userSteps);
        }
        return a.gameTime.compareTo(b.gameTime);
      });

      // Ограничиваем 100 записями
      return leaderboard.take(100);
    } catch (e) {
      throw Exception('Ошибка при загрузке таблицы лидеров: $e');
    }
  }

  @override
  Future<Iterable<LeaderboardEntity>> fetchLevelLeaderboard(String levelId) async {
    await _initPrefs();

    try {
      final entries = _getAllLeaderboardEntries();

      // Фильтруем записи по levelId
      final List<LeaderboardEntity> levelLeaderboard = [];

      for (final entry in entries.values) {
        final entryData = entry as Map<String, dynamic>;

        if (entryData['levelId'] == levelId) {
          // Получаем информацию о пользователе
          final userId = entryData['userId'];
          final userProfile = await _getUserProfile(userId);

          // Создаем объединенные данные
          final combinedData = Map<String, dynamic>.from(entryData);
          if (userProfile != null) {
            combinedData['profiles'] = userProfile['profiles'];
          } else {
            combinedData['profiles'] = {'username': 'Неизвестный игрок', 'avatar_url': null};
          }

          levelLeaderboard.add(LeaderboardDto.fromJson(combinedData).toEntity());
        }
      }

      // Сортируем: сначала по шагам, потом по времени
      levelLeaderboard.sort((a, b) {
        if (a.userSteps != b.userSteps) {
          return a.userSteps.compareTo(b.userSteps);
        }
        return a.gameTime.compareTo(b.gameTime);
      });

      // Ограничиваем 50 записями
      return levelLeaderboard.take(50);
    } catch (e) {
      throw Exception('Ошибка при загрузке лидерборда уровня: $e');
    }
  }

  @override
  Future<void> submitGameResult({required String levelId, required int userSteps, required int gameTime, required DateTime startGame, required DateTime endGame, String? devicePlatform}) async {
    await _initPrefs();

    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        throw Exception('Пользователь не авторизован');
      }

      final entries = _getAllLeaderboardEntries();

      // Ищем существующую запись для этого пользователя и уровня
      String? existingEntryId;
      Map<String, dynamic>? existingEntry;

      for (final entry in entries.entries) {
        final entryData = entry.value as Map<String, dynamic>;
        if (entryData['userId'] == userId && entryData['levelId'] == levelId) {
          existingEntryId = entry.key;
          existingEntry = entryData;
          break;
        }
      }

      final now = DateTime.now();

      if (existingEntry != null && existingEntryId != null) {
        // Обновляем только если новый результат лучше
        final existingSteps = existingEntry['user_steps'] as int;
        final existingTime = existingEntry['game_time'] as int;

        final isBetterResult = userSteps < existingSteps || (userSteps == existingSteps && gameTime < existingTime);

        if (isBetterResult) {
          entries[existingEntryId] = {
            ...existingEntry,
            'user_steps': userSteps,
            'game_time': gameTime,
            'start_game': startGame.toIso8601String(),
            'end_game': endGame.toIso8601String(),
            'device_platform': devicePlatform,
            'updated_at': now.toIso8601String(),
          };

          await _saveAllLeaderboardEntries(entries);
        }
      } else {
        // Создаем новую запись
        final entryId = _generateEntryId();

        entries[entryId] = {
          'id': entryId,
          'levelId': levelId,
          'userId': userId,
          'user_steps': userSteps,
          'game_time': gameTime,
          'start_game': startGame.toIso8601String(),
          'end_game': endGame.toIso8601String(),
          'device_platform': devicePlatform,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };

        await _saveAllLeaderboardEntries(entries);
      }
    } catch (e) {
      throw Exception('Ошибка при сохранении результата: $e');
    }
  }

  @override
  Future<LeaderboardEntity?> getUserBestScore(String levelId) async {
    await _initPrefs();

    try {
      final userId = await _getCurrentUserId();
      if (userId == null) return null;

      final entries = _getAllLeaderboardEntries();

      // Ищем запись для этого пользователя и уровня
      for (final entry in entries.values) {
        final entryData = entry as Map<String, dynamic>;
        if (entryData['userId'] == userId && entryData['levelId'] == levelId) {
          // Получаем информацию о пользователе
          final userProfile = await _getUserProfile(userId);

          // Создаем объединенные данные
          final combinedData = Map<String, dynamic>.from(entryData);
          if (userProfile != null) {
            combinedData['profiles'] = userProfile['profiles'];
          } else {
            combinedData['profiles'] = {'username': 'Неизвестный игрок', 'avatar_url': null};
          }

          return LeaderboardDto.fromJson(combinedData).toEntity();
        }
      }

      return null;
    } catch (e) {
      throw Exception('Ошибка при получении лучшего результата: $e');
    }
  }

  /// Метод для добавления тестовых данных (для демонстрации)
  Future<void> addMockData() async {
    await _initPrefs();

    final entries = _getAllLeaderboardEntries();
    final now = DateTime.now();
    final random = Random();

    // Создаем несколько тестовых записей
    for (int i = 0; i < 20; i++) {
      final entryId = _generateEntryId();
      final userId = 'mock_user_${i % 5}';
      final levelId = 'level_${(i % 3) + 1}';

      entries[entryId] = {
        'id': entryId,
        'levelId': levelId,
        'userId': userId,
        'user_steps': 50 + random.nextInt(100),
        'game_time': 30 + random.nextInt(120),
        'start_game': now.subtract(Duration(minutes: 30 + i)).toIso8601String(),
        'end_game': now.subtract(Duration(minutes: i)).toIso8601String(),
        'device_platform': i % 2 == 0 ? 'Android' : 'iOS',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };
    }

    await _saveAllLeaderboardEntries(entries);
  }

  /// Метод для очистки всех данных лидерборда
  Future<void> clearAllData() async {
    await _initPrefs();
    await _prefs.remove(_kLeaderboardData);
    await _prefs.remove(_kLeaderboardCounter);
  }

  /// Метод для получения статистики
  Future<Map<String, int>> getStatistics() async {
    await _initPrefs();

    final entries = _getAllLeaderboardEntries();
    final uniqueUsers = <String>{};
    final levels = <String, int>{};

    for (final entry in entries.values) {
      final entryData = entry as Map<String, dynamic>;
      uniqueUsers.add(entryData['userId']);

      final levelId = entryData['levelId'];
      levels[levelId] = (levels[levelId] ?? 0) + 1;
    }

    return {'total_entries': entries.length, 'unique_users': uniqueUsers.length, 'levels_count': levels.length};
  }
}
