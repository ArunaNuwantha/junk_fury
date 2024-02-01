import 'dart:async' as async;
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:junk_fury/flame_game/components/garbage.dart';
import 'package:junk_fury/flame_game/components/play_area.dart';
import 'package:junk_fury/flame_game/components/player.dart';
import 'package:junk_fury/flame_game/config.dart';

class JunkFury extends FlameGame with HasCollisionDetection, KeyboardEvents {
  JunkFury()
      : super(
            camera: CameraComponent.withFixedResolution(
                width: gameWidth, height: gameHeight));

  double get width => size.x;
  double get height => size.y;

  @override
  async.FutureOr<void> onLoad() {
    // camera.backdrop.add(Background(speed: 2));
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(PlayArea());
    Player player = Player(
      position: Vector2(width / 2, height * 0.95),
    );
    world.add(player);

    spawnGarbage();
  }

  void spawnGarbage() {
    // final randomX = math.Random().nextDouble() * (width - Garbage.sized);
    world.add(SpawnComponent(
      factory: (index) => Garbage(),
      period: 1,
      area: Rectangle.fromLTWH(0, 0, size.x, -Garbage.sized),
    ));
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Player>().first.moveBy(-playerStep);

      case LogicalKeyboardKey.arrowRight:
        world.children.query<Player>().first.moveBy(playerStep);
    }
    return KeyEventResult.handled;
  }
}
