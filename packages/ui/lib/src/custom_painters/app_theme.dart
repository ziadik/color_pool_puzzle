import 'package:flutter/material.dart';

enum ThemeType { light, dark, blue, purple, green }

class AppTheme {
  final ThemeType type;

  // Colors
  final Color background;
  final Color wallDark;
  final Color shadow;
  final Color gridLine;

  // Opacities
  final double shadowOpacity;
  final double blackShadowOpacity;

  AppTheme({required this.type, required this.background, required this.wallDark, required this.shadow, required this.gridLine, this.shadowOpacity = 0.2, this.blackShadowOpacity = 0.2});

  // Convenience getters
  Color get shadowColor => shadow.withOpacity(shadowOpacity);
  Color get blackShadowColor => Colors.black.withOpacity(blackShadowOpacity);
  Color get wallDarkColor => wallDark.withOpacity(1.0);
  Color get backgroundColor => background.withOpacity(1.0);

  // Factory constructors for different themes
  factory AppTheme.light() {
    return AppTheme(type: ThemeType.light, background: const Color(0xffF8F4FF), wallDark: const Color(0xff8889B6), shadow: const Color(0xff060606), gridLine: const Color(0xff3D2F6B));
  }

  factory AppTheme.dark() {
    return AppTheme(
      type: ThemeType.dark,
      background: const Color(0xff2D2D3D),
      wallDark: const Color(0xff4A4A6B),
      shadow: const Color(0xff000000),
      gridLine: const Color(0xff5A5A7B),
      shadowOpacity: 0.3,
      blackShadowOpacity: 0.3,
    );
  }

  factory AppTheme.blue() {
    return AppTheme(type: ThemeType.blue, background: const Color(0xffE8F4FF), wallDark: const Color(0xff5A8FB6), shadow: const Color(0xff2D5D7A), gridLine: const Color(0xff3D6B8F));
  }

  factory AppTheme.purple() {
    return AppTheme(type: ThemeType.purple, background: const Color(0xffF4E8FF), wallDark: const Color(0xff9B6BB6), shadow: const Color(0xff4A2D5D), gridLine: const Color(0xff6B3D8F));
  }

  factory AppTheme.green() {
    return AppTheme(type: ThemeType.green, background: const Color(0xffF4FFF8), wallDark: const Color(0xff6BB68F), shadow: const Color(0xff2D5D4A), gridLine: const Color(0xff3D8F6B));
  }

  // Get theme by type
  static AppTheme getTheme(ThemeType type) {
    switch (type) {
      case ThemeType.light:
        return AppTheme.light();
      case ThemeType.dark:
        return AppTheme.dark();
      case ThemeType.blue:
        return AppTheme.blue();
      case ThemeType.purple:
        return AppTheme.purple();
      case ThemeType.green:
        return AppTheme.green();
    }
  }

  // Theme names
  static String getThemeName(ThemeType type) {
    switch (type) {
      case ThemeType.light:
        return 'Light';
      case ThemeType.dark:
        return 'Dark';
      case ThemeType.blue:
        return 'Blue';
      case ThemeType.purple:
        return 'Purple';
      case ThemeType.green:
        return 'Green';
    }
  }

  // All available themes
  static List<AppTheme> get allThemes => [AppTheme.light(), AppTheme.dark(), AppTheme.blue(), AppTheme.purple(), AppTheme.green()];
}
