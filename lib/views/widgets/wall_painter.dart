import 'package:color_pool_puzzle/models/wall_type.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

abstract class WallPainter {
  void paint(Canvas canvas, Size size, BuildContext context);
}

class TopWallPainter implements WallPainter {
  @override
  void paint(Canvas canvas, Size size, BuildContext context) {
    final width = size.width;
    final height = size.height;
    final shadowInset = 1.9;

    // Light top part
    final lightPaint = Paint()..color = AppColors.wallLight(context);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height * 0.5),
      lightPaint,
    );

    // Middle part
    final accentPaint = Paint()..color = AppColors.wallAccent(context);
    final middlePath = Path()
      ..moveTo(0, height * 0.5)
      ..lineTo(width, height * 0.5)
      ..lineTo(width, height * 0.67)
      ..lineTo(0, height * 0.67)
      ..close();
    canvas.drawPath(middlePath, accentPaint);

    // Shadow
    final shadowPaint = Paint()..color = AppColors.wallShadow(context);
    canvas.drawRect(
      Rect.fromLTWH(shadowInset, height * 0.67, width - shadowInset * 2, height * 0.15),
      shadowPaint,
    );
  }
}

class LeftWallPainter implements WallPainter {
  @override
  void paint(Canvas canvas, Size size, BuildContext context) {
    final lightPaint = Paint()..color = AppColors.wallLight(context);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * 0.5, size.height),
      lightPaint,
    );
  }
}

class DownWallPainter implements WallPainter {
  @override
  void paint(Canvas canvas, Size size, BuildContext context) {
    final lightPaint = Paint()..color = AppColors.wallLight(context);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5),
      lightPaint,
    );
  }
}

class BlockPainter implements WallPainter {
  @override
  void paint(Canvas canvas, Size size, BuildContext context) {
    final lightPaint = Paint()..color = AppColors.wallLight(context);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), lightPaint);
  }
}

class TopLeftOutAnglePainter implements WallPainter {
  @override
  void paint(Canvas canvas, Size size, BuildContext context) {
    final width = size.width;
    final height = size.height;
    final shadowInset = 1.9;

    // Shadow
    final shadowPaint = Paint()..color = AppColors.wallShadow(context);
    final shadowPath = Path()
      ..moveTo(shadowInset, height * 0.65)
      ..lineTo(width * 0.32, height * 0.65)
      ..quadraticBezierTo(
        width * 0.419,
        height * 0.65,
        width * 0.5,
        height * 0.47,
      )
      ..lineTo(width * 0.5, height * 0.64)
      ..quadraticBezierTo(
        width * 0.5,
        height * 0.739,
        width * 0.32,
        height * 0.82,
      )
      ..lineTo(shadowInset, height * 0.82)
      ..close();
    canvas.drawPath(shadowPath, shadowPaint);

    // Middle part
    final accentPaint = Paint()..color = AppColors.wallAccent(context);
    final middlePath = Path()
      ..moveTo(0, height * 0.5)
      ..lineTo(width * 0.32, height * 0.5)
      ..quadraticBezierTo(
        width * 0.419,
        height * 0.5,
        width * 0.5,
        height * 0.32,
      )
      ..lineTo(width * 0.5, height * 0.49)
      ..quadraticBezierTo(
        width * 0.5,
        height * 0.589,
        width * 0.32,
        height * 0.67,
      )
      ..lineTo(0, height * 0.67)
      ..close();
    canvas.drawPath(middlePath, accentPaint);

    // Top part
    final lightPaint = Paint()..color = AppColors.wallLight(context);
    final topPath = Path()
      ..moveTo(width * 0.5, 0)
      ..lineTo(width * 0.5, height * 0.32)
      ..quadraticBezierTo(
        width * 0.5,
        height * 0.419,
        width * 0.32,
        height * 0.5,
      )
      ..lineTo(0, height * 0.5)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(topPath, lightPaint);
  }
}

class TopLeftInAnglePainter implements WallPainter {
  @override
  void paint(Canvas canvas, Size size, BuildContext context) {
    final width = size.width;
    final height = size.height;
    final shadowInset = 1.9;

    // Shadow
    final shadowPaint = Paint()..color = AppColors.wallShadow(context);
    final shadowPath = Path()
      ..moveTo(width - shadowInset, height * 0.82)
      ..lineTo(width * 0.68, height * 0.82)
      ..quadraticBezierTo(
        width * 0.58,
        height * 0.82,
        width * 0.5,
        height,
      )
      ..lineTo(width * 0.5, height * 0.83)
      ..quadraticBezierTo(
        width * 0.5,
        height * 0.73,
        width * 0.68,
        height * 0.65,
      )
      ..lineTo(width - shadowInset, height * 0.65)
      ..close();
    canvas.drawPath(shadowPath, shadowPaint);

    // Middle part
    final accentPaint = Paint()..color = AppColors.wallAccent(context);
    final middlePath = Path()
      ..moveTo(width, height * 0.67)
      ..lineTo(width * 0.68, height * 0.67)
      ..quadraticBezierTo(
        width * 0.58,
        height * 0.67,
        width * 0.5,
        height * 0.85,
      )
      ..lineTo(width * 0.5, height * 0.68)
      ..quadraticBezierTo(
        width * 0.5,
        height * 0.58,
        width * 0.68,
        height * 0.5,
      )
      ..lineTo(width, height * 0.5)
      ..close();
    canvas.drawPath(middlePath, accentPaint);

    // Main part
    final lightPaint = Paint()..color = AppColors.wallLight(context);
    final mainPath = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(width, height * 0.5)
      ..lineTo(width * 0.68, height * 0.5)
      ..quadraticBezierTo(
        width * 0.58,
        height * 0.5,
        width * 0.5,
        height * 0.68,
      )
      ..lineTo(width * 0.5, height)
      ..lineTo(0, height)
      ..close();
    canvas.drawPath(mainPath, lightPaint);
  }
}

