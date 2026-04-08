import 'package:color_pool_puzzle/controllers/level_manager.dart';
import 'package:color_pool_puzzle/controllers/settings_manager.dart';
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
  final GlobalKey _containerKey = GlobalKey();
  double _elementSize = 0;
  Offset? _dragStart;
  Offset? _dragEnd;
  bool _isDragging = false;

  // Смещение для отрисовки элементов (шары, стены)
  double get _wallOffsetX => _elementSize / 1.95;
  double get _wallOffsetY => _elementSize / 1.44;

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

        return Center(
          child: Container(
            key: _containerKey,
            width: totalWidth,
            height: totalHeight,
            // decoration: BoxDecoration(
            //   color: AppColors.fieldBackground(context),
            // ),
            child: Listener(
              onPointerDown: (event) {
                _dragStart = _getRelativePosition(event.localPosition);
                _dragEnd = null;
                _isDragging = false;
              },
              onPointerMove: (event) {
                if (_dragStart != null) {
                  _isDragging = true;
                  _dragEnd = _getRelativePosition(event.localPosition);
                }
              },
              onPointerUp: (event) {
                if (_isDragging && _dragStart != null && _dragEnd != null) {
                  _handleSwipe(_dragStart!, _dragEnd!);
                }
                _dragStart = null;
                _dragEnd = null;
                _isDragging = false;
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      width: totalWidth,
                      height: totalHeight,
                      decoration: BoxDecoration(
                        color: AppColors.fieldBackground(context),
                      ),
                    ),
                  ),
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
                  ..._buildHoles(rows, cols),
                  // Bottom walls
                  ..._buildWalls(
                    rows,
                    cols,
                    isBottom: true,
                  ),
                  ..._buildShadowWalls(
                    rows,
                    cols,
                    isBottom: true,
                  ),
                  // Balls
                  ..._buildBalls(rows, cols),
                  // Top walls
                  ..._buildWalls(
                    rows,
                    cols,
                    isBottom: false,
                  ),
                  ..._buildHolesTop(rows, cols),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Offset _getRelativePosition(Offset localPosition) {
    // Получаем позицию контейнера
    final RenderBox? renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return localPosition;

    return Offset(
      localPosition.dx,
      localPosition.dy,
    );
  }

  // Определяем ячейку по позиции, учитывая смещение для шаров
  (int row, int col)? _getCellFromPosition(Offset position) {
    final rows = widget.engine.field.length;
    final cols = widget.engine.field[0].length;

    // Корректируем позицию, вычитая смещение, так как шары и стены рисуются со смещением
    // Пользователь свайпает по шару, который находится со смещением
    final adjustedX = position.dx - _wallOffsetX;
    final adjustedY = position.dy - _wallOffsetY;

    // Проверяем, что позиция внутри поля
    if (adjustedX < 0 ||
        adjustedX > _elementSize * cols ||
        adjustedY < 0 ||
        adjustedY > _elementSize * rows) {
      return null;
    }

    // Вычисляем координаты ячейки
    final col = (adjustedX / _elementSize).floor();
    final row = (adjustedY / _elementSize).floor();

    // Проверяем границы
    if (row >= 0 && row < rows && col >= 0 && col < cols) {
      return (row, col);
    }

    return null;
  }

  void _handleSwipe(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    // Минимальное расстояние для определения свайпа
    final minDistance = _elementSize / 3;
    final distance = vector.Vector2(dx, dy).length;

    if (distance < minDistance) return;

    // Определяем направление
    Direction direction;
    if (dx.abs() > dy.abs()) {
      direction = dx > 0 ? Direction.right : Direction.left;
    } else {
      direction = dy > 0 ? Direction.down : Direction.up;
    }

    // Получаем координаты ячейки, где начался свайп (с учетом смещения)
    final cell = _getCellFromPosition(start);
    if (cell == null) {
      print('Cell not found at position: $start');
      return;
    }

    final (row, col) = cell;
    final rows = widget.engine.field.length;
    final cols = widget.engine.field[0].length;

    print('=== Swipe Debug ===');
    print('Start: $start, End: $end');
    print(
        'Adjusted start: (${start.dx - _wallOffsetX}, ${start.dy - _wallOffsetY})');
    print('Direction: $direction');
    print('Cell: ($col, $row)');
    print('Element size: $_elementSize');
    print('Wall offset: ($_wallOffsetX, $_wallOffsetY)');

    if (row >= 0 && row < rows && col >= 0 && col < cols) {
      final success = widget.engine.makeTurn(col, row, direction);
      if (success) {
        widget.onMove();
        setState(() {});
      } else {
        _showInvalidMoveFeedback();
      }
    } else {
      print('Cell out of bounds!');
      _showInvalidMoveFeedback();
    }
  }

  void _showInvalidMoveFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Невозможно переместить шар в этом направлении'),
        duration: Duration(milliseconds: 500),
        backgroundColor: Colors.red,
      ),
    );
  }

  List<Widget> _buildBalls(int rows, int cols) {
    final widgets = <Widget>[];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final item = widget.engine.field[row][col];
        if (item is Ball) {
          widgets.add(
            Positioned(
              left: col * _elementSize + _wallOffsetX,
              top: row * _elementSize + _wallOffsetY,
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

  List<Widget> _buildHoles(int rows, int cols) {
    final settings = Provider.of<SettingsManager>(context, listen: false);
    final widgets = <Widget>[];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final item = widget.engine.field[row][col];
        if (item is Hole) {
          if (settings.holes3DEnabled) {
            // Объемные отверстия - нижняя часть
            widgets.add(
              Positioned(
                left: col * _elementSize + _wallOffsetX + 1,
                top: row * _elementSize + _wallOffsetY,
                child: SizedBox(
                  width: _elementSize,
                  height: _elementSize,
                  child: CustomPaint(
                    painter: HoleBottomPainter(
                      color: item.color!.toColor(),
                      padding: 0,
                    ),
                  ),
                ),
              ),
            );
          } else {
            widgets.add(
              Positioned(
                left: col * _elementSize + _wallOffsetX,
                top: row * _elementSize + _wallOffsetY,
                child: SizedBox(
                  width: _elementSize,
                  height: _elementSize,
                  child: CustomPaint(
                    painter: HolePainter(
                        color: item.color!.toColor(),
                        padding: 2.7,
                        isFlat: true),
                  ),
                ),
              ),
            );
          }
        }
      }
    }

    return widgets;
  }

  List<Widget> _buildHolesTop(int rows, int cols) {
    final settings = Provider.of<SettingsManager>(context, listen: false);
    final widgets = <Widget>[];

    // Только для объемных отверстий добавляем верхнюю часть
    if (!settings.holes3DEnabled) return widgets;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final item = widget.engine.field[row][col];
        if (item is Hole) {
          widgets.add(
            Positioned(
              left: col * _elementSize + _wallOffsetX + 1,
              top: row * _elementSize + (_wallOffsetY / 1.33),
              child: SizedBox(
                width: _elementSize,
                height: _elementSize,
                child: CustomPaint(
                  painter: HolePainter(
                    color: item.color!.toColor(),
                    padding: 0,
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

  List<Widget> _buildWalls(
    int rows,
    int cols, {
    required bool isBottom,
  }) {
    final widgets = <Widget>[];

    final levelManager = Provider.of<LevelManager>(context, listen: false);
    final levelId = levelManager.currentLevelIndex;
    final cleanedLevel = LevelMaps.getCleanedLevel(levelId);
    final gameBoard = GameBoard.fromTextLayout(cleanedLevel);
    if (gameBoard == null) return widgets;

    final wallSize = _elementSize + 4;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final wallType = gameBoard.getWallType(col, row);
        if (wallType == WallType.N) continue;

        final shouldDraw =
            isBottom ? wallType.isFirstLayer : wallType.isSecondLayer;
        if (!shouldDraw) continue;

        final painter = getWallPainter(wallType, context);
        if (painter != null) {
          widgets.add(
            Positioned(
              left: col * _elementSize,
              top: row * _elementSize,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(wallType.needsFlipX ? -1.0 : 1.0, 1.0),
                child: SizedBox(
                  width: wallSize,
                  height: wallSize,
                  child: CustomPaint(
                    painter: painter,
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

  List<Widget> _buildShadowWalls(
    int rows,
    int cols, {
    required bool isBottom,
  }) {
    final widgets = <Widget>[];

    final levelManager = Provider.of<LevelManager>(context, listen: false);
    final levelId = levelManager.currentLevelIndex;
    final cleanedLevel = LevelMaps.getCleanedLevel(levelId);
    final gameBoard = GameBoard.fromTextLayout(cleanedLevel);
    if (gameBoard == null) return widgets;

    final wallSize = _elementSize + 4;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final wallType = gameBoard.getWallType(col, row);
        if (wallType == WallType.N) continue;

        // For bottom layer, also draw bridge shadows

        final shadowPainter = getBridgeShadowPainter(wallType, context);
        if (shadowPainter != null) {
          widgets.add(
            Positioned(
              left: col * _elementSize,
              top: row * _elementSize,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(wallType.needsFlipX ? -1.0 : 1.0, 1.0),
                child: SizedBox(
                  width: wallSize,
                  height: wallSize,
                  child: CustomPaint(
                    painter: shadowPainter,
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
      ..strokeWidth = 2.5
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
  final bool isFlat;
  HolePainter(
      {required this.color, required this.padding, this.isFlat = false});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      padding,
      padding,
      size.width - padding * 2,
      size.height - padding * 2,
    );

    if (isFlat) {
      final paint = Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.15)),
          paint);

      final strokePaint = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.15)),
          strokePaint);
    } else {
      final paint = Paint()
        ..color = color.withOpacity(1)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.15)),
          paint);

      final strokePaint = Paint()
        ..color = Colors.black45
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.15)),
          strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HoleBottomPainter extends CustomPainter {
  final Color color;
  final double padding;

  HoleBottomPainter({required this.color, required this.padding});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      padding,
      padding,
      size.width - padding * 2,
      size.height - padding * 2,
    );

    final paint = Paint()
      ..color = color.withOpacity(1)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.15)),
        paint);

    final strokePaint = Paint()
      ..color = const Color(0xFF645691)
      ..strokeWidth = .5
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.15)),
        strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// class HoleBottomPainter extends CustomPainter {
//   final Color color;
//   final double padding;

//   HoleBottomPainter({required this.color, required this.padding});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTWH(
//       padding,
//       padding,
//       size.width - padding * 2,
//       size.height - padding * 2,
//     );

//     final paint = Paint()
//       ..color = color.withOpacity(0.95)
//       ..style = PaintingStyle.fill;
//     canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.15)), paint);

//     final strokePaint = Paint()
//       ..color = color
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     // Create a path without the top border
//     final path = Path();
//     final rrect = RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.15));

//     // Add the rounded rectangle path but skip the top part
//     final radius = rect.width * 0.15;

//     // Start from bottom-left corner and go clockwise
//     path.moveTo(rect.left, rect.bottom - radius);
//     // Bottom-left corner
//     path.quadraticBezierTo(rect.left, rect.bottom, rect.left + radius, rect.bottom);
//     // Bottom edge
//     path.lineTo(rect.right - radius, rect.bottom);
//     // Bottom-right corner
//     path.quadraticBezierTo(rect.right, rect.bottom, rect.right, rect.bottom - radius);
//     // Right edge
//     path.lineTo(rect.right, rect.top + radius);
//     // Top-right corner
//     path.quadraticBezierTo(rect.right, rect.top, rect.right - radius, rect.top);
//     // Top edge - we skip drawing this
//     path.moveTo(rect.left + radius, rect.top);
//     // Top-left corner
//     path.quadraticBezierTo(rect.left, rect.top, rect.left, rect.top + radius);
//     // Left edge
//     path.lineTo(rect.left, rect.bottom - radius);

//     canvas.drawPath(path, strokePaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
