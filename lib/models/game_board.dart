import 'wall_type.dart';

class GameBoard {
  final List<List<WallType>> grid;
  final int width;
  final int height;

  GameBoard._(this.grid, this.width, this.height);

  static GameBoard? fromTextLayout(List<String> textLayout) {
    if (textLayout.isEmpty) return null;

    final cleanedLayout = textLayout.map((row) {
      return row.split(' ').where((s) => s.isNotEmpty).join(' ');
    }).toList();

    final grid = <List<WallType>>[];

    for (int row = 0; row < cleanedLayout.length; row++) {
      final symbols = cleanedLayout[row].split(' ').toList();
      final rowWalls = <WallType>[];

      for (int col = 0; col < symbols.length; col++) {
        final symbol = symbols[col].trim();
        final wallType = WallTypeStatic.fromString(symbol);
        rowWalls.add(wallType);

        if (wallType == WallType.N && symbol != 'N') {
          print('⚠️ Unknown symbol "$symbol" at [$row, $col]');
        }
      }

      grid.add(rowWalls);
    }

    final width = cleanedLayout.isNotEmpty ? cleanedLayout[0].split(' ').length : 0;
    final height = cleanedLayout.length;

    return GameBoard._(grid, width, height);
  }

  WallType getWallType(int col, int row) {
    if (row < 0 || row >= height || col < 0 || col >= width) {
      return WallType.N;
    }
    return grid[row][col];
  }

  void printGrid() {
    for (int row = 0; row < height; row++) {
      final rowString = grid[row].map((type) {
        switch (type) {
          case WallType.L:
            return 'L';
          case WallType.R:
            return 'R';
          case WallType.T:
            return 'T';
          case WallType.D:
            return 'D';
          case WallType.LIT:
            return 'LIT';
          case WallType.RIT:
            return 'RIT';
          case WallType.LOT:
            return 'LOT';
          case WallType.ROT:
            return 'ROT';
          case WallType.LID:
            return 'LID';
          case WallType.RID:
            return 'RID';
          case WallType.LOD:
            return 'LOD';
          case WallType.ROD:
            return 'ROD';
          case WallType.B:
            return 'B';
          case WallType.LB:
            return 'LB';
          case WallType.RB:
            return 'RB';
          case WallType.N:
            return 'N';
        }
      }).join(' ');
      print(rowString);
    }
  }
}
