import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';

import '../circle.dart';
import '../circle_rotator.dart';
import '../multi_circle_rotator.dart';

class CircleRotatorPool {
  late Queue<Circle> circles = Queue<Circle>.from([]);
  List<Circle> usingCircles = [];

  CircleRotatorPool() {
    _initPool();
  }

  void _initPool() {
    final random = Random();
    for (int i = 0; i < 6; i++) {
      final speed = random.nextDouble();
      circles.add(
        MultiCircleRotator(
          position: Vector2(0, -i * 400),
          radius: random.nextInt(20) + 90,
          rotationSpeed: speed < 0.5 ? 1.0 : speed * 2,
          numberCircle: random.nextInt(1) + 1,
        ),
      );
    }
  }

  Circle? provide() {
    if (circles.isEmpty) return null;
    final Circle providedCircle = circles.removeFirst();
    usingCircles.add(providedCircle);
    return providedCircle;
  }

  void offer() {
    if (usingCircles.isEmpty) {
      return;
    }

    final circle = usingCircles.removeAt(0);
    late final Vector2 newPosition;
    if (!(circle is CircleRotator || circle is MultiCircleRotator)) return;
    newPosition = circle.position + Vector2(0, -400 * 6);
    usingCircles.add(circle.updatePosition(newPosition: newPosition));
  }

  void resetPool() {
    // Tạo snapshot để tránh concurrent modification
    final snapshot = List<Circle>.from(circles);

    for (final circle in snapshot) {
      if (circle is CircleRotator) {
        circle.removeFromParent();
      } else if (circle is MultiCircleRotator) {
        circle.removeFromParent();
      }
    }

    circles.clear();
    _initPool();
  }
}
