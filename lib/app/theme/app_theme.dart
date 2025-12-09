import 'package:flutter/material.dart';

/// {@template app_colors}
/// Класс, реализующий расширение для добавления токенов в цветовую схему
/// {@endtemplate}
class AppColors extends ThemeExtension<AppColors> {
  /// {@macro app_colors}
  ///
  /// Принимает:
  ///
  /// * [testColor] - цвет тестового текста
  /// * [errorSnackbarBackground] - цвет фона снекбара ошибки
  /// * [successSnackbarBackground] - цвет фона снекбара успеха
  /// * [infoSnackbarBackground] - цвет фона снекбара информации
  /// * [itemTextColor] - цвет элемента текста
  const AppColors({required this.testColor, required this.itemTextColor, required this.errorSnackbarBackground, required this.successSnackbarBackground, required this.infoSnackbarBackground});

  /// Цвет тестовый
  final Color testColor;

  /// Цвет элемента текста
  final Color itemTextColor;

  /// Цвет фона снекбара ошибки
  final Color errorSnackbarBackground;

  /// Цвет фона снекбара успеха
  final Color successSnackbarBackground;

  /// Цвет фона снекбара информации
  final Color infoSnackbarBackground;

  @override
  ThemeExtension<AppColors> copyWith({Color? testColor, Color? itemTextColor, Color? errorSnackbarBackground, Color? successSnackbarBackground, Color? infoSnackbarBackground}) {
    return AppColors(
      testColor: testColor ?? this.testColor,
      itemTextColor: itemTextColor ?? this.itemTextColor,
      errorSnackbarBackground: errorSnackbarBackground ?? this.errorSnackbarBackground,
      successSnackbarBackground: successSnackbarBackground ?? this.successSnackbarBackground,
      infoSnackbarBackground: infoSnackbarBackground ?? this.infoSnackbarBackground,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      testColor: Color.lerp(testColor, other.testColor, t) ?? testColor,
      itemTextColor: Color.lerp(itemTextColor, other.itemTextColor, t) ?? itemTextColor,
      errorSnackbarBackground: Color.lerp(errorSnackbarBackground, other.errorSnackbarBackground, t) ?? errorSnackbarBackground,
      successSnackbarBackground: Color.lerp(successSnackbarBackground, other.successSnackbarBackground, t) ?? successSnackbarBackground,
      infoSnackbarBackground: Color.lerp(infoSnackbarBackground, other.infoSnackbarBackground, t) ?? infoSnackbarBackground,
    );
  }

  /// Цвета светлой темы
  static const AppColors light = AppColors(
    testColor: Colors.red,
    errorSnackbarBackground: Color(0xFFD24720),
    successSnackbarBackground: Color(0xFF6FB62C),
    infoSnackbarBackground: Color.fromARGB(255, 220, 108, 77),
    itemTextColor: Color(0xFFFAF3EB),
  );

  /// Цвета тёмной темы
  static const AppColors dark = AppColors(
    testColor: Colors.green,
    errorSnackbarBackground: Color(0xFF638B8B),
    successSnackbarBackground: Color(0xFF93C499),
    infoSnackbarBackground: Color.fromARGB(255, 35, 147, 178),
    itemTextColor: Colors.white,
  );
}

/// Класс для конфигурации светлой/темной темы приложения
abstract class AppTheme {
  /// Геттер для получения светлой темы
  static ThemeData get light => ThemeData.light().copyWith(extensions: <ThemeExtension<Object?>>[AppColors.light]);

  /// Геттер для получения темной темы
  static ThemeData get dark => ThemeData.dark().copyWith(extensions: <ThemeExtension<Object?>>[AppColors.dark]);
}
