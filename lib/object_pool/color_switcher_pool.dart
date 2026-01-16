import 'dart:collection';

import 'package:flame/components.dart';

import '../color_switcher.dart';

class ColorSwitcherPool {
  late Queue<ColorSwitcher> colorSwitchers;

  ColorSwitcherPool() {
    _initPool();
  }

  void _initPool() {
    colorSwitchers = Queue<ColorSwitcher>.from([
      ColorSwitcher(
        position: Vector2(0, 200),
      ),
      ColorSwitcher(
        position: Vector2(0, -200),
      ),
      ColorSwitcher(
        position: Vector2(0, -600),
      ),
    ]);
  }

  ColorSwitcher? provide() {
    return colorSwitchers.isEmpty ? null : colorSwitchers.removeFirst();
  }

  void offer(ColorSwitcher colorSwitcher) {
    final newPosition = colorSwitcher.position + Vector2(0, -1200);
    colorSwitchers.add(colorSwitcher.updatePosition(newPosition: newPosition));
  }

  void resetPool() {
    // Tạo snapshot để tránh concurrent modification
    final snapshot = List<ColorSwitcher>.from(colorSwitchers);
    for (final colorSwitcher in snapshot) {
      colorSwitcher.removeFromParent();
    }

    colorSwitchers.clear();
    _initPool();
  }
}
