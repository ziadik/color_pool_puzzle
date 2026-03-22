import 'package:color_pool_puzzle/models/wall_type.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

// Базовый класс для всех стен с передачей context
abstract class BaseWallPainter extends CustomPainter {
  final BuildContext context;

  BaseWallPainter(this.context);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Top Wall
class TopWallPainter extends BaseWallPainter {
  TopWallPainter(super.context);

  @override
  void paint(Canvas canvas, Size size) {
    final lightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallLight(context);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.5),
      lightPaint,
    );

    final accentPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallAccent(context);
    final middlePath = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.67)
      ..lineTo(0, size.height * 0.67)
      ..close();
    canvas.drawPath(middlePath, accentPaint);

    final shadowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallShadow(context);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.67, size.width, size.height * 0.15),
      shadowPaint,
    );
  }
}

// Left Wall (по умолчанию)
class LeftWallPainter extends BaseWallPainter {
  LeftWallPainter(super.context);

  @override
  void paint(Canvas canvas, Size size) {
    final lightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallLight(context);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * 0.5, size.height),
      lightPaint,
    );
  }
}

// Down Wall
class DownWallPainter extends BaseWallPainter {
  DownWallPainter(super.context);

  @override
  void paint(Canvas canvas, Size size) {
    final lightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallLight(context);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5),
      lightPaint,
    );
  }
}

// Block
class BlockPainter extends BaseWallPainter {
  BlockPainter(super.context);

  @override
  void paint(Canvas canvas, Size size) {
    final lightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallLight(context);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), lightPaint);
  }
}

// Top Left Out Angle (LOT)
class TopLeftOutAnglePainter extends BaseWallPainter {
  TopLeftOutAnglePainter(super.context);

  @override
  void paint(Canvas canvas, Size size) {
    // Shadow
    final shadowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallShadow(context);
    final shadowPath = Path()
      ..moveTo(0, size.height * 0.65)
      ..lineTo(size.width * 0.32, size.height * 0.65)
      ..cubicTo(
        size.width * 0.419411,
        size.height * 0.65,
        size.width * 0.5,
        size.height * 0.569411,
        size.width * 0.5,
        size.height * 0.47,
      )
      ..lineTo(size.width * 0.5, size.height * 0.64)
      ..cubicTo(
        size.width * 0.499999,
        size.height * 0.73941,
        size.width * 0.41941,
        size.height * 0.82,
        size.width * 0.32,
        size.height * 0.82,
      )
      ..lineTo(0, size.height * 0.82)
      ..close();
    canvas.drawPath(shadowPath, shadowPaint);

    // Middle part
    final accentPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallAccent(context);
    final middlePath = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width * 0.32, size.height * 0.5)
      ..cubicTo(
        size.width * 0.419411,
        size.height * 0.5,
        size.width * 0.5,
        size.height * 0.419411,
        size.width * 0.5,
        size.height * 0.32,
      )
      ..lineTo(size.width * 0.5, size.height * 0.49)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.589411,
        size.width * 0.419411,
        size.height * 0.67,
        size.width * 0.32,
        size.height * 0.67,
      )
      ..lineTo(0, size.height * 0.67)
      ..close();
    canvas.drawPath(middlePath, accentPaint);

    // Top part
    final lightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallLight(context);
    final topPath = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width * 0.5, size.height * 0.32)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.419411,
        size.width * 0.419411,
        size.height * 0.5,
        size.width * 0.32,
        size.height * 0.5,
      )
      ..lineTo(0, size.height * 0.5)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(topPath, lightPaint);
  }
}

// Top Left In Angle (LIT)
class TopLeftInAnglePainter extends BaseWallPainter {
  TopLeftInAnglePainter(super.context);

  @override
  void paint(Canvas canvas, Size size) {
    // Shadow
    final shadowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallShadow(context);
    final shadowPath = Path()
      ..moveTo(size.width, size.height * 0.82)
      ..lineTo(size.width * 0.68, size.height * 0.82)
      ..cubicTo(
        size.width * 0.580589,
        size.height * 0.82,
        size.width * 0.5,
        size.height * 0.900589,
        size.width * 0.5,
        size.height,
      )
      ..lineTo(size.width * 0.5, size.height * 0.83)
      ..cubicTo(
        size.width * 0.500001,
        size.height * 0.73059,
        size.width * 0.58059,
        size.height * 0.65,
        size.width * 0.68,
        size.height * 0.65,
      )
      ..lineTo(size.width, size.height * 0.65)
      ..close();
    canvas.drawPath(shadowPath, shadowPaint);

    // Middle part
    final accentPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallAccent(context);
    final middlePath = Path()
      ..moveTo(size.width, size.height * 0.67)
      ..lineTo(size.width * 0.68, size.height * 0.67)
      ..cubicTo(
        size.width * 0.580589,
        size.height * 0.67,
        size.width * 0.5,
        size.height * 0.750589,
        size.width * 0.5,
        size.height * 0.85,
      )
      ..lineTo(size.width * 0.5, size.height * 0.68)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.580589,
        size.width * 0.580589,
        size.height * 0.5,
        size.width * 0.68,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height * 0.5)
      ..close();
    canvas.drawPath(middlePath, accentPaint);

