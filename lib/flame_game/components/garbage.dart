import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:junk_fury/flame_game/config.dart';
import 'package:junk_fury/flame_game/junk_fury.dart';

class Garbage extends SpriteComponent with HasGameRef<JunkFury> {
  static double sized = garbageSize;

  Garbage()
      : super(
          size: Vector2.all(sized),
        );

  @override
  FutureOr<void> onLoad() async {
    final randomImageIndex = Random().nextInt(3) + 1;
    final imageName = 'garbage$randomImageIndex.png';

    sprite = await game.loadSprite(imageName);

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
    position.y += 100 * dt;
    if (position.y > game.height) {
      game.playerDied();
      removeFromParent();
    }
  }
}
