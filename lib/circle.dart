import 'package:flame/components.dart';

abstract class Circle {
  late Vector2 position;
  Circle updatePosition({required Vector2 newPosition});
}