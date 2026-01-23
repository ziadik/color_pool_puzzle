import 'package:flutter/material.dart';
import 'app_theme.dart';

class TopLeftOutAngleCP extends CustomPainter {
  final AppTheme theme;

  TopLeftOutAngleCP({AppTheme? theme}) : theme = theme ?? AppTheme.light();

  @override
  void paint(Canvas canvas, Size size) {
    var path_0 = Path()
      ..moveTo(0, size.height * 0.6500000)
      ..lineTo(size.width * 0.3200000, size.height * 0.6500000)
      ..cubicTo(size.width * 0.4194110, size.height * 0.6500000, size.width * 0.5000000, size.height * 0.5694110, size.width * 0.5000000, size.height * 0.4700000)
      ..lineTo(size.width * 0.5000000, size.height * 0.6400000)
      ..cubicTo(size.width * 0.4999990, size.height * 0.7394100, size.width * 0.4194100, size.height * 0.8200000, size.width * 0.3200000, size.height * 0.8200000)
      ..lineTo(0, size.height * 0.8200000)
      ..lineTo(0, size.height * 0.6500000)
      ..close();

    var paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = theme.blackShadowColor;
    canvas.drawPath(path_0, paint0Fill);

    var path_1 = Path()
      ..moveTo(0, size.height * 0.5000000)
      ..lineTo(size.width * 0.3200000, size.height * 0.5000000)
      ..cubicTo(size.width * 0.4194110, size.height * 0.5000000, size.width * 0.5000000, size.height * 0.4194110, size.width * 0.5000000, size.height * 0.3200000)
      ..lineTo(size.width * 0.5000000, size.height * 0.4900000)
      ..cubicTo(size.width * 0.5000000, size.height * 0.5894110, size.width * 0.4194110, size.height * 0.6700000, size.width * 0.3200000, size.height * 0.6700000)
      ..lineTo(0, size.height * 0.6700000)
      ..lineTo(0, size.height * 0.5000000)
      ..close();

    var paint1Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = theme.wallDarkColor;
    canvas.drawPath(path_1, paint1Fill);

    var path_2 = Path()
      ..moveTo(size.width * 0.5000000, 0)
      ..lineTo(size.width * 0.5000000, size.height * 0.3200000)
      ..cubicTo(size.width * 0.5000000, size.height * 0.4194110, size.width * 0.4194110, size.height * 0.5000000, size.width * 0.3200000, size.height * 0.5000000)
      ..lineTo(0, size.height * 0.5000000)
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.5000000, 0)
      ..close();

    var paint2Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = theme.backgroundColor;
    canvas.drawPath(path_2, paint2Fill);
  }

  @override
  bool shouldRepaint(covariant TopLeftOutAngleCP oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
