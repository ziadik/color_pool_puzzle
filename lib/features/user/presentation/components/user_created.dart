import 'package:flutter/material.dart';

import '../../../../app/ext/context_ext.dart';
import '../../../../main.dart';
import '../../domain/user_entity.dart';

/// Компонент для отображения данных пользователя
/// при успешной авторизации
class UserCreated extends StatelessWidget {
  const UserCreated({super.key, required this.userEntity});

  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Аватар пользователя
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: userEntity.avatarUrl != null ? NetworkImage(userEntity.avatarUrl!) : null,
              child: userEntity.avatarUrl == null
                  ? Text(
                      userEntity.username[0].toUpperCase(),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                    )
                  : null,
            ),

            const SizedBox(height: 16),

            // Имя пользователя
            Text(userEntity.username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            if (userEntity.email.isNotEmpty) ...[const SizedBox(height: 8), Text(userEntity.email, style: const TextStyle(fontSize: 16, color: Colors.grey))],

            const SizedBox(height: 16),

            // Статистика
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Ваша статистика', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('Лучший счет', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                            const SizedBox(height: 4),
                            Text(
                              '${userEntity.bestScore}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Статус', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                            const SizedBox(height: 4),
                            Chip(label: Text(userEntity.isAnonymous ? 'Анонимный' : 'Зарегистрированный'), backgroundColor: userEntity.isAnonymous ? Colors.orange.shade100 : Colors.green.shade100),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Кнопки действий
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, GameRouter.gameRoute);
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  child: const Text('Начать игру'),
                ),

                const SizedBox(height: 12),

                OutlinedButton(
                  onPressed: () {
                    context.di.userCubit.signOut();
                  },
                  style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  child: const Text('Выйти из аккаунта'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
