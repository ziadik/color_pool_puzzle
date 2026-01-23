import 'package:flutter/material.dart';
import 'app_theme.dart';

class DownRightOutAngleCP extends CustomPainter {
  final AppTheme theme;

  DownRightOutAngleCP({AppTheme? theme}) : theme = theme ?? AppTheme.light();

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5000000, size.height);
    path_0.lineTo(size.width * 0.5000000, size.height * 0.6800000);
    path_0.cubicTo(size.width * 0.5000000, size.height * 0.5805890, size.width * 0.5805890, size.height * 0.5000000, size.width * 0.6800000, size.height * 0.5000000);
    path_0.lineTo(size.width, size.height * 0.5000000);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(size.width * 0.5000000, size.height);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = theme.backgroundColor;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant DownRightOutAngleCP oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
