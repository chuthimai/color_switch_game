import 'dart:collection';

import 'package:flame/components.dart';

import '../star_component.dart';

class StarComponentPool {
  late Queue<StarComponent> stars;


  StarComponentPool() {
    _initPool();
  }

  void _initPool() {
    stars = Queue<StarComponent>.from([
      StarComponent(
        position: Vector2(0, 0),
      ),
      StarComponent(
        position: Vector2(0, -400),
      ),
      StarComponent(
        position: Vector2(0, -800),
      )
    ]);
  }

  StarComponent? provide() {
    return stars.isEmpty ? null : stars.removeFirst();
  }

  void offer(StarComponent star) {
    final newPosition = star.position + Vector2(0, -1200);
    stars.add(star.updatePosition(newPosition: newPosition));
  }

  void resetPool() {
    final snapshot = List<StarComponent>.from(stars);
    for (StarComponent star in snapshot) {
      star.removeFromParent();
    }

    stars.clear();
    _initPool();
  }
}