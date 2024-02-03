import 'dart:async' as async;

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

  late final TextComponent scoreText;
  late final TextComponent livesText;

  late int score;
  late int lives;

  final textRenderer = TextPaint(
    style: const TextStyle(
      fontSize: 30,
      color: Colors.black,
      fontFamily: 'Permanent Marker',
    ),
  );

  @override
  async.FutureOr<void> onLoad() {
    scoreText = TextComponent(
        position: Vector2(20, 10), priority: 1, textRenderer: textRenderer);
    livesText = TextComponent(
        position: Vector2(160, 10), priority: 1, textRenderer: textRenderer);
    camera.viewport.add(scoreText);
    camera.viewport.add(livesText);
    // camera.backdrop.add(Background(speed: 2));
    camera.viewfinder.anchor = Anchor.topLeft;
    startGame();
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

  @override
  void update(double dt) {
    super.update(dt);
    scoreText.text = 'Score: $score';
    livesText.text = 'Lives: $lives';
  }

  void startGame() {
    score = 0;
    lives = 3;
    world.add(PlayArea());
    Player player = Player(position: Vector2(width / 2, height * 0.95));
    world.add(player);

    spawnGarbage();
  }

  void addScore({int amount = 1}) {
    score += amount;
  }

  void resetScore() {
    score = 0;
  }

  void playerDied() {
    lives -= 1;
  }

  void spawnGarbage() {
    world.add(SpawnComponent(
      factory: (index) => Garbage(),
      period: 1,
      area: Rectangle.fromLTWH(0, 0, size.x, -Garbage.sized),
    ));
  }
}
