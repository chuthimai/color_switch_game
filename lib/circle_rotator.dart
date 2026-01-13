import 'dart:math';

import 'package:color_switch_game/my_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'circle_arc.dart';

class CircleRotator extends PositionComponent with HasGameRef<MyGame> {
  final double thickness;
  final double rotationSpeed;
  final double radius;

  CircleRotator({
    required super.position,
    required this.radius,
    this.thickness = 8.0,
    this.rotationSpeed = 1.0,
  })  :super(anchor: Anchor.center) {
    size = Vector2.all(radius * 2);
  }

  @override
  void onLoad() {
    const circle = pi * 2;
    double startAngle = 0;
    final rand = Random();
    // final numbers = [1/2, 1/8, 1/3, 1/4];
    final numbers = [1/4];

    for (int i = 0; i < gameRef.gameColors.length - 1; i++) {
      if (startAngle == circle) break;

      double sweepAngle = circle * numbers[rand.nextInt(numbers.length)];
      if (sweepAngle + startAngle > circle) sweepAngle = circle - startAngle;
      add(CircleArc(
        color: gameRef.gameColors[i],
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        precision: (sweepAngle / circle * 24 + 2).toInt(),
      ));

      startAngle += sweepAngle;
    }

    if (startAngle < circle) {
      add(CircleArc(
        color: gameRef.gameColors[4],
        startAngle: startAngle,
        sweepAngle: circle - startAngle,
      ));
    }

    add(RotateEffect.to(circle, EffectController(
      speed: rotationSpeed,
      infinite: true,
    )));

  }

  @override
  void update(double dt) {
    // TODO: Có thể thay thế RotateEffect
    // angle += 0.01;
    super.update(dt);
  }
}
