import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'dart:ui';

import 'package:junk_fury/flame_game/junk_fury.dart';

class Garbage extends PositionComponent with HasGameRef<JunkFury> {
  static const double sized = 32.0;

  late final Paint paint;

  Garbage(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(sized),
        ) {
    paint = Paint()
      ..color = const Color(0xFFFF0000); // Red color for the garbage
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(toRect(), paint);
  }

  @override
  void update(double dt) {
    // Move the garbage downward
    position.y += 100 * dt;
  }
}
