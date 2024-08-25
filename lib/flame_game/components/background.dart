import 'package:flame/components.dart';

class Background extends SpriteComponent {
  Background({
    required double width, // Width of the background
    required double height, // Height of the background
  }) : super(size: Vector2(width, height));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('game_bg.png'); // Load the background image
  }
}
