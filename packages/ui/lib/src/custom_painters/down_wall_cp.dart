import 'package:flutter/material.dart';
import 'app_theme.dart';

class DownWallCP extends CustomPainter {
  final AppTheme theme;

  DownWallCP({AppTheme? theme}) : theme = theme ?? AppTheme.light();

  @override
  void paint(Canvas canvas, Size size) {
    var paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = theme.background;
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.5000000, size.width, size.height * 0.5000000), paint0Fill);
  }

  @override
  bool shouldRepaint(covariant DownWallCP oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
