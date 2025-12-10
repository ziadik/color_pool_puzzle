import 'package:flutter/foundation.dart';

import '../../../app/equals_mixin.dart';

/// Сущность пользователя для Supabase
@immutable
class UserEntity with EqualsMixin {
  /// Идентификатор пользователя (UUID из Supabase Auth)
  final String id;

  /// Email пользователя
  final String email;

  /// Имя пользователя
  final String username;

  /// URL аватара пользователя
  final String? avatarUrl;

  /// Лучший счет пользователя
  final int bestScore;

  /// Дата создания профиля
  final DateTime createdAt;

  /// Дата последнего обновления профиля
  final DateTime updatedAt;

  /// Является ли пользователь анонимным
  final bool isAnonymous;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    required this.bestScore,
    required this.createdAt,
    required this.updatedAt,
    required this.isAnonymous,
  });

  @override
  List<Object?> get fields => [id, email, username, bestScore];
}
