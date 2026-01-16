import 'package:color_switch_game/circle_arc.dart';
import 'package:color_switch_game/color_switcher.dart';
import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/my_game.dart';
import 'package:color_switch_game/star_component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';


class Player extends PositionComponent with HasGameRef<MyGame>, CollisionCallbacks {
  final Vector2 _velocity = Vector2.zero();
  Color _color = Colors.white;
  late final List<Color> colors;
  final _gravity = 980.0;
  final _jumpSpeed = 350.0;
  final _playerRadius = 15.0;
  bool _dead = false;

  final _paint = Paint();

  Player({required super.position}): super(
    priority: 20,
  );

  @override
  Future<void> onLoad() async {
    // TODO: Tuỳ vao game mà có thể tạo HitBox cho từng phần
    add(CircleHitbox(
      radius: _playerRadius,
      anchor: anchor,
      collisionType: CollisionType.active,
    ));
    return super.onLoad();
  }

  @override
  void onMount() {
    colors = gameRef.gameColors.getRange(0, 4).toList();
    size = Vector2.all(_playerRadius * 2);
    anchor = Anchor.center;
    super.onMount();
  }

  @override
  void update(double dt) {
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
    super.render(canvas);
    canvas.drawCircle(
      (size/2).toOffset(),
      _playerRadius,
      _paint..color = _color,
    );
  }

  void jump() {
    _velocity.y = - _jumpSpeed;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (_dead) return;
    super.onCollision(intersectionPoints, other);
    if (other is ColorSwitcher) {
      other.onRemove();
      _changeColorRandomly();
    }
    // TODO: Chỗ này có thể xảy ra player chạm vào 2 component 1
    //  => onCollision gọi 2 lần trong 1 frame
    if (other is CircleArc) {
      if (other.color == _color) return;
      _dead = true;
      gameRef.gameOver();
      return;
    }

    if (other is StarComponent) {
      other.showCollectEffect();
      gameRef.increaseScore();
      FlameAudio.play('collect.wav');
      other.onRemove();
      gameRef.addCircleRotator();
    }

  }

  void _changeColorRandomly() {
    _color = colors.random();
  }
}
