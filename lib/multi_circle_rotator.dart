import 'package:color_switch_game/circle.dart';
import 'package:flame/components.dart';

import 'circle_rotator.dart';
import 'my_game.dart';

class MultiCircleRotator extends PositionComponent with HasGameRef<MyGame> implements Circle{
  final double thickness;
  final double rotationSpeed;
  final double radius;
  final double distanceBetweenCircles;
  final int numberCircle;

  MultiCircleRotator({
    required super.position,
    required this.radius,
    this.thickness = 8.0,
    this.rotationSpeed = 1.0,
    this.distanceBetweenCircles = 20.0,
    this.numberCircle = 2,
  }): super(anchor: Anchor.center);

  @override
  void onLoad() {
    for (int i=0; i<numberCircle; i++) {
      add(CircleRotator(
          position: Vector2(0, 0),
          radius: radius + i * distanceBetweenCircles,
          thickness: thickness,
          rotationSpeed:rotationSpeed,
      ));
    }
  }

  @override
  void update(double dt) {
    // TODO: Có thể thay thế RotateEffect
    // angle += 0.01;
    super.update(dt);
  }

  @override
  Circle updatePosition({required Vector2 newPosition}) {
    position = newPosition;
    return this;
  }
}