import 'item.dart';

class Level {
  final int width;
  final int height;
  final List<List<Item?>> initialField;

  Level({
    required this.width,
    required this.height,
    required this.initialField,
  });

  int countBalls() {
    int count = 0;
    for (var row in initialField) {
      for (var item in row) {
        if (item is Ball) count++;
      }
    }
    return count;
  }

  Level copy() {
    return Level(
      width: width,
      height: height,
      initialField: initialField.map((row) => row.map((item) => item?.copy()).toList()).toList(),
    );
  }
}
