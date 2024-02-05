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
import 'package:logging/logging.dart';

enum GameState { playing, gameOver, pause }

class JunkFury extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  JunkFury()
      : super(
            camera: CameraComponent.withFixedResolution(
                width: gameWidth, height: gameHeight));

  double get width => size.x;
  double get height => size.y;

  static final _log = Logger("JunkFury");

  late final TextComponent scoreText;
  late final TextComponent livesText;

  late int score;
  late int lives;

  late GameState _gameState;

  GameState get gameState => _gameState;

  set gameState(GameState gameState) {
    _gameState = gameState;
    switch (gameState) {
      case GameState.gameOver:
      case GameState.pause:
        overlays.add(gameState.name);
      case GameState.playing:
        overlays.remove(GameState.gameOver.name);
        overlays.remove(GameState.pause.name);
    }
  }

  final textRenderer = TextPaint(
    style: const TextStyle(
      fontSize: 30,
      color: Colors.black,
      fontFamily: 'Permanent Marker',
    ),
  );

  final livesTextRenderer = TextPaint(
    style: const TextStyle(
      fontSize: 30,
      color: Colors.red,
      fontFamily: 'Permanent Marker',
    ),
  );

  @override
  void onLoad() {
    gameState = GameState.pause;
    scoreText = TextComponent(
        position: Vector2(20, 10), priority: 1, textRenderer: textRenderer);
    livesText = TextComponent(
        position: Vector2(20, 40),
        priority: 1,
        textRenderer: livesTextRenderer);
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
    livesText.text = lives > 0 ? '❤️ ' * lives : '💀 ';
    if (lives <= 0) {
      gameOver();
    }
  }

  @override
  void onTap() {
    startGame();
    super.onTap();
  }

  void gameOver() {
    gameState = GameState.gameOver;
    // _log.log(Level.INFO, "Game is over");
  }

  void startGame() {
    if (gameState == GameState.playing) return;

    world.removeAll(world.children.query<SpawnComponent>());
    world.removeAll(world.children.query<Garbage>());
    world.removeAll(world.children.query<Player>());

    gameState = GameState.playing;

    score = 0;
    lives = 3;

    world.add(PlayArea());
    Player player = Player(position: Vector2(width / 2, height * 0.95));
    world.add(player);
    spawnGarbage();
    _log.log(Level.INFO, "Game is started");
  }

  void addScore({int amount = 1}) {
    if (lives > 0) score += amount;
  }

  void resetScore() {
    score = 0;
  }

  void playerDied() {
    if (lives > 0) lives -= 1;
  }

  void spawnGarbage() {
    world.add(SpawnComponent(
      factory: (index) => Garbage(),
      period: 2,
      area: Rectangle.fromLTWH(0, 0, size.x - Garbage.sized, -Garbage.sized),
    ));
  }
}
