import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class MyGame extends FlameGame with TapCallbacks {
  static const cameraWidth = 600.0;
  static const cameraHeight = 1000.0;

  late Player myPlayer;

  MyGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: cameraWidth,
            height: cameraHeight,
          ),
        );

  @override
  Color backgroundColor() {
    return Colors.blueGrey;
  }

  @override
  void onGameResize(Vector2 size) {
    // TODO: implement onGameResize
    super.onGameResize(size);
    print(size);
  }

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
    myPlayer = Player();
    world.add(Ground(position: Vector2(0, 400)));
    world.add(myPlayer);
    world.add(RectangleComponent(position: Vector2(-100, -100), size: Vector2.all(20)));
    world.add(RectangleComponent(position: Vector2(-200, 0), size: Vector2.all(20)));
    world.add(RectangleComponent(position: Vector2(-300, 100), size: Vector2.all(20)));
  }

  @override
  void update(double dt) {
    // TODO: implement update
    final camCenterY = camera.viewfinder.position.y;
    final camBottomY = camCenterY + cameraHeight / 4;
    final camTopY = camCenterY - cameraHeight / 4;

    final playerY = myPlayer.position.y;

    if (playerY < camCenterY) {
      camera.viewfinder.position = Vector2(0, playerY);
    }

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // TODO: implement onTapDown
    myPlayer.jump();
    super.onTapDown(event);
  }
}
