import 'package:flutter/material.dart';
import 'app_theme.dart';

class BlockCP extends CustomPainter {
  final AppTheme theme;

  BlockCP({AppTheme? theme}) : theme = theme ?? AppTheme.light();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = theme.background;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint0Fill);
  }

  @override
  bool shouldRepaint(covariant BlockCP oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
