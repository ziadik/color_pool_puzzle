import 'package:flutter/material.dart';
import 'app_theme.dart';

class LeftBridgesShadow extends CustomPainter {
  final AppTheme theme;

  LeftBridgesShadow({AppTheme? theme}) : theme = theme ?? AppTheme.light();

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width, size.height * 0.8200000);
    path_0.lineTo(size.width * 0.6800000, size.height * 0.8200000);
    path_0.cubicTo(size.width * 0.5805890, size.height * 0.8200000, size.width * 0.5000000, size.height * 0.9005890, size.width * 0.5000000, size.height);
    path_0.lineTo(size.width * 0.5000000, size.height * 0.8300000);
    path_0.cubicTo(size.width * 0.5000010, size.height * 0.7305900, size.width * 0.5805900, size.height * 0.6500000, size.width * 0.6800000, size.height * 0.6500000);
    path_0.lineTo(size.width, size.height * 0.6500000);
    path_0.lineTo(size.width, size.height * 0.8200000);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = theme.blackShadowColor;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant LeftBridgesShadow oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
