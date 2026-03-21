import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/settings_manager.dart';
import '../services/vibration_manager.dart';
import '../utils/localization.dart';
import '../utils/app_colors.dart';
import 'leaderboard_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final VibrationManager _vibrationManager = VibrationManager();

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.getString('settings')),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSection(
            title: Localization.getString('language'),
            child: ListTile(
              title: Text(Localization.getString('language')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLanguageDialog(settings),
            ),
          ),
          _buildSection(
            title: Localization.getString('theme'),
            child: ListTile(
              title: Text(Localization.getString('theme')),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getThemeName(settings.currentTheme)),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () => _showThemeDialog(settings),
            ),
          ),
          _buildSection(
            title: Localization.getString('sound'),
            child: SwitchListTile(
              title: Text(Localization.getString('soundOn')),
              value: settings.soundEnabled,
              onChanged: (value) => settings.soundEnabled = value,
              activeColor: AppColors.secondaryColor,
            ),
          ),
          _buildSection(
            title: Localization.getString('vibration'),
            children: [
              SwitchListTile(
                title: Text(Localization.getString('vibrationEnabled')),
                value: settings.vibrationEnabled,
                onChanged: (value) {
                  settings.vibrationEnabled = value;
                  if (value) {
                    _vibrationManager.preview(settings);
                  }
                },
                activeColor: AppColors.secondaryColor,
              ),
              ListTile(
                title: Text(Localization.getString('vibrationStrength')),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(settings.vibrationStrengthDescription()),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                enabled: settings.vibrationEnabled,
                onTap: settings.vibrationEnabled ? () => _showStrengthDialog(settings) : null,
              ),
            ],
          ),
          _buildSection(
            title: Localization.getString('progress'),
            child: ListTile(
              title: Text(Localization.getString('resetResults')),
              textColor: Colors.red,
              onTap: () => _showResetDialog(settings),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    Widget? child,
    List<Widget>? children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        if (child != null) child,
        if (children != null) ...children,
        const Divider(height: 1),
      ],
    );
  }

  void _showLanguageDialog(SettingsManager settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Localization.getString('selectLanguage')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: Localization.availableLanguages.map((lang) {
              // lang is Map<String, String>, so we access by keys
              final code = lang['code']!;
              final displayName = lang['displayName']!;
              final isSelected = settings.currentLocale.languageCode == code;

              return ListTile(
                title: Text(displayName),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () {
                  settings.currentLocale = Locale(code);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Localization.getString('cancel')),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(SettingsManager settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Localization.getString('theme')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(Localization.getString('systemTheme')),
              trailing: settings.currentTheme == ThemeMode.system ? const Icon(Icons.check) : null,
              onTap: () {
                settings.currentTheme = ThemeMode.system;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(Localization.getString('lightTheme')),
              trailing: settings.currentTheme == ThemeMode.light ? const Icon(Icons.check) : null,
              onTap: () {
                settings.currentTheme = ThemeMode.light;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(Localization.getString('darkTheme')),
              trailing: settings.currentTheme == ThemeMode.dark ? const Icon(Icons.check) : null,
              onTap: () {
                settings.currentTheme = ThemeMode.dark;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStrengthDialog(SettingsManager settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Localization.getString('vibrationStrength')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(Localization.getString('vibrationLight')),
              trailing: settings.vibrationStrength == 0 ? const Icon(Icons.check) : null,
              onTap: () {
                settings.vibrationStrength = 0;
                _vibrationManager.preview(settings);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(Localization.getString('vibrationMedium')),
              trailing: settings.vibrationStrength == 1 ? const Icon(Icons.check) : null,
              onTap: () {
                settings.vibrationStrength = 1;
                _vibrationManager.preview(settings);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(Localization.getString('vibrationStrong')),
              trailing: settings.vibrationStrength == 2 ? const Icon(Icons.check) : null,
              onTap: () {
                settings.vibrationStrength = 2;
                _vibrationManager.preview(settings);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(SettingsManager settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Localization.getString('resetConfirmation')),
        content: Text(Localization.getString('resetWarning')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Localization.getString('cancel')),
          ),
          TextButton(
            onPressed: () {
              settings.resetProgress();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(Localization.getString('reset')),
          ),
        ],
      ),
    );
  }

  String _getThemeName(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.system:
        return Localization.getString('systemTheme');
      case ThemeMode.light:
        return Localization.getString('lightTheme');
      case ThemeMode.dark:
        return Localization.getString('darkTheme');
    }
  }
}
