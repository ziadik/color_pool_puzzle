import 'package:flutter/foundation.dart';

import '../i_leaderboard_repository.dart';
import '../leaderboard_entity.dart';
import 'leaderboard_state.dart';

/// Класс, использующий паттерн Cubit для управления
/// состоянием таблицы лидеров. Сами состояния таблицы
/// хранится в ValueNotifier
class LeaderboardCubit {
  final ILeaderboardRepository repository;
  final String? levelId;

  /// Состояние таблицы лидеров
  /// Используем ValueNotifier для отслеживания состояния
  final ValueNotifier<LeaderboardState> stateNotifier = ValueNotifier(LeaderboardInitState());

  LeaderboardCubit({required this.repository, this.levelId});

  /// Установка текущего состояния
  void emit(LeaderboardState cubitState) {
    stateNotifier.value = cubitState;
  }

  /// Получение таблицы лидеров
  Future<void> fetchLeaderboard() async {
    if (stateNotifier.value is LeaderboardLoading) {
      return;
    }

    try {
      emit(const LeaderboardLoading());

      final Iterable<LeaderboardEntity> leaderboard;

      if (levelId != null) {
        // Загружаем лидерборд для конкретного уровня
        leaderboard = await repository.fetchLevelLeaderboard(levelId!);
      } else {
        // Загружаем общий лидерборд
        leaderboard = await repository.fetchLeaderboard();
      }

      emit(LeaderboardSuccessState(leaderboard.toList()));
    } on Object catch (e, stackTrace) {
      emit(LeaderboardErrorState('Ошибка загрузки таблицы лидеров', error: e, stackTrace: stackTrace));
    }
  }

  /// Отправка результата игры
  Future<void> submitGameResult({required String levelId, required int userSteps, required int gameTime, required DateTime startGame, required DateTime endGame, String? devicePlatform}) async {
    try {
      await repository.submitGameResult(levelId: levelId, userSteps: userSteps, gameTime: gameTime, startGame: startGame, endGame: endGame, devicePlatform: devicePlatform);

      // Обновляем лидерборд после отправки результата
      if (this.levelId == levelId || this.levelId == null) {
        fetchLeaderboard();
      }
    } catch (e) {
      // Можно добавить обработку ошибки отправки
      print('Ошибка отправки результата: $e');
    }
  }

  /// Освобождение ресурсов
  /// Закрываем ValueNotifier, чтобы избежать утечек памяти
  void dispose() {
    stateNotifier.dispose();
  }
}
