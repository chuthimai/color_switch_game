import 'package:color_switch_game/circle_rotator.dart';
import 'package:color_switch_game/color_switcher.dart';
import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class MyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, HasDecorator, HasTimeScale {
  static const cameraWidth = 600.0;
  static const cameraHeight = 1000.0;

  late Player myPlayer;
  final List<Color> gameColors;

  MyGame(
      {this.gameColors = const [
        Colors.redAccent,
        Colors.greenAccent,
        Colors.blueAccent,
        Colors.yellowAccent,
        Colors.grey,
      ]})
      : super(
          camera: CameraComponent.withFixedResolution(
            width: cameraWidth,
            height: cameraHeight,
          ),
        );

  @override
  Color backgroundColor() {
    return Colors.black87;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    print(size);
  }

  @override
  void onLoad() {
    super.onLoad();
  }

  @override
  void onMount() {
    _initialGame();
    super.onMount();
    // debugMode = true;
  }

  @override
  void update(double dt) {
    final camCenterY = camera.viewfinder.position.y;
    final camBottomY = camCenterY + cameraHeight / 2;
    final playerY = myPlayer.position.y;

    if (playerY < camCenterY) {
      camera.viewfinder.position = Vector2(0, playerY);
      return;
    }

    if (playerY > camBottomY) {
      camera.viewfinder.position = Vector2(0, playerY);
      return;
    }

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    myPlayer.jump();
    super.onTapDown(event);
  }

  void _initialGame() {
    myPlayer = Player(position: Vector2(0, 300));
    world.add(Ground(position: Vector2(0, 400)));
    world.add(myPlayer);
    camera.moveTo(Vector2(0, 0));
    generateGameComponents();
  }

  void generateGameComponents() {
    world.add(
      ColorSwitcher(
        position: Vector2(0, 180),
      ),
    );
    world.add(CircleRotator(
      position: Vector2(0, 0),
      radius: 100,
    ));

    world.add(
      ColorSwitcher(
        position: Vector2(0, -200),
      ),
    );
    world.add(CircleRotator(
      position: Vector2(0, -400),
      radius: 80,
    ));

    world.add(CircleRotator(
      position: Vector2(0, -400),
      radius: 150,
    ));
  }

  void gameOver() {
    world.children.forEach((element) {
      element.removeFromParent();
    });
    _initialGame();
  }

  bool get isGamePause => timeScale == 0.0;

  void pauseGame() {
    // TODO: Do pause engine thì game ngừng render, nên decorator không được vẽ lại.
    decorator = PaintDecorator.blur(8.0);
    timeScale = 0.0;
  }

  void resumeGame() {
    decorator = PaintDecorator.blur(0);
    timeScale = 1.0;
  }
}
