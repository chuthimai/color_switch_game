import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'circle_rotator.dart';

class CircleArc extends PositionComponent
    with ParentIsA<CircleRotator>, CollisionCallbacks {
  final Color color;
  final double startAngle;
  final double sweepAngle;
  final int precision;
  final int segments = 20;

  CircleArc({
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
    this.precision = 6,
  }): super(anchor: Anchor.center);

  @override
  void onMount() {
    size = parent.size;
    position = Vector2.all(parent.radius);
    _addHitbox();
    super.onMount();
  }

  void _addHitbox() {
    final points = <Vector2>[];
    final center = Vector2.all(parent.radius);
    final segment = sweepAngle / (precision - 1);
    for (int i = 0; i < precision; i++) {
      final thisSegment = startAngle + segment * i;
      points.add(Vector2(cos(thisSegment), sin(thisSegment)) *
              (parent.radius + parent.thickness / 2) +
          center);
    }

    for (int i = precision - 1; i >= 0; i--) {
      final thisSegment = startAngle + segment * i;
      points.add(Vector2(cos(thisSegment), sin(thisSegment)) *
              (parent.radius - parent.thickness / 2) +
          center);
    }

    add(PolygonHitbox(
      points,
      collisionType: CollisionType.passive,
    ));
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
