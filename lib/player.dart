import 'package:flame/components.dart';
import 'package:flutter/material.dart';


class Player extends PositionComponent{
  final Vector2 _velocity = Vector2.zero();
  final _gravity = 980.0;
  final _jumpSpeed = 350.0;
  final _playerRadius = 15.0;

  @override
  void onMount() {
    // TODO: implement onMount
    position = Vector2.zero();
    size = Vector2.all(_playerRadius * 2);
    anchor = Anchor.center;
    debugMode = true;
    super.onMount();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    position += _velocity * dt;
    _velocity.y += _gravity * dt;
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);
    canvas.drawCircle(
      (size/2).toOffset(),
      _playerRadius,
      Paint()..color = Colors.white,
    );
  }

  void jump() {
    _velocity.y = - _jumpSpeed;
  }
}