class DownLeftInAnglePainter implements WallPainter {
  @override
  void paint(Canvas canvas, Size size, BuildContext context) {
    final width = size.width;
    final height = size.height;

    final lightPaint = Paint()..color = AppColors.wallLight(context);
    final path = Path()
      ..moveTo(0, height)
      ..lineTo(0, 0)
      ..lineTo(width * 0.5, 0)
      ..lineTo(width * 0.5, height * 0.32)
      ..quadraticBezierTo(
        width * 0.5,
        height * 0.419,
        width * 0.68,
        height * 0.5,
      )
      ..lineTo(width, height * 0.5)
      ..lineTo(width, height)
      ..close();
    canvas.drawPath(path, lightPaint);
  }
}

class DownRightOutAnglePainter implements WallPainter {
  @override
  void paint(Canvas canvas, Size size, BuildContext context) {
    final width = size.width;
    final height = size.height;

    final lightPaint = Paint()..color = AppColors.wallLight(context);
    final path = Path()
      ..moveTo(width * 0.5, height)
      ..lineTo(width * 0.5, height * 0.68)
      ..quadraticBezierTo(
        width * 0.5,
        height * 0.58,
        width * 0.68,
        height * 0.5,
      )
      ..lineTo(width, height * 0.5)
      ..lineTo(width, height)
      ..close();
    canvas.drawPath(path, lightPaint);
  }
}

class LeftBridgeWOTShadowPainter implements WallPainter {
  @override
  void paint(Canvas canvas, Size size, BuildContext context) {
    final width = size.width;
    final height = size.height;

    // Middle part
    final accentPaint = Paint()..color = AppColors.wallAccent(context);
    final middlePath = Path()
      ..moveTo(width, height * 0.67)
      ..lineTo(width * 0.68, height * 0.67)
      ..quadraticBezierTo(
        width * 0.58,
        height * 0.67,
        width * 0.5,
        height * 0.85,
      )
      ..lineTo(width * 0.5, height * 0.68)
      ..quadraticBezierTo(
        width * 0.5,
        height * 0.58,
        width * 0.68,
        height * 0.5,
      )
      ..lineTo(width, height * 0.5)
      ..close();
    canvas.drawPath(middlePath, accentPaint);

    // Main part
    final lightPaint = Paint()..color = AppColors.wallLight(context);
    final mainPath = Path()
      ..moveTo(width, height * 0.5)
      ..lineTo(width * 0.68, height * 0.5)
      ..quadraticBezierTo(
        width * 0.58,
        height * 0.5,
        width * 0.5,
        height * 0.68,
      )
      ..lineTo(width * 0.5, height)
      ..lineTo(0, height)
      ..lineTo(0, height * 0.5)
      ..lineTo(width * 0.32, height * 0.5)
      ..quadraticBezierTo(
        width * 0.419,
        height * 0.5,
        width * 0.5,
        height * 0.32,
      )
      ..lineTo(width * 0.5, 0)
      ..lineTo(width, 0)
      ..close();
    canvas.drawPath(mainPath, lightPaint);
  }
}

class LeftBridgeShadowPainter implements WallPainter {
  @override
  void paint(Canvas canvas, Size size, BuildContext context) {
    final width = size.width;
    final height = size.height;
    final shadowInset = 1.9;

    final shadowPaint = Paint()..color = AppColors.wallShadow(context);
    final shadowPath = Path()
      ..moveTo(width - shadowInset, height * 0.82)
      ..lineTo(width * 0.68, height * 0.82)
      ..quadraticBezierTo(
        width * 0.58,
        height * 0.82,
        width * 0.5,
        height,
      )
      ..lineTo(width * 0.5, height * 0.83)
      ..quadraticBezierTo(
        width * 0.5,
        height * 0.73,
        width * 0.68,
        height * 0.65,
      )
      ..lineTo(width - shadowInset, height * 0.65)
      ..close();
    canvas.drawPath(shadowPath, shadowPaint);
  }
}

WallPainter? getWallPainter(WallType type) {
  switch (type) {
    case WallType.L:
    case WallType.R:
      return LeftWallPainter();
    case WallType.T:
      return TopWallPainter();
    case WallType.D:
      return DownWallPainter();
    case WallType.LIT:
    case WallType.RIT:
      return TopLeftInAnglePainter();
    case WallType.LOT:
    case WallType.ROT:
      return TopLeftOutAnglePainter();
    case WallType.LID:
    case WallType.RID:
      return DownLeftInAnglePainter();
    case WallType.LOD:
    case WallType.ROD:
      return DownRightOutAnglePainter();
    case WallType.B:
      return BlockPainter();
    case WallType.LB:
    case WallType.RB:
      return LeftBridgeWOTShadowPainter();
    default:
      return null;
  }
}
