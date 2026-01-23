import 'package:flutter/material.dart';
import 'app_theme.dart';

class LeftBridgeWOTShadowCP extends CustomPainter {
  final AppTheme theme;

  LeftBridgeWOTShadowCP({AppTheme? theme}) : theme = theme ?? AppTheme.light();

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width, size.height * 0.6700000);
    path_0.lineTo(size.width * 0.6800000, size.height * 0.6700000);
    path_0.cubicTo(size.width * 0.5805890, size.height * 0.6700000, size.width * 0.5000000, size.height * 0.7505890, size.width * 0.5000000, size.height * 0.8500000);
    path_0.lineTo(size.width * 0.5000000, size.height * 0.6800000);
    path_0.cubicTo(size.width * 0.5000000, size.height * 0.5805890, size.width * 0.5805890, size.height * 0.5000000, size.width * 0.6800000, size.height * 0.5000000);
    path_0.lineTo(size.width, size.height * 0.5000000);
    path_0.lineTo(size.width, size.height * 0.6700000);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = theme.wallDarkColor;
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.6800000, size.height * 0.5000000);
    path_1.cubicTo(size.width * 0.5805890, size.height * 0.5000000, size.width * 0.5000000, size.height * 0.5805890, size.width * 0.5000000, size.height * 0.6800000);
    path_1.lineTo(size.width * 0.5000000, size.height);
    path_1.lineTo(0, size.height);
    path_1.lineTo(0, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.3200000, size.height * 0.5000000);
    path_1.cubicTo(size.width * 0.4194110, size.height * 0.5000000, size.width * 0.5000000, size.height * 0.4194110, size.width * 0.5000000, size.height * 0.3200000);
    path_1.lineTo(size.width * 0.5000000, 0);
    path_1.lineTo(size.width, 0);
    path_1.lineTo(size.width, size.height * 0.5000000);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = theme.backgroundColor;
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant LeftBridgeWOTShadowCP oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