    // Main part
    final lightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallLight(context);
    final mainPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width * 0.68, size.height * 0.5)
      ..cubicTo(
        size.width * 0.580589,
        size.height * 0.5,
        size.width * 0.5,
        size.height * 0.580589,
        size.width * 0.5,
        size.height * 0.68,
      )
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(mainPath, lightPaint);
  }
}

// Down Left In Angle (LID)
class DownLeftInAnglePainter extends BaseWallPainter {
  DownLeftInAnglePainter(super.context);

  @override
  void paint(Canvas canvas, Size size) {
    final lightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallLight(context);
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.5, 0)
      ..lineTo(size.width * 0.5, size.height * 0.32)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.419411,
        size.width * 0.580589,
        size.height * 0.5,
        size.width * 0.68,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, lightPaint);
  }
}

// Down Right Out Angle (ROD)
class DownRightOutAnglePainter extends BaseWallPainter {
  DownRightOutAnglePainter(super.context);

  @override
  void paint(Canvas canvas, Size size) {
    final lightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallLight(context);
    final path = Path()
      ..moveTo(size.width * 0.5, size.height)
      ..lineTo(size.width * 0.5, size.height * 0.68)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.580589,
        size.width * 0.580589,
        size.height * 0.5,
        size.width * 0.68,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, lightPaint);
  }
}

// Left Bridge Without Shadow
class LeftBridgeWOTShadowPainter extends BaseWallPainter {
  LeftBridgeWOTShadowPainter(super.context);

  @override
  void paint(Canvas canvas, Size size) {
    // Middle part
    final accentPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallAccent(context);
    final middlePath = Path()
      ..moveTo(size.width, size.height * 0.67)
      ..lineTo(size.width * 0.68, size.height * 0.67)
      ..cubicTo(
        size.width * 0.580589,
        size.height * 0.67,
        size.width * 0.5,
        size.height * 0.750589,
        size.width * 0.5,
        size.height * 0.85,
      )
      ..lineTo(size.width * 0.5, size.height * 0.68)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.580589,
        size.width * 0.580589,
        size.height * 0.5,
        size.width * 0.68,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height * 0.5)
      ..close();
    canvas.drawPath(middlePath, accentPaint);

    // Main part
    final lightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallLight(context);
    final mainPath = Path()
      ..moveTo(size.width, size.height * 0.5)
      ..lineTo(size.width * 0.68, size.height * 0.5)
      ..cubicTo(
        size.width * 0.580589,
        size.height * 0.5,
        size.width * 0.5,
        size.height * 0.580589,
        size.width * 0.5,
        size.height * 0.68,
      )
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height * 0.5)
      ..lineTo(size.width * 0.32, size.height * 0.5)
      ..cubicTo(
        size.width * 0.419411,
        size.height * 0.5,
        size.width * 0.5,
        size.height * 0.419411,
        size.width * 0.5,
        size.height * 0.32,
      )
      ..lineTo(size.width * 0.5, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(mainPath, lightPaint);
  }
}

// Left Bridge Shadow
class LeftBridgeShadowPainter extends BaseWallPainter {
  LeftBridgeShadowPainter(super.context);

  @override
  void paint(Canvas canvas, Size size) {
    final shadowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.wallShadow(context);
    final shadowPath = Path()
      ..moveTo(size.width, size.height * 0.82)
      ..lineTo(size.width * 0.68, size.height * 0.82)
      ..cubicTo(
        size.width * 0.580589,
        size.height * 0.82,
        size.width * 0.5,
        size.height * 0.900589,
        size.width * 0.5,
        size.height,
      )
      ..lineTo(size.width * 0.5, size.height * 0.83)
      ..cubicTo(
        size.width * 0.500001,
        size.height * 0.73059,
        size.width * 0.58059,
        size.height * 0.65,
        size.width * 0.68,
        size.height * 0.65,
      )
      ..lineTo(size.width, size.height * 0.65)
      ..close();
    canvas.drawPath(shadowPath, shadowPaint);
  }
}

// Фабрика для получения правильного painter
CustomPainter? getWallPainter(WallType type, BuildContext context) {
  switch (type) {
    case WallType.L:
    case WallType.R:
      return LeftWallPainter(context);
    case WallType.T:
      return TopWallPainter(context);
    case WallType.D:
      return DownWallPainter(context);
    case WallType.LIT:
    case WallType.RIT:
      return TopLeftInAnglePainter(context);
    case WallType.LOT:
    case WallType.ROT:
      return TopLeftOutAnglePainter(context);
    case WallType.LID:
    case WallType.RID:
      return DownLeftInAnglePainter(context);
    case WallType.LOD:
    case WallType.ROD:
      return DownRightOutAnglePainter(context);
    case WallType.B:
      return BlockPainter(context);
    case WallType.LB:
      return LeftBridgeWOTShadowPainter(context);
    case WallType.RB:
      return LeftBridgeWOTShadowPainter(context);
    default:
      return null;
  }
}
