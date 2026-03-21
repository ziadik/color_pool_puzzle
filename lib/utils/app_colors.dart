import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFF50427D);
  static const Color primaryColorDark = Color(0xFF2D2340);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFF8F4FF);
  static const Color backgroundColorDark = Color(0xFF363344);
  static const Color errorColor = Color(0xFFF44336);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Gradient colors
  static const Color buttonGradientStart = Color(0xFF722FC0);
  static const Color buttonGradientEnd = Color(0xFF8F5CEC);
  static const Color buttonIconColor = Color(0xFFD9C8FB);

  // Wall colors - these need to be accessed with BuildContext
  static Color wallLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? const Color(0xFF413C50) : const Color(0xFFF8F4FF);
  }

  static Color wallAccent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? const Color(0xFFA69DD4) : const Color(0xFF8889B6);
  }

  static Color wallShadow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.2);
  }

  // Field background
  static Color fieldBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2D234B) : const Color(0xFF50427D);
  }

  // Grid color
  static Color gridColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? const Color(0xFF645691).withOpacity(0.3) : const Color(0xFF3B2D68).withOpacity(0.4);
  }

  // Alert colors
  static Color alertTitleColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? Colors.white : primaryColor;
  }

  static Color alertMessageColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? Colors.white : primaryColor.withOpacity(0.8);
  }

  static Color alertBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2D2341) : backgroundColor;
  }

  static Color alertSuccessActionColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? successColor : secondaryColor;
  }

  static Color alertCancelActionColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? Colors.white70 : primaryColor.withOpacity(0.6);
  }

  static Color alertDestructiveActionColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? Colors.redAccent : errorColor;
  }
}
