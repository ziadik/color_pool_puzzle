export 'package:ui/example.dart';

import 'package:levels/levels.dart';
import 'package:ui/ui.dart';

class GameEngine {
  final LevelMaps level;
  final AppTheme theme;

  GameEngine(this.level, this.theme);
}
