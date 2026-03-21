import 'package:flutter/material.dart';

enum GameColor {
  gray,
  green,
  red,
  blue,
  yellow,
  purple,
  cyan,
}

extension GameColorExtension on GameColor {
  Color toColor() {
    switch (this) {
      case GameColor.gray:
        return Colors.grey[500]!;
      case GameColor.green:
        return Colors.green;
      case GameColor.red:
        return Colors.red;
      case GameColor.blue:
        return Colors.blue;
      case GameColor.yellow:
        return Colors.yellow;
      case GameColor.purple:
        return Colors.purple;
      case GameColor.cyan:
        return Colors.cyan;
    }
  }
  
  static GameColor fromInt(int value) {
    switch (value) {
      case 2: return GameColor.green;
      case 3: return GameColor.red;
      case 4: return GameColor.blue;
      case 5: return GameColor.yellow;
      case 6: return GameColor.purple;
      case 7: return GameColor.cyan;
      default: return GameColor.gray;
    }
  }
}