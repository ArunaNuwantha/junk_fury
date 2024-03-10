import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:junk_fury/flame_game/junk_fury.dart';

class Garbage extends SpriteComponent with HasGameRef<JunkFury> {
  static const double sized = 48.0;

  Garbage()
      : super(
          size: Vector2.all(sized),
        );

  @override
  FutureOr<void> onLoad() async {
    final randomImageIndex = Random().nextInt(3) +
        1; // Adjust the range based on the number of images you have
    final imageName =
        'garbage$randomImageIndex.png'; // Assuming your image files are named 'garbage1.png', 'garbage2.png', etc.

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
    // Move the garbage downward
    position.y += 100 * dt;
    if (position.y > game.height) {
      game.playerDied();
      removeFromParent();
    }
  }
}
