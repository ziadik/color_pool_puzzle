import 'package:flutter/material.dart';

class AppColors {
  // Main colors
  static const Color background = Color(0xffF8F4FF);
  static const Color wallDark = Color(0xff8889B6);
  static const Color shadow = Color(0xff060606);
  static const Color gridLine = Color(0xff3D2F6B);

  // Opacities
  static const double shadowOpacity = 0.2;
  static const double blackShadowOpacity = 0.2;

  // Convenience getters with opacity
  static Color get shadowColor => shadow.withOpacity(shadowOpacity);
  static Color get blackShadowColor => Colors.black.withOpacity(blackShadowOpacity);
  static Color get wallDarkColor => wallDark.withOpacity(1.0);
  static Color get backgroundColor => background.withOpacity(1.0);
}
