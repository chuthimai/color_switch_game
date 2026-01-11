import 'package:color_switch_game/player.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class MyGame extends FlameGame with TapCallbacks {
  late Player myPlayer;

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
    add(myPlayer);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // TODO: implement onTapDown
    myPlayer.jump();
    super.onTapDown(event);
  }
}
