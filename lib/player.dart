import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/my_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';


class Player extends PositionComponent with HasGameRef<MyGame> {
  final Vector2 _velocity = Vector2.zero();
  final _gravity = 980.0;
  final _jumpSpeed = 350.0;
  final _playerRadius = 15.0;

  Player({required super.position});

  @override
  void onMount() {
    // TODO: implement onMount
    size = Vector2.all(_playerRadius * 2);
    anchor = Anchor.center;
    super.onMount();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    position += _velocity * dt;

    // do Ground đc add vào MyGame nên mới tìm đc
    // và do đc thêm khi đã chắc chắn có onMount() nên ko null
    Ground ground = gameRef.findByKeyName(Ground.keyName)!;
    if (positionOfAnchor(Anchor.bottomCenter).y > ground.position.y) {
      _velocity.setZero();
      position.y = ground.position.y - (size.y / 2);
    } else {
      _velocity.y += _gravity * dt;
    }
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
