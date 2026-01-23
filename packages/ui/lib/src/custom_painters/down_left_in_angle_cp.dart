import 'package:flutter/material.dart';
import 'app_theme.dart';

class DownLeftInAngleCP extends CustomPainter {
  final AppTheme theme;

  DownLeftInAngleCP({AppTheme? theme}) : theme = theme ?? AppTheme.light();

  @override
  void paint(Canvas canvas, Size size) {
    var path_0 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.5000000, 0)
      ..lineTo(size.width * 0.5000000, size.height * 0.3200000)
      ..cubicTo(size.width * 0.5000000, size.height * 0.4194110, size.width * 0.5805890, size.height * 0.5000000, size.width * 0.6800000, size.height * 0.5000000)
      ..lineTo(size.width, size.height * 0.5000000)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    var paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = theme.backgroundColor;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant DownLeftInAngleCP oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
