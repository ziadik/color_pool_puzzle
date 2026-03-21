import 'package:flutter/material.dart';
import 'game_color.dart';

abstract class Item {
  final GameColor? color;
  
  Item({this.color});
  
  Item copy();
  
  bool get isBall => false;
  bool get isHole => false;
  bool get isBlock => false;
}

class Ball extends Item {
  Ball(GameColor color) : super(color: color);
  
  @override
  Ball copy() => Ball(color!);
  
  @override
  bool get isBall => true;
}

class Hole extends Item {
  Hole(GameColor color) : super(color: color);
  
  @override
  Hole copy() => Hole(color!);
  
  @override
  bool get isHole => true;
}

class Block extends Item {
  Block() : super();
  
  @override
  Block copy() => Block();
  
  @override
  bool get isBlock => true;
}