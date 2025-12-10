import 'leaderboard_entity.dart';

///  Интерфейс репозитория для
///  работы с таблицей лидеров
abstract interface class ILeaderboardRepository {
  /// Получение таблицы лидеров.
  Future<Iterable<LeaderboardEntity>> fetchLeaderboard();

  /// Отправка результата игры
  Future<void> submitGameResult({required String levelId, required int userSteps, required int gameTime, required DateTime startGame, required DateTime endGame, String? devicePlatform});

  /// Получение лидерборда для конкретного уровня
  Future<Iterable<LeaderboardEntity>> fetchLevelLeaderboard(String levelId);

  /// Получение лучшего результата пользователя на уровне
  Future<LeaderboardEntity?> getUserBestScore(String levelId);
}
