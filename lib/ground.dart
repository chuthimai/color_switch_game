import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ground extends PositionComponent {
  static const String keyName = 'single_ground_key';
  late Sprite fingerSprite;

  Ground({required super.position})
      : super(
          size: Vector2(200, 2),
          anchor: Anchor.center,
          key: ComponentKey.named(keyName),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    fingerSprite = await Sprite.load('finger_tap.png');

    // TODO: Cách 1: Chèn SpriteComponent với add
    // add(SpriteComponent(
    //   sprite: fingerSprite,
    //   size: Vector2(100, 100),
    // ));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // canvas.drawRect(
    //   Rect.fromLTRB(0, 0, width, height),
    //   Paint()..color = Colors.white,
    // );

    // TODO: Cách 2: Chèn SpriteComponent với render
    fingerSprite.render(
      canvas,
      position: Vector2(55, 0),
      size: Vector2(100, 100),
    );
  }
}
