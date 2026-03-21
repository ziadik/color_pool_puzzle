import '../models/item.dart';
import '../models/level.dart';

class FieldEngine {
  late List<List<Item?>> field;
  final Level level;
  int _ballsCount;
  int _movesCount = 0;
  bool _lastMoveWasHitHole = false;
  List<List<List<Item?>>> _history = [];

  FieldEngine({required this.level})
      : field = level.initialField.map((row) => row.map((item) => item?.copy()).toList()).toList(),
        _ballsCount = level.countBalls();

  int get ballsCount => _ballsCount;
  int get movesCount => _movesCount;
  bool get lastMoveWasHitHole => _lastMoveWasHitHole;
  bool isWin() => _ballsCount == 0;

  void _saveState() {
    final snapshot = field.map((row) => row.map((item) => item?.copy()).toList()).toList();
    _history.add(snapshot);
  }

  bool undo() {
    if (_history.isEmpty) return false;
    field = _history.removeLast();
    _ballsCount = _countBalls();
    if (_movesCount > 0) _movesCount--;
    return true;
  }

  int _countBalls() {
    int count = 0;
    for (var row in field) {
      for (var item in row) {
        if (item is Ball) count++;
      }
    }
    return count;
  }

  bool isValidCoord(int x, int y) {
    return x >= 0 && y >= 0 && y < field.length && x < field[0].length;
  }

  (int, int) getNextCoord(int x, int y, Direction direction) {
    switch (direction) {
      case Direction.up:
        return (x, y - 1);
      case Direction.down:
        return (x, y + 1);
      case Direction.left:
        return (x - 1, y);
      case Direction.right:
        return (x + 1, y);
      default:
        return (x, y);
    }
  }

  bool makeTurn(int x, int y, Direction direction) {
    // Check if there's a ball at the starting position
    final ball = field[y][x];
    if (ball is! Ball) return false;

    _saveState();

    int currentX = x;
    int currentY = y;
    bool hitHole = false;

    while (true) {
      final (nextX, nextY) = getNextCoord(currentX, currentY, direction);

      if (!isValidCoord(nextX, nextY)) break;

      final nextItem = field[nextY][nextX];

      if (nextItem == null) {
        // Empty cell - continue moving
        currentX = nextX;
        currentY = nextY;
      } else if (nextItem is Hole && nextItem.color == ball.color) {
        // Found matching hole
        hitHole = true;
        break;
      } else {
        // Obstacle (block, other ball, or wrong color hole)
        break;
      }
    }

    // No movement
    if (currentX == x && currentY == y && !hitHole) {
      _lastMoveWasHitHole = false;
      return false;
    }

    if (hitHole) {
      // Ball falls into hole - remove ball only
      field[y][x] = null;
      _ballsCount--;
      _lastMoveWasHitHole = true;
    } else {
      // Move ball to the last empty cell
      field[currentY][currentX] = field[y][x];
      field[y][x] = null;
      _lastMoveWasHitHole = false;
    }

    _movesCount++;
    return true;
  }

  (int, int, Direction)? getHint() {
    // Check all balls
    for (int y = 0; y < field.length; y++) {
      for (int x = 0; x < field[y].length; x++) {
        final item = field[y][x];
        if (item is Ball) {
          // Check all directions
          for (var direction in Direction.values) {
            if (canMoveInAnyWay(x, y, direction)) {
              // Check if it leads to a hole
              if (leadsToHole(x, y, direction)) {
                return (x, y, direction);
              }
            }
          }
        }
      }
    }

    // Return first possible move if no direct hole
    for (int y = 0; y < field.length; y++) {
      for (int x = 0; x < field[y].length; x++) {
        final item = field[y][x];
        if (item is Ball) {
          for (var direction in Direction.values) {
            if (canMoveInAnyWay(x, y, direction)) {
              return (x, y, direction);
            }
          }
        }
      }
    }

    return null;
  }

  bool canMoveInAnyWay(int x, int y, Direction direction) {
    final (nextX, nextY) = getNextCoord(x, y, direction);
    if (!isValidCoord(nextX, nextY)) return false;

    final nextItem = field[nextY][nextX];

    // Can move if cell is empty
    if (nextItem == null) return true;

    // Can move if it's a hole (color will be checked later)
    if (nextItem is Hole) return true;

    return false;
  }

  bool leadsToHole(int x, int y, Direction direction) {
    final ball = field[y][x];
    if (ball is! Ball) return false;

    int currentX = x;
    int currentY = y;

    while (true) {
      final (nextX, nextY) = getNextCoord(currentX, currentY, direction);
      if (!isValidCoord(nextX, nextY)) return false;

      final nextItem = field[nextY][nextX];

      if (nextItem is Hole) {
        return nextItem.color == ball.color;
      }

      if (nextItem != null) return false;

      currentX = nextX;
      currentY = nextY;
    }
  }
}

enum Direction {
  left,
  right,
  up,
  down,
  nowhere,
}
