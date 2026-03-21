import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/settings_manager.dart';
import '../utils/localization.dart';
import '../utils/app_colors.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsManager>(context);
    final records = settings.records.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
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
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(
                      Icons.emoji_events,
                      color: Color(0xFFFFD700),
                      size: 32,
                    ),
                    title: Text(
                      Localization.getString('level', entry.key + 1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${Localization.getString('moves', record.moves)} • ${_formatDate(record.date)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
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