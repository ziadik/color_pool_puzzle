import 'package:flutter/foundation.dart';

import '../domain/leaderboard_entity.dart';

/// Data Transfer Object для лучших результатов
@immutable
final class LeaderboardDto {
  final String id;
  final String userId;
  final String username;
  final String? avatarUrl;
  final int userSteps;
  final int gameTime;
  final String? devicePlatform;
  final DateTime startGame;
  final DateTime endGame;
  final String levelId;

  const LeaderboardDto({
    required this.id,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.userSteps,
    required this.gameTime,
    this.devicePlatform,
    required this.startGame,
    required this.endGame,
    required this.levelId,
  });

  /// Создание объекта из JSON
  /// [json] - JSON-объект, полученный из Supabase
  factory LeaderboardDto.fromJson(Map<String, dynamic> json) {
    return LeaderboardDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: (json['Profiles'] as Map<String, dynamic>)['username'] as String,
      avatarUrl: (json['Profiles'] as Map<String, dynamic>)['avatar_url'] as String?,
      userSteps: json['user_steps'] as int,
      gameTime: json['game_time'] as int,
      devicePlatform: json['device_platform'] as String?,
      startGame: DateTime.parse(json['start_game'] as String),
      endGame: DateTime.parse(json['end_game'] as String),
      levelId: json['levelId'] as String,
    );
  }

  /// Преобразование DTO в сущность
  /// [LeaderboardEntity] - сущность, которая используется в приложении
  LeaderboardEntity toEntity() {
    return LeaderboardEntity(
      id: id,
      userId: userId,
      username: username,
      avatarUrl: avatarUrl,
      userSteps: userSteps,
      gameTime: gameTime,
      devicePlatform: devicePlatform,
      startGame: startGame,
      endGame: endGame,
      levelId: levelId,
    );
  }
}
