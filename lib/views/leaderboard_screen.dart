import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/settings_manager.dart';
import '../controllers/level_manager.dart';
import '../utils/localization.dart';
import '../utils/app_colors.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsManager>(context);
    final levelManager = Provider.of<LevelManager>(context, listen: false);
    final records = settings.records.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.getString('leaderboard')),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: records.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Localization.getString('noRecords'),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final entry = records[index];
                final record = entry.value;
                final levelIndex = entry.key;
                final isLevelUnlocked = levelIndex <= settings.maxOpenedLevel;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: InkWell(
                    onTap: isLevelUnlocked
                        ? () {
                            // Устанавливаем выбранный уровень
                            levelManager.currentLevelIndex = levelIndex;
                            // Закрываем leaderboard и возвращаем результат
                            Navigator.pop(context, true);
                          }
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        children: [
                          // Номер уровня
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isLevelUnlocked ? AppColors.secondaryColor.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '${levelIndex + 1}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isLevelUnlocked ? AppColors.secondaryColor : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Информация об уровне
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Localization.getString('level', levelIndex + 1),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isLevelUnlocked ? null : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${Localization.getString('moves', record.moves)} • ${_formatDate(record.date)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isLevelUnlocked ? Colors.grey[600] : Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Иконка действия
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isLevelUnlocked ? AppColors.secondaryColor : Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              isLevelUnlocked ? Icons.play_arrow : Icons.lock,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
