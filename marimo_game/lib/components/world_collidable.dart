
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class WorldCollidable extends PositionComponent
    with HasGameRef{

  WorldCollidable() {
    add(RectangleComponent());
  }
}
