import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/i_leaderboard_repository.dart';
import '../domain/leaderboard_entity.dart';
import 'leaderboard_dto.dart';

///  Реализация репозитория для таблицы лидеров с использованием Supabase
final class LeaderboardRepository implements ILeaderboardRepository {
  final SupabaseClient supabase;

  LeaderboardRepository({required this.supabase});

  @override
  Future<Iterable<LeaderboardEntity>> fetchLeaderboard() async {
    try {
      // Получаем все записи лидерборда с данными профилей
      final response = await supabase
          .from('leaderboard')
          .select('''
            *,
            profiles (
              username,
              avatar_url
            )
          ''')
          .order('user_steps', ascending: true)
          .order('game_time', ascending: true)
          .limit(100);

      // Преобразуем данные в сущности
      return (response as List).map((item) => LeaderboardDto.fromJson(item).toEntity()).toList();
    } catch (e) {
      throw Exception('Ошибка при загрузке таблицы лидеров: $e');
    }
  }

  @override
  Future<Iterable<LeaderboardEntity>> fetchLevelLeaderboard(String levelId) async {
    try {
      // Получаем записи лидерборда для конкретного уровня
      final response = await supabase
          .from('leaderboard')
          .select('''
            *,
            profiles (
              username,
              avatar_url
            )
          ''')
          .eq('levelId', levelId)
          .order('user_steps', ascending: true)
          .order('game_time', ascending: true)
          .limit(50);

      return (response as List).map((item) => LeaderboardDto.fromJson(item).toEntity()).toList();
    } catch (e) {
      throw Exception('Ошибка при загрузке лидерборда уровня: $e');
    }
  }

  @override
  Future<void> submitGameResult({required String levelId, required int userSteps, required int gameTime, required DateTime startGame, required DateTime endGame, String? devicePlatform}) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Пользователь не авторизован');
      }

      // Проверяем существующий результат
      final existingResult = await supabase.from('Leaderboard').select().eq('levelId', levelId).eq('userId', userId).maybeSingle();

      if (existingResult != null) {
        // Обновляем только если новый результат лучше
        if (userSteps < existingResult['user_steps'] || (userSteps == existingResult['user_steps'] && gameTime < existingResult['game_time'])) {
          await supabase
              .from('Leaderboard')
              .update({
                'user_steps': userSteps,
                'game_time': gameTime,
                'start_game': startGame.toIso8601String(),
                'end_game': endGame.toIso8601String(),
                'device_platform': devicePlatform,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', existingResult['id']);
        }
      } else {
        // Создаем новую запись
        await supabase.from('Leaderboard').insert({
          'levelId': levelId,
          'userId': userId,
          'user_steps': userSteps,
          'game_time': gameTime,
          'start_game': startGame.toIso8601String(),
          'end_game': endGame.toIso8601String(),
          'device_platform': devicePlatform,
        });
      }
    } catch (e) {
      throw Exception('Ошибка при сохранении результата: $e');
    }
  }

  @override
  Future<LeaderboardEntity?> getUserBestScore(String levelId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await supabase
          .from('leaderboard')
          .select('''
            *,
            profiles (
              username,
              avatar_url
            )
          ''')
          .eq('levelId', levelId)
          .eq('userId', userId)
          .maybeSingle();

      if (response == null) return null;

      return LeaderboardDto.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Ошибка при получении лучшего результата: $e');
    }
  }
}
