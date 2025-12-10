import 'package:flutter/foundation.dart';
import '../i_user_repository.dart';
import 'user_state.dart';

/// Класс для управления состоянием пользователя
/// и взаимодействия с Supabase
class UserCubit {
  final IUserRepository repository;

  UserCubit({required this.repository});

  final ValueNotifier<UserState> stateNotifier = ValueNotifier(UserInitState());

  /// Регистрация или вход по email
  Future<void> signUpOrSignIn(String email, String password, String username) async {
    if (stateNotifier.value is UserLoadingState) return;

    try {
      emit(UserLoadingState());
      final entity = await repository.signUpOrSignIn(email, password, username);
      emit(UserSuccessState(entity));
    } on Object catch (error, stackTrace) {
      emit(UserErrorState('Ошибка авторизации', error: error, stackTrace: stackTrace));
    }
  }

  /// Вход через анонимный аккаунт
  Future<void> signInAnonymously(String username) async {
    if (stateNotifier.value is UserLoadingState) return;

    try {
      emit(UserLoadingState());
      final entity = await repository.signInAnonymously(username);
      emit(UserSuccessState(entity));
    } on Object catch (error, stackTrace) {
      emit(UserErrorState('Ошибка создания анонимного пользователя', error: error, stackTrace: stackTrace));
    }
  }

  /// Вход с существующими учетными данными
  Future<void> signIn(String email, String password) async {
    if (stateNotifier.value is UserLoadingState) return;

    try {
      emit(UserLoadingState());
      final entity = await repository.signIn(email, password);
      emit(UserSuccessState(entity));
    } on Object catch (error, stackTrace) {
      emit(UserErrorState('Ошибка входа', error: error, stackTrace: stackTrace));
    }
  }

  /// Обновление лучшего результата
  Future<void> setBestScore(int score) async {
    if (stateNotifier.value is UserLoadingState) return;

    try {
      emit(UserLoadingState());
      final entity = await repository.setBestScore(score);
      emit(UserSuccessState(entity));
    } on Object catch (error, stackTrace) {
      emit(UserErrorState('Ошибка обновления результата', error: error, stackTrace: stackTrace));
    }
  }

  /// Обновление профиля
  Future<void> updateProfile({String? username, String? avatarUrl}) async {
    if (stateNotifier.value is UserLoadingState) return;

    try {
      emit(UserLoadingState());
      final entity = await repository.updateProfile(username: username, avatarUrl: avatarUrl);
      emit(UserSuccessState(entity));
    } on Object catch (error, stackTrace) {
      emit(UserErrorState('Ошибка обновления профиля', error: error, stackTrace: stackTrace));
    }
  }

  /// Выход из аккаунта
  Future<void> signOut() async {
    try {
      emit(UserLoadingState());
      await repository.signOut();
      emit(UserInitState());
    } on Object catch (error, stackTrace) {
      emit(UserErrorState('Ошибка выхода', error: error, stackTrace: stackTrace));
    }
  }

  /// Восстановление текущего пользователя
  Future<void> restoreUser() async {
    try {
      emit(UserLoadingState());
      final entity = await repository.getCurrentUser();
      if (entity != null) {
        emit(UserSuccessState(entity));
      } else {
        emit(UserInitState());
      }
    } on Object catch (error, stackTrace) {
      emit(UserErrorState('Ошибка восстановления пользователя', error: error, stackTrace: stackTrace));
    }
  }

  /// Установка текущего состояния
  void emit(UserState cubitState) {
    stateNotifier.value = cubitState;
  }
}
