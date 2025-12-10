import '../domain/user_entity.dart';

/// Data Transfer Object для парсинга данных пользователя из Supabase
final class UserDto {
  /// Идентификатор пользователя (UUID)
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

  const UserDto({required this.id, required this.email, required this.username, this.avatarUrl, required this.bestScore, required this.createdAt, required this.updatedAt, required this.isAnonymous});

  /// Преобразование JSON из Supabase в DTO
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      bestScore: json['best_score'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isAnonymous: json['is_anonymous'] as bool? ?? false,
    );
  }

  /// Преобразование DTO в JSON для Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
      'best_score': bestScore,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_anonymous': isAnonymous,
    };
  }

  /// Преобразование DTO в сущность [UserEntity]
  UserEntity toEntity() {
    return UserEntity(id: id, email: email, username: username, avatarUrl: avatarUrl, bestScore: bestScore, createdAt: createdAt, updatedAt: updatedAt, isAnonymous: isAnonymous);
  }

  /// Создание DTO из данных Auth пользователя
  factory UserDto.fromAuthUser(String id, String email, String username) {
    final now = DateTime.now();
    return UserDto(id: id, email: email, username: username, bestScore: 0, createdAt: now, updatedAt: now, isAnonymous: false);
  }
}
