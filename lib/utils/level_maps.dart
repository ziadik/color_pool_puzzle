class LevelMaps {
  static const List<List<String>> levels = [
    // Level 0
    [
      "B B B B B B B",
      "B LIT T T T RIT B",
      "B LID D D LOD R B",
      "B B B B L R B",
      "B B B B L R B",
      "B B B B LID RID B",
      "B B B B B B B",
    ],
    // Level 1
    [
      "B B LIT RIT B B B",
      "B LIT LOT ROT T RIT B",
      "B L N N N ROT RIT",
      "B L N N N ROD RID",
      "B LID LOD N N R B",
      "B B LID D D RID B",
      "B B B B B B B",
    ],
    // Level 2
    [
      "B B B B B B B B B B",
      "B B B B B LIT T T RIT B",
      "B B B B LIT LOT N N R B",
      "B B B LIT LOT N N N ROT RIT",
      "B B LIT LOT N N N N ROD RID",
      "B LIT LOT N N N N N R B",
      "B L N N N N N N R B",
      "B L N N N N N N R B",
      "B LID LOD ROD D LOD ROD D RID B",
      "B B LID RID B LID RID B B B",
    ],
    // Add all 40+ levels here...
    // For brevity, I'm showing only first 3 levels.
    // You need to add all levels from the iOS version.
  ];
  
  static int get totalLevels => levels.length;
  
  static String getLevelName(int index) {
    if (index >= 0 && index < totalLevels) {
      return "Уровень ${index + 1}";
    }
    return "Уровень ${index + 1} (недоступен)";
  }
  
  static String sizeInfo(int index) {
    if (index < 0 || index >= totalLevels) return "0×0";
    final width = getWidth(index);
    final height = getHeight(index);
    return "$width×$height";
  }
  
  static int getWidth(int index) {
    if (index < 0 || index >= totalLevels) return 0;
    int maxWidth = 0;
    for (var row in levels[index]) {
      final elements = row.split(' ').where((s) => s.isNotEmpty).length;
      if (elements > maxWidth) maxWidth = elements;
    }
    return maxWidth;
  }
  
  static int getHeight(int index) {
    if (index < 0 || index >= totalLevels) return 0;
    return levels[index].length;
  }
  
  static bool isValidLevel(int index) {
    return index >= 0 && index < totalLevels;
  }
  
  static String cleanLevelLine(String line) {
    final components = line.split(' ').where((s) => s.isNotEmpty).toList();
    final cleaned = components.map((comp) {
      if (int.tryParse(comp) != null) return "N";
      return comp;
    }).join(' ');
    return cleaned;
  }
  
  static List<String> getCleanedLevel(int index) {
    if (index < 0 || index >= levels.length) return [];
    return levels[index].map(cleanLevelLine).toList();
  }
}