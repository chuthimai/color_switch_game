import 'dart:math';

import 'package:color_switch_game/my_game.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class CircleRotator extends PositionComponent with HasGameRef<MyGame> {
  final double thickness;

  CircleRotator({
    required super.position,
    required super.size,
    this.thickness = 20.0,
  })  : assert(size!.x == size.y),
        // chỉ chấp nhận size là hình vuông (width = height) nếu không → crash
        super(anchor: Anchor.center);

  @override
  void onLoad() {
    const circle = pi * 2;
    double startAngle = 0;
    final rand = Random();
    final numbers = [1/2, 1/8, 1/3, 1/4];

    for (int i = 0; i < gameRef.gameColors.length - 1; i++) {
      if (startAngle == circle) break;

      double sweepAngle = circle * numbers[rand.nextInt(numbers.length)];
      if (sweepAngle + startAngle > circle) sweepAngle = circle - startAngle;
      add(CircleArc(
        color: gameRef.gameColors[i],
        startAngle: startAngle,
        sweepAngle: sweepAngle,
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

  }

  @override
  void render(Canvas canvas) {
    final radius = (size.x / 2) - (thickness / 2);

    // canvas.drawCircle(
    //   (size / 2).toOffset(),
    //   radius,
    //   Paint()..color = Colors.blueAccent
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = thickness,
    // );
    super.render(canvas);
  }
}

class CircleArc extends PositionComponent with ParentIsA<CircleRotator> {
  final Color color;
  final double startAngle;
  final double sweepAngle;

  CircleArc({
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
  });

  @override
  void onMount() {
    size = parent.size;
    position = parent.position;
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawArc(
      size.toRect(),
      startAngle,
      sweepAngle,
      false,
      // true hiển thị cả đường bán kính, false là ko hiển thị đường bán kính
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = parent.thickness,
    );
  }
}
