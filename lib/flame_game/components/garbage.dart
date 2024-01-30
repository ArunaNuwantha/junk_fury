import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'dart:ui';

import 'package:junk_fury/flame_game/junk_fury.dart';

class Garbage extends SpriteAnimationComponent with HasGameRef<JunkFury> {
  static const double sized = 32.0;

  Garbage(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(sized),
        );

  @override
  FutureOr<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'garbage.png',
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: .2,
        textureSize: Vector2(32, 32),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // Move the garbage downward
    position.y += 100 * dt;
  }
}
