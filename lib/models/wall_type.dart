enum WallType {
  L, // LeftWall
  R, // RightWall (flipped LeftWall)
  T, // TopWall
  LIT, // TopLeftInAngle
  RIT, // TopRightInAngle (flipped)
  LOT, // TopLeftOutAngle
  ROT, // TopRightOutAngle (flipped)
  D, // DownWall
  LID, // DownLeftInAngle
  RID, // DownRightInAngle (flipped)
  LOD, // DownLeftOutAngle (flipped for LOD)
  ROD, // DownRightOutAngle
  B, // Block
  LB, // LeftBridge
  RB, // RightBridge
  N, // None
}

extension WallTypeExtension on WallType {
  bool get needsFlipX {
    switch (this) {
      case WallType.R:
      case WallType.RIT:
      case WallType.RID:
      case WallType.ROT:
      case WallType.RB:
      case WallType.LOD:
        return true;
      default:
        return false;
    }
  }

  bool get isFirstLayer {
    // Elements that are drawn under balls
    switch (this) {
      case WallType.T:
      case WallType.LIT:
      case WallType.RIT:
      case WallType.LOT:
      case WallType.B:
      case WallType.ROT:
        return true;
      default:
        return false;
    }
  }

  bool get isSecondLayer {
    // Elements that are drawn above balls
    switch (this) {
      case WallType.L:
      case WallType.R:
      case WallType.D:
      case WallType.LID:
      case WallType.RID:
      case WallType.LOD:
      case WallType.ROD:
      case WallType.LB:
      case WallType.RB:
        return true;
      default:
        return false;
    }
  }
}

// Добавляем статический метод fromString
extension WallTypeStatic on WallType {
  static WallType fromString(String value) {
    switch (value) {
      case 'L':
        return WallType.L;
      case 'R':
        return WallType.R;
      case 'T':
        return WallType.T;
      case 'D':
        return WallType.D;
      case 'LIT':
        return WallType.LIT;
      case 'RIT':
        return WallType.RIT;
      case 'LOT':
        return WallType.LOT;
      case 'ROT':
        return WallType.ROT;
      case 'LID':
        return WallType.LID;
      case 'RID':
        return WallType.RID;
      case 'LOD':
        return WallType.LOD;
      case 'ROD':
        return WallType.ROD;
      case 'B':
        return WallType.B;
      case 'LB':
        return WallType.LB;
      case 'RB':
        return WallType.RB;
      default:
        return WallType.N;
    }
  }
}
