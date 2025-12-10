import 'package:flutter/material.dart';

import '../../../../main.dart';

/// Компонент для отображения ошибки
class UserError extends StatelessWidget {
  const UserError({super.key, required this.message, required this.onRetry});

  /// Сообщение об ошибке
  final String message;

  /// Коллбэк для повторной попытки
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),

            const SizedBox(height: 16),

            Text('Ошибка', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.red)),

            const SizedBox(height: 8),

            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: onRetry, child: const Text('Попробовать снова')),

                const SizedBox(width: 16),

                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, GameRouter.initialRoute);
                  },
                  child: const Text('В главное меню'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
