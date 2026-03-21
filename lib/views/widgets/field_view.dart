import 'package:color_pool_puzzle/controllers/level_manager.dart';
import 'package:color_pool_puzzle/models/game_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../../controllers/field_engine.dart';
import '../../models/wall_type.dart';
import '../../utils/level_maps.dart';
import 'wall_painter.dart';
import '../../utils/app_colors.dart';
import '../../models/item.dart';
import '../../models/game_color.dart';

class FieldView extends StatefulWidget {
  final FieldEngine engine;
  final VoidCallback onMove;

  const FieldView({
    super.key,
    required this.engine,
    required this.onMove,
  });

  @override
  State<FieldView> createState() => _FieldViewState();
}

class _FieldViewState extends State<FieldView> {
  double _elementSize = 0;
  Offset? _touchStart;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rows = widget.engine.field.length;
        final cols = widget.engine.field[0].length;
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        _elementSize = (availableWidth / cols).clamp(
          0.0,
          availableHeight / rows,
        );

        final totalWidth = _elementSize * cols;
        final totalHeight = _elementSize * rows;

        return GestureDetector(
          onPanStart: (details) {
            _touchStart = details.localPosition;
          },
          onPanEnd: (details) {
            if (_touchStart == null) return;

            final end = details.localPosition;
            final dx = end.dx - _touchStart!.dx;
            final dy = end.dy - _touchStart!.dy;

            final threshold = _elementSize / 2;
            final distance = vector.Vector2(dx, dy).length;

            if (distance < threshold) return;

            Direction direction;
            if (dx.abs() > dy.abs()) {
              direction = dx > 0 ? Direction.right : Direction.left;
            } else {
              direction = dy > 0 ? Direction.down : Direction.up;
            }

            final offsetX = (constraints.maxWidth - totalWidth) / 2;
            final offsetY = (constraints.maxHeight - totalHeight) / 2;

            final adjustedX = _touchStart!.dx - offsetX;
            final adjustedY = _touchStart!.dy - offsetY;

            final col = (adjustedX / _elementSize).floor();
            final row = (adjustedY / _elementSize).floor();

            if (row >= 0 && row < rows && col >= 0 && col < cols) {
              final success = widget.engine.makeTurn(col, row, direction);
              if (success) {
                widget.onMove();
                setState(() {});
              }
            }

            _touchStart = null;
          },
          child: Container(
            width: totalWidth,
            height: totalHeight,
            decoration: BoxDecoration(
              color: AppColors.fieldBackground(context),
            ),
            child: Stack(
              children: [
                // Grid
                CustomPaint(
                  size: Size(totalWidth, totalHeight),
                  painter: GridPainter(
                    cols: cols,
                    rows: rows,
                    cellSize: _elementSize,
                    gridColor: AppColors.gridColor(context),
                  ),
                ),
                // Holes
                ..._buildHoles(rows, cols, totalWidth, totalHeight),
                // Bottom walls
                ..._buildWalls(
                  rows,
                  cols,
                  totalWidth,
                  totalHeight,
                  isBottom: true,
                ),
                // Balls
                ..._buildBalls(rows, cols, totalWidth, totalHeight),
                // Top walls
                ..._buildWalls(
                  rows,
                  cols,
                  totalWidth,
                  totalHeight,
                  isBottom: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildBalls(int rows, int cols, double totalWidth, double totalHeight) {
    final widgets = <Widget>[];
    final wallOffsetX = _elementSize / 1.95;
    final wallOffsetY = _elementSize / 1.44;
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final item = widget.engine.field[row][col];
        if (item is Ball) {
          widgets.add(
            Positioned(
              left: col * _elementSize + wallOffsetX,
              top: row * _elementSize + wallOffsetY,
              child: SizedBox(
                width: _elementSize,
                height: _elementSize,
                child: CustomPaint(
                  painter: BallPainter(
                    color: item.color!.toColor(),
                    padding: 2,
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }

  List<Widget> _buildHoles(int rows, int cols, double totalWidth, double totalHeight) {
    final widgets = <Widget>[];
    final wallOffsetX = _elementSize / 1.95;
    final wallOffsetY = _elementSize / 1.44;
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final item = widget.engine.field[row][col];
        if (item is Hole) {
          widgets.add(
            Positioned(
              left: col * _elementSize + wallOffsetX,
              top: row * _elementSize + wallOffsetY,
              child: SizedBox(
                width: _elementSize,
                height: _elementSize,
                child: CustomPaint(
                  painter: HolePainter(
                    color: item.color!.toColor(),
                    padding: 2,
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }

  List<Widget> _buildWalls(int rows, int cols, double totalWidth, double totalHeight, {required bool isBottom}) {
    final widgets = <Widget>[];

    final levelManager = Provider.of<LevelManager>(context, listen: false);
    final levelId = levelManager.currentLevelIndex;
    final cleanedLevel = LevelMaps.getCleanedLevel(levelId);
    final gameBoard = GameBoard.fromTextLayout(cleanedLevel);
    if (gameBoard == null) return widgets;

    final wallOffsetX = 0; //_elementSize / 1.95;
    final wallOffsetY = 0; //_elementSize / 1.44;
    final wallSize = _elementSize + 4;
    final wallOffsetDraw = 0.0;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final wallType = gameBoard.getWallType(col, row);

        if (wallType == WallType.N) continue;

        final shouldDraw = isBottom ? wallType.isFirstLayer : wallType.isSecondLayer;
        if (!shouldDraw) continue;

        final painter = getWallPainter(wallType);
        if (painter == null) continue;

        widgets.add(
          Positioned(
            left: col * _elementSize - wallOffsetX,
            top: row * _elementSize - wallOffsetY,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(wallType.needsFlipX ? -1.0 : 1.0, 1.0),
              child: SizedBox(
                width: wallSize,
                height: wallSize,
                child: CustomPaint(
                  painter: WallCustomPainter(
                    painter: painter,
                    offset: wallOffsetDraw,
                    context: context,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }
}

class GridPainter extends CustomPainter {
  final int cols;
  final int rows;
  final double cellSize;
  final Color gridColor;

  GridPainter({
    required this.cols,
    required this.rows,
    required this.cellSize,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final wallOffsetX = cellSize / 1.95;
    final wallOffsetY = cellSize / 1.44;
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < cols; i++) {
      final x = i * cellSize + wallOffsetX;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (int i = 0; i < rows; i++) {
      final y = i * cellSize + wallOffsetY;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BallPainter extends CustomPainter {
  final Color color;
  final double padding;

  BallPainter({required this.color, required this.padding});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      padding,
      padding,
      size.width - padding * 2,
      size.height - padding * 2,
    );

    final paint = Paint()..color = color;
    canvas.drawOval(rect, paint);

    // Highlight
    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.3);
    final highlightRect = Rect.fromLTWH(
      rect.left + rect.width * 0.2,
      rect.top + rect.height * 0.2,
      rect.width * 0.2,
      rect.height * 0.2,
    );
    canvas.drawOval(highlightRect, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HolePainter extends CustomPainter {
  final Color color;
  final double padding;

  HolePainter({required this.color, required this.padding});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      padding,
      padding,
      size.width - padding * 2,
      size.height - padding * 2,
    );

    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.15)), paint);

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.15)), strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WallCustomPainter extends CustomPainter {
  final WallPainter painter;
  final double offset;
  final BuildContext context;

  WallCustomPainter({
    required this.painter,
    required this.offset,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(offset, offset);
    painter.paint(canvas, size, context);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
