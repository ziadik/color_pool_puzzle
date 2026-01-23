import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/i_user_repository.dart';
import '../domain/user_entity.dart';
import 'user_dto.dart';

/// Репозиторий для работы с пользователем через Supabase
final class UserSupabaseRepository implements IUserRepository {
  final SupabaseClient supabase;

  UserSupabaseRepository({required this.supabase});

  @override
  Future<UserEntity> signUpOrSignIn(String email, String password, String username) async {
    try {
      // Проверяем, существует ли пользователь с таким email
      final existingUsers = await supabase.from('Profiles').select().eq('email', email).maybeSingle();

      if (existingUsers != null) {
        // Пользователь существует - выполняем вход
        final response = await supabase.auth.signInWithPassword(email: email, password: password);

        if (response.user == null) {
          throw Exception('Ошибка входа: пользователь не найден');
        }

        return await _fetchUserProfile(response.user!.id);
      } else {
        // Пользователь не существует - регистрируем
        final response = await supabase.auth.signUp(email: email, password: password, data: {'username': username});

        if (response.user == null) {
          throw Exception('Ошибка регистрации');
        }

        // Создаем профиль в таблице Profiles
        await supabase.from('Profiles').insert({'id': response.user!.id, 'email': email, 'username': username, 'best_score': 0, 'is_anonymous': false});

        return UserDto.fromAuthUser(response.user!.id, email, username).toEntity();
      }
    } catch (e) {
      throw Exception('Ошибка авторизации: $e');
    }
  }

  @override
  Future<UserEntity> signInAnonymously(String username) async {
    try {
      // Создаем анонимного пользователя
      final response = await supabase.auth.signUp(
        email: '${DateTime.now().millisecondsSinceEpoch}@anonymous.game',
        password: 'anonymous_${DateTime.now().millisecondsSinceEpoch}',
        data: {'username': username},
      );

      if (response.user == null) {
        throw Exception('Ошибка создания анонимного пользователя');
      }

      // Создаем профиль анонимного пользователя
      await supabase.from('Profiles').insert({'id': response.user!.id, 'email': '', 'username': username, 'best_score': 0, 'is_anonymous': true});

      return UserDto(id: response.user!.id, email: '', username: username, bestScore: 0, createdAt: DateTime.now(), updatedAt: DateTime.now(), isAnonymous: true).toEntity();
    } catch (e) {
      throw Exception('Ошибка создания анонимного пользователя: $e');
    }
  }

  @override
  Future<UserEntity> signIn(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(email: email, password: password);

      if (response.user == null) {
        throw Exception('Ошибка входа: пользователь не найден');
      }

      return await _fetchUserProfile(response.user!.id);
    } catch (e) {
      throw Exception('Ошибка входа: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception('Ошибка выхода: $e');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) return null;

      return await _fetchUserProfile(currentUser.id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserEntity> updateProfile({String? username, String? avatarUrl}) async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }

      final updates = <String, dynamic>{'updated_at': DateTime.now().toIso8601String()};

      if (username != null) updates['username'] = username;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      await supabase.from('Profiles').update(updates).eq('id', currentUser.id);

      return await _fetchUserProfile(currentUser.id);
    } catch (e) {
      throw Exception('Ошибка обновления профиля: $e');
    }
  }

  @override
  Future<UserEntity> setBestScore(int score) async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }

      // Получаем текущий лучший результат
      final currentProfile = await supabase.from('Profiles').select('best_score').eq('id', currentUser.id).single();

      final currentBestScore = currentProfile['best_score'] as int? ?? 0;

      // Обновляем только если новый результат лучше
      if (score > currentBestScore) {
        await supabase.from('Profiles').update({'best_score': score, 'updated_at': DateTime.now().toIso8601String()}).eq('id', currentUser.id);
      }

      return await _fetchUserProfile(currentUser.id);
    } catch (e) {
      throw Exception('Ошибка обновления результата: $e');
    }
  }

  /// Вспомогательный метод для получения профиля пользователя
  Future<UserEntity> _fetchUserProfile(String userId) async {
    try {
      final response = await supabase.from('Profiles').select().eq('id', userId).single();

      return UserDto.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Ошибка получения профиля: $e');
    }
  }
}
