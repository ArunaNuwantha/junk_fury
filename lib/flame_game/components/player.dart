import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:junk_fury/flame_game/components/garbage.dart';
import 'package:junk_fury/flame_game/junk_fury.dart';
import 'dart:developer' as developer;

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<JunkFury>, DragCallbacks, CollisionCallbacks {
  Player({required super.position})
      : super(
          anchor: Anchor.center,
        );

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _loadAllAnimation();

    add(
      RectangleHitbox(),
    );

    width = 64;
    height = 64;
  }

  void _loadAllAnimation() async {
    idleAnimation = await game.loadSpriteAnimation(
      'player_idle.png',
      SpriteAnimationData.sequenced(
        amount: 11,
        stepTime: .2,
        textureSize: Vector2(32, 32),
      ),
    );

    runningAnimation = await game.loadSpriteAnimation(
      'player_run.png',
      SpriteAnimationData.sequenced(
        amount: 12,
        stepTime: .2,
        textureSize: Vector2(32, 32),
      ),
    );

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };

    current = PlayerState.idle;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    position.x = (position.x + event.localDelta.x)
        .clamp(width / 2, game.width - width / 2);
  }

  void moveBy(double dx) {
    final newPosition = position.x + dx;
    final clampedPosition =
        newPosition.clamp(width / 2, game.width - width / 2);
    add(MoveToEffect(
      Vector2(clampedPosition, position.y),
      EffectController(duration: 0.1),
    ));
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    developer.log("collided");
    if (other is Garbage) {
      other.removeFromParent();
    }
  }
}

enum PlayerState { idle, running }
