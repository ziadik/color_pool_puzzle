import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../controllers/settings_manager.dart';
import '../controllers/level_manager.dart';
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
  String _appVersion = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
      });
    } catch (e) {
      setState(() {
        _appVersion = '1.0.0';
        _buildNumber = '1';
      });
    }
  }

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
            onPressed: () => _openLeaderboard(),
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
              onChanged: (value) {
                settings.soundEnabled = value;
                _applyChanges();
              },
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
                  _applyChanges();
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
                onTap: settings.vibrationEnabled
                    ? () => _showStrengthDialog(settings)
                    : null,
              ),
            ],
          ),
          _buildSection(
            title: Localization.getString('progress'),
            children: [
              ListTile(
                title: Text(Localization.getString('resetResults')),
                textColor: Colors.red,
                onTap: () => _showResetDialog(settings),
              ),
              ListTile(
                title: Text(Localization.getString('unlockAllLevels')),
                textColor: AppColors.secondaryColor,
                onTap: () => _showUnlockAllLevelsDialog(settings),
              ),
            ],
          ),
          _buildDeveloperSection(),
        ],
      ),
    );
  }

  void _showUnlockAllLevelsDialog(SettingsManager settings) {
    final levelManager = Provider.of<LevelManager>(context, listen: false);
    final totalLevels = levelManager.totalLevels;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Localization.getString('unlockAllLevels')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Localization.getString('unlockAllLevelsConfirm')),
            const SizedBox(height: 8),
            Text(
              Localization.getString('unlockAllLevelsWarning'),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Localization.getString('cancel')),
          ),
          TextButton(
            onPressed: () {
              settings.maxOpenedLevel = totalLevels - 1;
              levelManager.maxOpenedLevel = totalLevels - 1;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${Localization.getString('unlockAllLevels')} (${totalLevels} ${Localization.getString('levels')})',
                  ),
                  duration: const Duration(seconds: 2),
                  backgroundColor: AppColors.successColor,
                ),
              );

              Navigator.pop(context);
              _applyChanges();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.secondaryColor,
            ),
            child: Text(Localization.getString('unlockAllLevels')),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            Localization.getString('developer'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline,
                    color: AppColors.secondaryColor),
                title: Text(Localization.getString('developerName')),
                subtitle: const Text('Dmitry Ziadik'),
                onTap: () => _showDeveloperInfo(),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.web, color: AppColors.secondaryColor),
                title: Text(Localization.getString('website')),
                subtitle: const Text('https://ziidik.ru'),
              ),
              const Divider(height: 1),
              ListTile(
                leading:
                    const Icon(Icons.email, color: AppColors.secondaryColor),
                title: Text(Localization.getString('email')),
                subtitle: const Text('dmitry.zyadik@gmail.com'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline,
                    color: AppColors.secondaryColor),
                title: Text(Localization.getString('version')),
                subtitle: Text(
                    '${Localization.getString('version')} $_appVersion${_buildNumber.isNotEmpty ? ' (${Localization.getString('build')} $_buildNumber)' : ''}'),
                onTap: () => _copyVersionToClipboard(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeveloperInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Localization.getString('aboutDeveloper')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dmitry Ziadik'),
            const SizedBox(height: 8),
            Text(Localization.getString('developerRole')),
            const SizedBox(height: 16),
            Text(
              Localization.getString('developerDescription'),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Localization.getString('close')),
          ),
        ],
      ),
    );
  }

  Future<void> _copyVersionToClipboard() async {
    final versionText =
        '$_appVersion${_buildNumber.isNotEmpty ? ' (${Localization.getString('build')} $_buildNumber)' : ''}';

    try {
      await Clipboard.setData(ClipboardData(text: versionText));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Localization.getString('versionCopied')),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${Localization.getString('error')}: ${e.toString()}'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _applyChanges() {
    setState(() {});
  }

  Future<void> _openLeaderboard() async {
    final levelManager = Provider.of<LevelManager>(context, listen: false);

    final shouldUpdate = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
    );

    if (shouldUpdate == true) {
      Navigator.pop(context, true);
    }
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
              final code = lang['code']!;
              final displayName = lang['displayName']!;
              final isSelected = settings.currentLocale.languageCode == code;

              return ListTile(
                title: Text(displayName),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () {
                  settings.currentLocale = Locale(code);
                  _applyChanges();
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
              trailing: settings.currentTheme == ThemeMode.system
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                settings.currentTheme = ThemeMode.system;
                _applyChanges();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(Localization.getString('lightTheme')),
              trailing: settings.currentTheme == ThemeMode.light
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                settings.currentTheme = ThemeMode.light;
                _applyChanges();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(Localization.getString('darkTheme')),
              trailing: settings.currentTheme == ThemeMode.dark
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                settings.currentTheme = ThemeMode.dark;
                _applyChanges();
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
              trailing: settings.vibrationStrength == 0
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                settings.vibrationStrength = 0;
                _vibrationManager.preview(settings);
                _applyChanges();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(Localization.getString('vibrationMedium')),
              trailing: settings.vibrationStrength == 1
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                settings.vibrationStrength = 1;
                _vibrationManager.preview(settings);
                _applyChanges();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(Localization.getString('vibrationStrong')),
              trailing: settings.vibrationStrength == 2
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                settings.vibrationStrength = 2;
                _vibrationManager.preview(settings);
                _applyChanges();
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
              _applyChanges();
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
