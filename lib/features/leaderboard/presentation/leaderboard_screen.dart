import 'package:flutter/material.dart';

import '../../../app/ext/context_ext.dart';
import '../domain/leaderboard_entity.dart';
import '../domain/state/leaderboard_cubit.dart';
import '../domain/state/leaderboard_state.dart';

/// Экран таблицы лидеров
/// Здесь отображается таблица лидеров
class LeaderboardScreen extends StatefulWidget {
  final String? levelId;

  const LeaderboardScreen({super.key, this.levelId});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  /// Объявляем кубит для работы с таблицей лидеров
  late final LeaderboardCubit leaderboardCubit;

  @override
  void initState() {
    super.initState();
    // Инициализируем кубит
    leaderboardCubit = LeaderboardCubit(repository: context.di.leaderRepository, levelId: widget.levelId)..fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.levelId != null ? 'Лидеры уровня' : 'Таблица лидеров'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              leaderboardCubit.fetchLeaderboard();
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: leaderboardCubit.stateNotifier,
        builder: (context, state, child) => switch (state) {
          LeaderboardInitState() => const Center(child: Text('Загрузка таблицы лидеров...')),
          LeaderboardLoading() => const Center(child: CircularProgressIndicator()),
          LeaderboardSuccessState() => _ListRecords(leaderboard: state.leaderboard, levelId: widget.levelId),
          LeaderboardErrorState() => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ошибка: ${state.message}', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () => leaderboardCubit.fetchLeaderboard(), child: const Text('Повторить')),
              ],
            ),
          ),
        },
      ),
    );
  }

  @override
  void dispose() {
    leaderboardCubit.dispose();
    super.dispose();
  }
}

/// Виджет для отображения списка записей таблицы лидеров
class _ListRecords extends StatelessWidget {
  const _ListRecords({required this.leaderboard, this.levelId});

  final List<LeaderboardEntity> leaderboard;
  final String? levelId;

  @override
  Widget build(BuildContext context) {
    if (leaderboard.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.leaderboard_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(levelId != null ? 'Пока нет результатов на этом уровне' : 'Нет записей в таблице лидеров', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Будьте первым!', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: leaderboard.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = leaderboard[index];
        // final isCurrentUser = context.di.supabaseClient.auth.currentUser?.id == item.userId;
        //TODO: Find local uid user
        final isCurrentUser = true;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: Text(
              '${index + 1}',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          title: Row(
            children: [
              Text(
                item.username,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              if (isCurrentUser) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'Вы',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Шаги: ${item.userSteps}'),
              Text('Время: ${item.formattedTime}'),
              if (item.devicePlatform != null) Text('Платформа: ${item.devicePlatform}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (index < 3) ...[Icon(index == 0 ? Icons.emoji_events : Icons.star, color: index == 0 ? Colors.amber : Colors.grey, size: 24)],
            ],
          ),
        );
      },
    );
  }
}
