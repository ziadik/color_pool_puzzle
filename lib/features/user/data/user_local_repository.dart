import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../domain/i_user_repository.dart';
import '../domain/user_entity.dart';
import 'user_dto.dart';

/// Ключи для хранения данных в SharedPreferences
const _kCurrentUserId = 'current_user_id';
const _kUsersData = 'users_data';
const _kAnonymousCounter = 'anonymous_counter';

/// Репозиторий для работы с пользователем в локальном хранилище
final class UserLocalRepository implements IUserRepository {
  late SharedPreferences _prefs;

  UserLocalRepository() {
    _initPrefs();
  }

  /// Инициализация SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Получение списка всех пользователей из хранилища
  Map<String, dynamic> _getAllUsers() {
    final usersJson = _prefs.getString(_kUsersData);
    if (usersJson == null || usersJson.isEmpty) {
      return {};
    }
    return Map<String, dynamic>.from(json.decode(usersJson));
  }

  /// Сохранение списка пользователей в хранилище
  Future<void> _saveAllUsers(Map<String, dynamic> users) async {
    await _prefs.setString(_kUsersData, json.encode(users));
  }

  /// Генерация уникального ID для пользователя
  String _generateUserId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Генерация уникального email для анонимного пользователя
  String _generateAnonymousEmail() {
    final counter = _prefs.getInt(_kAnonymousCounter) ?? 0;
    _prefs.setInt(_kAnonymousCounter, counter + 1);
    return 'anonymous_$counter@local.game';
  }

  @override
  Future<UserEntity> signUpOrSignIn(String email, String password, String username) async {
    await _initPrefs();

    try {
      final users = _getAllUsers();

      // Поиск пользователя по email
      String? userId;
      for (final entry in users.entries) {
        final userData = entry.value as Map<String, dynamic>;
        if (userData['email'] == email) {
          userId = entry.key;
          break;
        }
      }

      if (userId != null) {
        // Пользователь существует - выполняем вход
        // Проверяем пароль (в реальном приложении нужно хеширование)
        final userData = users[userId] as Map<String, dynamic>;
        if (userData['password'] != password) {
          throw Exception('Неверный пароль');
        }

        // Сохраняем ID текущего пользователя
        await _prefs.setString(_kCurrentUserId, userId);

        return UserDto.fromJson(userData).toEntity();
      } else {
        // Пользователь не существует - регистрируем
        final userId = _generateUserId();
        final now = DateTime.now();

        final userData = {
          'id': userId,
          'email': email,
          'username': username,
          'password': password, // Внимание: в реальном приложении пароли нужно хешировать!
          'best_score': 0,
          'is_anonymous': false,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };

        // Сохраняем пользователя
        users[userId] = userData;
        await _saveAllUsers(users);

        // Сохраняем ID текущего пользователя
        await _prefs.setString(_kCurrentUserId, userId);

        return UserDto.fromJson(userData).toEntity();
      }
    } catch (e) {
      throw Exception('Ошибка авторизации: $e');
    }
  }

  @override
  Future<UserEntity> signInAnonymously(String username) async {
    await _initPrefs();

    try {
      final userId = _generateUserId();
      final now = DateTime.now();

      final userData = {
        'id': userId,
        'email': _generateAnonymousEmail(),
        'username': username,
        'password': '', // Анонимные пользователи без пароля
        'best_score': 0,
        'is_anonymous': true,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      // Сохраняем пользователя
      final users = _getAllUsers();
      users[userId] = userData;
      await _saveAllUsers(users);

      // Сохраняем ID текущего пользователя
      await _prefs.setString(_kCurrentUserId, userId);

      return UserDto.fromJson(userData).toEntity();
    } catch (e) {
      throw Exception('Ошибка создания анонимного пользователя: $e');
    }
  }

  @override
  Future<UserEntity> signIn(String email, String password) async {
    await _initPrefs();

    try {
      final users = _getAllUsers();

      // Поиск пользователя по email
      String? userId;
      Map<String, dynamic>? userData;

      for (final entry in users.entries) {
        final data = entry.value as Map<String, dynamic>;
        if (data['email'] == email) {
          userId = entry.key;
          userData = data;
          break;
        }
      }

      if (userId == null || userData == null) {
        throw Exception('Пользователь не найден');
      }

      // Проверка пароля
      if (userData['password'] != password) {
        throw Exception('Неверный пароль');
      }

      // Сохраняем ID текущего пользователя
      await _prefs.setString(_kCurrentUserId, userId);

      return UserDto.fromJson(userData).toEntity();
    } catch (e) {
      throw Exception('Ошибка входа: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _initPrefs();

    try {
      await _prefs.remove(_kCurrentUserId);
    } catch (e) {
      throw Exception('Ошибка выхода: $e');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    await _initPrefs();

    try {
      final userId = _prefs.getString(_kCurrentUserId);
      if (userId == null) return null;

      final users = _getAllUsers();
      final userData = users[userId] as Map<String, dynamic>?;

      if (userData == null) {
        // Удаляем несуществующего пользователя из текущей сессии
        await _prefs.remove(_kCurrentUserId);
        return null;
      }

      return UserDto.fromJson(userData).toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserEntity> updateProfile({String? username, String? avatarUrl}) async {
    await _initPrefs();

    try {
      final userId = _prefs.getString(_kCurrentUserId);
      if (userId == null) {
        throw Exception('Пользователь не авторизован');
      }

      final users = _getAllUsers();
      final userData = users[userId] as Map<String, dynamic>?;

      if (userData == null) {
        throw Exception('Пользователь не найден');
      }

      // Обновляем данные
      final updatedData = Map<String, dynamic>.from(userData);
      if (username != null) updatedData['username'] = username;
      if (avatarUrl != null) updatedData['avatar_url'] = avatarUrl;
      updatedData['updated_at'] = DateTime.now().toIso8601String();

      // Сохраняем обновленные данные
      users[userId] = updatedData;
      await _saveAllUsers(users);

      return UserDto.fromJson(updatedData).toEntity();
    } catch (e) {
      throw Exception('Ошибка обновления профиля: $e');
    }
  }

  @override
  Future<UserEntity> setBestScore(int score) async {
    await _initPrefs();

    try {
      final userId = _prefs.getString(_kCurrentUserId);
      if (userId == null) {
        throw Exception('Пользователь не авторизован');
      }

      final users = _getAllUsers();
      final userData = users[userId] as Map<String, dynamic>?;

      if (userData == null) {
        throw Exception('Пользователь не найден');
      }

      // Получаем текущий лучший результат
      final currentBestScore = userData['best_score'] as int? ?? 0;

      // Обновляем только если новый результат лучше
      if (score > currentBestScore) {
        final updatedData = Map<String, dynamic>.from(userData);
        updatedData['best_score'] = score;
        updatedData['updated_at'] = DateTime.now().toIso8601String();

        // Сохраняем обновленные данные
        users[userId] = updatedData;
        await _saveAllUsers(users);

        return UserDto.fromJson(updatedData).toEntity();
      }

      return UserDto.fromJson(userData).toEntity();
    } catch (e) {
      throw Exception('Ошибка обновления результата: $e');
    }
  }

  /// Метод для очистки всех пользовательских данных (для тестирования)
  Future<void> clearAllData() async {
    await _initPrefs();
    await _prefs.clear();
  }

  /// Метод для получения всех пользователей (для админских целей)
  Future<List<UserEntity>> getAllUsers() async {
    await _initPrefs();

    final users = _getAllUsers();
    return users.values.map((data) => UserDto.fromJson(data as Map<String, dynamic>).toEntity()).toList();
  }
}
