import 'package:color_pool_puzzle/controllers/settings_manager.dart';
import 'package:flutter/material.dart';
import '../models/level.dart';
import '../models/item.dart';
import '../models/game_color.dart';
import '../utils/level_maps.dart';
import '../utils/level_data.dart';

class LevelManager extends ChangeNotifier {
  int _currentLevelIndex = 0;
  int _maxOpenedLevel = 0;
  final List<Level> _levels = [];
  final List<LevelInfo> _levelInfos = [];

  LevelManager() {
    _loadAllLevels();
  }

  int get currentLevelIndex => _currentLevelIndex;
  int get maxOpenedLevel => _maxOpenedLevel;
  int get totalLevels => _levels.length;

  set currentLevelIndex(int index) {
    if (index >= 0 && index < _levels.length) {
      _currentLevelIndex = index;
      notifyListeners();
    }
  }

  set maxOpenedLevel(int value) {
    if (value > _maxOpenedLevel) {
      _maxOpenedLevel = value;
      notifyListeners();
    }
  }

  void syncWithSettings(SettingsManager settings) {
    if (settings.maxOpenedLevel > _maxOpenedLevel) {
      _maxOpenedLevel = settings.maxOpenedLevel;
      _currentLevelIndex = _maxOpenedLevel;
      notifyListeners();
    }
  }

  Level getCurrentLevel() {
    if (_levels.isEmpty) {
      print('⚠️ No levels loaded!');
      return Level(width: 1, height: 1, initialField: [
        [null]
      ]);
    }
    if (_currentLevelIndex >= _levels.length) {
      _currentLevelIndex = _levels.length - 1;
    }
    print('📦 Getting level ${_currentLevelIndex + 1}/${_levels.length}');
    final level = _levels[_currentLevelIndex].copy();
    print('  Width: ${level.width}, Height: ${level.height}');
    print('  Balls count: ${level.countBalls()}');
    return level;
  }

  bool nextLevel() {
    if (_currentLevelIndex < _levels.length - 1) {
      _currentLevelIndex++;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool previousLevel() {
    if (_currentLevelIndex > 0) {
      _currentLevelIndex--;
      notifyListeners();
      return true;
    }
    return false;
  }

  void _loadAllLevels() {
    print('🔄 Loading levels...');

    _levelInfos.addAll(LevelData.parseLevels());
    print('✅ Loaded ${_levelInfos.length} numeric level definitions');

    for (int i = 0; i < LevelMaps.levels.length && i < _levelInfos.length; i++) {
      final levelInfo = _levelInfos[i];
      final wallsData = LevelMaps.getCleanedLevel(i);

      final level = _createLevel(levelInfo, wallsData);
      if (level != null) {
        _levels.add(level);
        print('✅ Created level ${i + 1}: ${level.width}x${level.height}, ${level.countBalls()} balls');
      } else {
        print('❌ Failed to create level $i');
      }
    }

    print('✅ Total levels loaded: ${_levels.length}');
  }

  Level? _createLevel(LevelInfo levelInfo, List<String> wallsData) {
    // Use dimensions from walls data (it has the correct size with walls)
    final height = wallsData.length;
    if (height == 0) return null;

    final firstLineParts = wallsData[0].split(' ').where((s) => s.isNotEmpty).toList();
    final width = firstLineParts.length;

    // Create field with walls first, then add items
    final field = List<List<Item?>>.generate(
      height,
      (row) => List<Item?>.filled(width, null),
    );

    // First, add all items from numeric data (balls and holes)
    for (int row = 0; row < levelInfo.height && row < height; row++) {
      for (int col = 0; col < levelInfo.width && col < width; col++) {
        final value = levelInfo.field[row][col];
        if (value != null && value != 0) {
          final item = _itemFromInt(value);
          if (item != null) {
            field[row][col] = item;
            if (item is Ball) {
              print('  🎯 Ball at [$row, $col] color: ${item.color}');
            } else if (item is Hole) {
              print('  🕳️ Hole at [$row, $col] color: ${item.color}');
            }
          }
        }
      }
    }

    // Note: Walls are drawn separately in FieldView using GameBoard
    // They are not stored in the field array

    return Level(width: width, height: height, initialField: field);
  }

  Item? _itemFromInt(int value) {
    switch (value) {
      case 0:
        return null;
      case 1:
        return Block();
      case 2:
        return Ball(GameColor.green);
      case 3:
        return Ball(GameColor.red);
      case 4:
        return Ball(GameColor.blue);
      case 5:
        return Ball(GameColor.yellow);
      case 6:
        return Ball(GameColor.purple);
      case 7:
        return Ball(GameColor.cyan);
      case 22:
        return Hole(GameColor.green);
      case 33:
        return Hole(GameColor.red);
      case 44:
        return Hole(GameColor.blue);
      case 55:
        return Hole(GameColor.yellow);
      case 66:
        return Hole(GameColor.purple);
      case 77:
        return Hole(GameColor.cyan);
      default:
        print('⚠️ Unknown value: $value');
        return null;
    }
  }
}
