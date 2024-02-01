import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:junk_fury/flame_game/junk_fury.dart';

class Garbage extends SpriteAnimationComponent with HasGameRef<JunkFury> {
  static const double sized = 64.0;

  Garbage()
      : super(
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
    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move the garbage downward
    position.y += 100 * dt;
  }
}
