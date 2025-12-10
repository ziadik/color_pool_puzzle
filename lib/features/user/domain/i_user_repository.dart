import 'user_entity.dart';

/// Интерфейс репозитория пользователя
abstract interface class IUserRepository {
  /// Создание или получение пользователя через Supabase Auth
  Future<UserEntity> signUpOrSignIn(String email, String password, String username);

  /// Вход через анонимный аккаунт
  Future<UserEntity> signInAnonymously(String username);

  /// Вход с существующими учетными данными
  Future<UserEntity> signIn(String email, String password);

  /// Выход из системы
  Future<void> signOut();

  /// Получение текущего пользователя
  Future<UserEntity?> getCurrentUser();

  /// Обновление профиля пользователя
  Future<UserEntity> updateProfile({String? username, String? avatarUrl});

  /// Сохранение лучшего результата
  Future<UserEntity> setBestScore(int score);
}
