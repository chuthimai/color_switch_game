import 'dart:math';

import 'package:color_switch_game/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ColorSwitcher extends PositionComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final double radius;

  ColorSwitcher({
    required super.position,
    this.radius = 20.0,
  }) : super(
          anchor: Anchor.center,
          size: Vector2.all(radius * 2),
        );

  @override
  void onLoad() {
    super.onLoad();
    // CollisionType.active = chủ động phát hiện va chạm với component khác
    // CollisionType.passive = bị component khác va chạm
    // CollisionType.inactive = vô hiệu hoá khi va chạm
    add(CircleHitbox(
      position: Vector2.all(radius),
      radius: radius,
      anchor: anchor,
      collisionType: CollisionType.passive,
    ));
  }

  @override
  void render(Canvas canvas) {
    final totalColors = gameRef.gameColors.length;
    final sweepAngle = (pi * 2) / (totalColors - 1);

    for (int i = 0; i < totalColors - 1; i++) {
      canvas.drawArc(
        size.toRect(),
        i * sweepAngle,
        sweepAngle,
        true,
        Paint()..color = gameRef.gameColors[i],
      );
    }
  }
}
