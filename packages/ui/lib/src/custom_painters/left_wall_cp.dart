import 'package:flutter/material.dart';
import 'app_theme.dart';

// Left по умолчанию
class LeftWallCP extends CustomPainter {
  final AppTheme theme;

  LeftWallCP({AppTheme? theme}) : theme = theme ?? AppTheme.light();

  @override
  void paint(Canvas canvas, Size size) {
    var paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = theme.background;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width * 0.500000, size.height), paint0Fill);
  }

  @override
  bool shouldRepaint(covariant LeftWallCP oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
