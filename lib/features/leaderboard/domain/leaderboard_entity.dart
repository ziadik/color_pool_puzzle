import 'package:flutter/foundation.dart';

import '../../../app/equals_mixin.dart';

/// Сущность элемента таблицы лидеров
@immutable
class LeaderboardEntity with EqualsMixin {
  /// Идентификатор записи
  final String id;

  /// Идентификатор пользователя
  final String userId;

  /// Имя пользователя
  final String username;

  /// Аватар пользователя
  final String? avatarUrl;

  /// Лучший счет пользователя (шаги)
  final int userSteps;

  /// Время прохождения (миллисекунды)
  final int gameTime;

  /// Форматированное время для отображения
  String get formattedTime {
    final seconds = gameTime ~/ 1000;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Платформа устройства
  final String? devicePlatform;

  /// Дата начала игры
  final DateTime startGame;

  /// Дата окончания игры
  final DateTime endGame;

  /// Идентификатор уровня
  final String levelId;

  const LeaderboardEntity({
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

  /// Переопределяем поля для сравнения объектов
  /// Используем для сравнения объектов в EqualsMixin
  @override
  List<Object?> get fields => [id, userId, username, userSteps, gameTime];
}
