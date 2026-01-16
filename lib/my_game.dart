import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'object_pool/circle_rotator_pool.dart';
import 'object_pool/color_switcher_pool.dart';
import 'object_pool/star_component_pool.dart';

class MyGame extends FlameGame
    with
        TapCallbacks,
        HasCollisionDetection,
        HasDecorator,
        HasTimeScale {
  static const cameraWidth = 600.0;
  static const cameraHeight = 1000.0;

  late Player myPlayer;
  final List<Color> gameColors;

  ValueNotifier<int> currentScore = ValueNotifier(0);

  final CircleRotatorPool circleRotatorPool = CircleRotatorPool();
  final ColorSwitcherPool colorSwitcherPool = ColorSwitcherPool();
  final StarComponentPool starComponentPool = StarComponentPool();

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
  void onLoad() async {
    await super.onLoad();
    camera.viewfinder.zoom = 1.0;
    FlameAudio.bgm.initialize();
    // TODO: Tối ưu hiêu năng bằng cách load tất cả asset khi khởi tạo game
    await Flame.images.loadAll([
      'finger_tap.png',
      'star_icon.png',
    ]);

    await FlameAudio.audioCache.loadAll([
      'background.mp3',
      'collect.wav',
    ]);
  }

  @override
  void onMount() {
    _initialGame();
    super.onMount();
    // debugMode = true;
    add(FpsTextComponent());
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

    if (playerY >= camBottomY) {
      camera.viewfinder.position = Vector2(0, camBottomY);
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
    circleRotatorPool.resetPool();
    colorSwitcherPool.resetPool();
    starComponentPool.resetPool();

    currentScore.value = 0;
    myPlayer = Player(position: Vector2(0, 300));
    world.add(Ground(position: Vector2(0, 400)));
    world.add(myPlayer);
    camera.moveTo(Vector2(0, 0));
    generateGameComponents();
    FlameAudio.bgm.play('background.mp3');
  }

  void generateGameComponents() {
    while (circleRotatorPool.circles.isNotEmpty) {
      world.add(circleRotatorPool.provide() as Component);
    }

    while (colorSwitcherPool.colorSwitchers.isNotEmpty) {
      world.add(colorSwitcherPool.provide() as Component);
    }

    while (starComponentPool.stars.isNotEmpty) {
      world.add(starComponentPool.provide() as Component);
    }
  }

  void gameOver() {
    FlameAudio.bgm.stop();
    world.children.forEach((element) {
      element.removeFromParent();
    });
    _initialGame();
  }

  bool get isGamePause => timeScale == 0.0;

  void pauseGame() {
    // TODO: Thực hiện pause engine thì game ngừng render, nên decorator không được vẽ lại.
    decorator = PaintDecorator.blur(8.0);
    timeScale = 0.0;
    FlameAudio.bgm.pause();
  }

  void resumeGame() {
    decorator = PaintDecorator.blur(0);
    timeScale = 1.0;
    FlameAudio.bgm.resume();
  }

  void increaseScore() {
    currentScore.value++;
  }

  void addCircleRotator() {
    if (currentScore.value >= 5) {
      circleRotatorPool.offer();
    }
  }
}
