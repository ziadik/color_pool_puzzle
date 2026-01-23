import 'package:flutter/material.dart';
import 'app_theme.dart';

class TopWallCP extends CustomPainter {
  final AppTheme theme;

  TopWallCP({AppTheme? theme}) : theme = theme ?? AppTheme.light();

  @override
  void paint(Canvas canvas, Size size) {
    var paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = theme.background;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.5000000), paint0Fill);

    var path_1 = Path()
      ..moveTo(0, size.height * 0.5000000)
      ..lineTo(size.width, size.height * 0.5000000)
      ..lineTo(size.width, size.height * 0.6700000)
      ..lineTo(0, size.height * 0.6700000)
      ..lineTo(0, size.height * 0.5000000)
      ..close();

    var paint1Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = theme.wallDarkColor;
    canvas.drawPath(path_1, paint1Fill);

    var paint2Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = theme.shadowColor;
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.6700000, size.width, size.height * 0.1500000), paint2Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is TopWallCP && oldDelegate.theme != theme;
  }
}
