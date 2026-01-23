import 'package:flutter/material.dart';
import 'app_theme.dart';

// Painter для сетки
class GridPainter extends CustomPainter {
  final int gridWidth;
  final int gridHeight;
  final double cellSize;
  final AppTheme theme;

  GridPainter({required this.gridWidth, required this.gridHeight, required this.cellSize, AppTheme? theme}) : theme = theme ?? AppTheme.light();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.gridLine
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Вертикальные линии
    for (int i = 0; i <= gridWidth; i++) {
      final x = i * cellSize;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Горизонтальные линии
    for (int i = 0; i <= gridHeight; i++) {
      final y = i * cellSize;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return gridWidth != oldDelegate.gridWidth || gridHeight != oldDelegate.gridHeight || cellSize != oldDelegate.cellSize || theme != oldDelegate.theme;
  }
}
