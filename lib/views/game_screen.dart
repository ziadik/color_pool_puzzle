import 'package:color_pool_puzzle/models/game_color.dart';
import 'package:color_pool_puzzle/models/item.dart';
import 'package:color_pool_puzzle/models/level.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/field_engine.dart';
import '../controllers/level_manager.dart';
import '../controllers/settings_manager.dart';
import '../services/sound_manager.dart';
import '../services/vibration_manager.dart';
import '../views/widgets/field_view.dart';
import '../views/widgets/gradient_button.dart';
import '../views/widgets/level_label.dart';
import '../utils/app_colors.dart';
import '../utils/localization.dart';
import 'settings_screen.dart';
import 'leaderboard_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late FieldEngine _engine;
  final SoundManager _soundManager = SoundManager();
  final VibrationManager _vibrationManager = VibrationManager();
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initGame();
    _soundManager.init();

    // Синхронизируем maxOpenedLevel при загрузке
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = Provider.of<SettingsManager>(context, listen: false);
      final levelManager = Provider.of<LevelManager>(context, listen: false);
      if (levelManager.maxOpenedLevel != settings.maxOpenedLevel) {
        print('🔄 Syncing maxOpenedLevel: ${settings.maxOpenedLevel}');
        levelManager.maxOpenedLevel = settings.maxOpenedLevel;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Обновляем при возвращении на экран
    _syncMaxOpenedLevel();
  }

  void _syncMaxOpenedLevel() {
    final settings = Provider.of<SettingsManager>(context, listen: false);
    final levelManager = Provider.of<LevelManager>(context, listen: false);
    if (levelManager.maxOpenedLevel != settings.maxOpenedLevel) {
      print('🔄 Syncing maxOpenedLevel on resume: ${settings.maxOpenedLevel}');
      levelManager.maxOpenedLevel = settings.maxOpenedLevel;
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _soundManager.dispose();
    super.dispose();
  }

  void _initGame() {
    try {
      final levelManager = Provider.of<LevelManager>(context, listen: false);
      final level = levelManager.getCurrentLevel();
      print('🎮 Initializing game with level ${levelManager.currentLevelIndex + 1}');
      print('  Width: ${level.width}, Height: ${level.height}');
      print('  Balls count: ${level.countBalls()}');
      _engine = FieldEngine(level: level);
      _hasUnsavedChanges = false;
      setState(() {});
    } catch (e) {
      print('Error initializing game: $e');
      // Fallback - создаем тестовый уровень
      final testField = List.generate(5, (row) => List<Item?>.filled(5, null));
      if (testField.length > 2 && testField[0].length > 2) {
        testField[2][2] = Ball(GameColor.red);
        testField[2][3] = Hole(GameColor.red);
      }
      final testLevel = Level(width: 5, height: 5, initialField: testField);
      _engine = FieldEngine(level: testLevel);
      _hasUnsavedChanges = false;
    }
  }

  void _onMove() {
    setState(() {
      _hasUnsavedChanges = _engine.movesCount > 0;
    });

    final settings = Provider.of<SettingsManager>(context, listen: false);

    if (_engine.lastMoveWasHitHole) {
      _soundManager.playHoleCaptureSound(settings);
      _vibrationManager.mediumImpact(settings);
    } else {
      _soundManager.playBallMoveSound(settings);
      _vibrationManager.lightImpact(settings);
    }

    if (_engine.isWin()) {
      _soundManager.playVictorySound(settings);
      _vibrationManager.success(settings);
      _showWinDialog();
    }
  }

  void _showWinDialog() async {
    final settings = Provider.of<SettingsManager>(context, listen: false);
    final levelManager = Provider.of<LevelManager>(context, listen: false);

    print('🏆 Level completed!');
    print('  Level index: ${levelManager.currentLevelIndex}');
    print('  Moves: ${_engine.movesCount}');
    print('  Current maxOpenedLevel in SettingsManager: ${settings.maxOpenedLevel}');
    print('  Current maxOpenedLevel in LevelManager: ${levelManager.maxOpenedLevel}');

    await settings.saveRecord(levelManager.currentLevelIndex, _engine.movesCount);

    // Обновляем maxOpenedLevel
    final nextLevelIndex = levelManager.currentLevelIndex + 1;
    if (nextLevelIndex > settings.maxOpenedLevel) {
      print('📈 Updating maxOpenedLevel to $nextLevelIndex');
      settings.maxOpenedLevel = nextLevelIndex;
      levelManager.maxOpenedLevel = nextLevelIndex;
    }

    // Проверяем после обновления
    print('  After update - SettingsManager maxOpenedLevel: ${settings.maxOpenedLevel}');
    print('  After update - LevelManager maxOpenedLevel: ${levelManager.maxOpenedLevel}');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(Localization.getString('levelComplete')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Localization.plural('moves', _engine.movesCount)),
            if (levelManager.currentLevelIndex + 1 >= levelManager.totalLevels) Text(Localization.getString('allLevelsPassed')),
          ],
        ),
        actions: [
          if (levelManager.currentLevelIndex + 1 < levelManager.totalLevels)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _nextLevel();
              },
              child: Text(Localization.getString('nextLevel')),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartLevel();
            },
            child: Text(Localization.getString('restart')),
          ),
        ],
      ),
    );
  }

  void _nextLevel() {
    final levelManager = Provider.of<LevelManager>(context, listen: false);
    if (levelManager.nextLevel()) {
      _initGame();
      setState(() {});
    }
  }

  void _restartLevel() {
    _initGame();
    setState(() {});
  }

  void _previousLevel() async {
    final levelManager = Provider.of<LevelManager>(context, listen: false);
    final targetIndex = levelManager.currentLevelIndex - 1;

    if (targetIndex < 0) return;

    if (_hasUnsavedChanges) {
      final confirmed = await _showNavigationDialog('previous');
      if (confirmed) {
        levelManager.currentLevelIndex = targetIndex;
        _initGame();
        setState(() {});
      }
    } else {
      levelManager.currentLevelIndex = targetIndex;
      _initGame();
      setState(() {});
    }
  }

  void _nextLevelNavigation() async {
    final levelManager = Provider.of<LevelManager>(context, listen: false);
    final targetIndex = levelManager.currentLevelIndex + 1;

    if (targetIndex >= levelManager.totalLevels) return;
    if (targetIndex > levelManager.maxOpenedLevel) {
      _showLevelLockedDialog();
      return;
    }

    if (_hasUnsavedChanges) {
      final confirmed = await _showNavigationDialog('next');
      if (confirmed) {
        levelManager.currentLevelIndex = targetIndex;
        _initGame();
        setState(() {});
      }
    } else {
      levelManager.currentLevelIndex = targetIndex;
      _initGame();
      setState(() {});
    }
  }

  void _navigateToLevel(int levelIndex) {
    final levelManager = Provider.of<LevelManager>(context, listen: false);
    final settings = Provider.of<SettingsManager>(context, listen: false);

    // Проверяем, доступен ли уровень
    if (levelIndex <= settings.maxOpenedLevel && levelIndex < levelManager.totalLevels) {
      if (_hasUnsavedChanges) {
        _showNavigationDialog('level').then((confirmed) {
          if (confirmed == true) {
            levelManager.currentLevelIndex = levelIndex;
            _initGame();
            setState(() {});
          }
        });
      } else {
        levelManager.currentLevelIndex = levelIndex;
        _initGame();
        setState(() {});
      }
    }
  }

  Future<bool> _showNavigationDialog(String direction) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Localization.getString('unsavedChanges')),
        content: Text(Localization.getString('unsavedChangesNavigation').replaceAll('%@', Localization.getString(direction))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Localization.getString('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(Localization.getString('continue')),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showRestartDialog() async {
    if (!_hasUnsavedChanges) {
      _restartLevel();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Localization.getString('restartLevel')),
        content: Text(Localization.getString('unsavedChangesRestart')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Localization.getString('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(Localization.getString('restart')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _restartLevel();
    }
  }

  void _showLevelLockedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Localization.getString('levelLocked')),
        content: Text(Localization.getString('completePreviousLevels')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHint() {
    final hint = _engine.getHint();
    if (hint != null) {
      final (x, y, direction) = hint;
      final directionText = direction.toString().split('.').last;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${Localization.getString('hint')}: '
              '($x, $y) → ${Localization.getString(directionText)}'),
          duration: const Duration(seconds: 3),
        ),
      );

      _vibrationManager.lightImpact(
        Provider.of<SettingsManager>(context, listen: false),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localization.getString('noHints')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _openSettings() async {
    final shouldUpdate = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );

    // Если были изменения (выбран уровень из leaderboard через настройки)
    if (shouldUpdate == true) {
      _syncMaxOpenedLevel();
      _initGame();
      setState(() {});
    } else {
      _syncMaxOpenedLevel();
    }
  }

  void _openLeaderboard() async {
    final shouldUpdate = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
    );

    // Если был выбран уровень из leaderboard, обновляем игру
    if (shouldUpdate == true) {
      _syncMaxOpenedLevel();
      _initGame();
      setState(() {});
    } else {
      // Просто синхронизируем
      _syncMaxOpenedLevel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelManager = Provider.of<LevelManager>(context);
    final settings = Provider.of<SettingsManager>(context);

    return Scaffold(
      backgroundColor: AppColors.wallLight(context),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return _buildPortraitLayout(levelManager, settings);
        },
      ),
    );
  }

  Widget _buildPortraitLayout(LevelManager levelManager, SettingsManager settings) {
    final isNextLevelUnlocked = levelManager.currentLevelIndex + 1 <= settings.maxOpenedLevel;
    final isLastLevel = levelManager.currentLevelIndex + 1 >= levelManager.totalLevels;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GradientButton(
                  icon: Icons.refresh,
                  onPressed: _showRestartDialog,
                ),
                Row(
                  children: [
                    GradientButton(
                      icon: Icons.chevron_left,
                      onPressed: _previousLevel,
                      isEnabled: levelManager.currentLevelIndex > 0,
                    ),
                    const SizedBox(width: 16),
                    LevelLabel(
                      levelNumber: levelManager.currentLevelIndex + 1,
                    ),
                    const SizedBox(width: 16),
                    // Кнопка следующего уровня с разными иконками
                    if (isLastLevel)
                      // Последний уровень - показываем кубок с переходом к leaderboard
                      GradientButton(
                        icon: Icons.emoji_events,
                        onPressed: _openLeaderboard,
                        isEnabled: true,
                      )
                    else if (isNextLevelUnlocked)
                      // Уровень пройден - показываем стрелку
                      GradientButton(
                        icon: Icons.chevron_right,
                        onPressed: _nextLevelNavigation,
                        isEnabled: true,
                      )
                    else
                      // Уровень не пройден - показываем замок
                      GradientButton(
                        icon: Icons.lock,
                        onPressed: _showLevelLockedDialog,
                        isEnabled: true,
                      ),
                  ],
                ),
                GradientButton(
                  icon: Icons.settings,
                  onPressed: _openSettings,
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: FieldView(
                engine: _engine,
                onMove: _onMove,
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       GradientButton(
          //         icon: Icons.lightbulb_outline,
          //         label: Localization.getString('hint'),
          //         onPressed: _showHint,
          //       ),
          //       const SizedBox(width: 16),
          //       GradientButton(
          //         icon: Icons.emoji_events,
          //         label: Localization.getString('leaderboard'),
          //         onPressed: _openLeaderboard,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
