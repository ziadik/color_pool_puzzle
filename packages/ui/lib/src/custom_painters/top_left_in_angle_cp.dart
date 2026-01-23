import 'package:flutter/material.dart';
import 'app_theme.dart';

class TopLeftInAngleCP extends CustomPainter {
  final AppTheme theme;

  TopLeftInAngleCP({AppTheme? theme}) : theme = theme ?? AppTheme.light();

  @override
  void paint(Canvas canvas, Size size) {
    var path_0 = Path()
      ..moveTo(size.width, size.height * 0.8200000)
      ..lineTo(size.width * 0.6800000, size.height * 0.8200000)
      ..cubicTo(size.width * 0.5805890, size.height * 0.8200000, size.width * 0.5000000, size.height * 0.9005890, size.width * 0.5000000, size.height)
      ..lineTo(size.width * 0.5000000, size.height * 0.8300000)
      ..cubicTo(size.width * 0.5000010, size.height * 0.7305900, size.width * 0.5805900, size.height * 0.6500000, size.width * 0.6800000, size.height * 0.6500000)
      ..lineTo(size.width, size.height * 0.6500000)
      ..lineTo(size.width, size.height * 0.8200000)
      ..close();

    var paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = theme.blackShadowColor;
    canvas.drawPath(path_0, paint0Fill);

    var path_1 = Path()
      ..moveTo(size.width, size.height * 0.6700000)
      ..lineTo(size.width * 0.6800000, size.height * 0.6700000)
      ..cubicTo(size.width * 0.5805890, size.height * 0.6700000, size.width * 0.5000000, size.height * 0.7505890, size.width * 0.5000000, size.height * 0.8500000)
      ..lineTo(size.width * 0.5000000, size.height * 0.6800000)
      ..cubicTo(size.width * 0.5000000, size.height * 0.5805890, size.width * 0.5805890, size.height * 0.5000000, size.width * 0.6800000, size.height * 0.5000000)
      ..lineTo(size.width, size.height * 0.5000000)
      ..lineTo(size.width, size.height * 0.6700000)
      ..close();

    var paint1Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = theme.wallDarkColor;
    canvas.drawPath(path_1, paint1Fill);

    var path_2 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.5000000)
      ..lineTo(size.width * 0.6800000, size.height * 0.5000000)
      ..cubicTo(size.width * 0.5805890, size.height * 0.5000000, size.width * 0.5000000, size.height * 0.5805890, size.width * 0.5000000, size.height * 0.6800000)
      ..lineTo(size.width * 0.5000000, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();

    var paint2Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = theme.backgroundColor;
    canvas.drawPath(path_2, paint2Fill);
  }

  @override
  bool shouldRepaint(covariant TopLeftInAngleCP oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
