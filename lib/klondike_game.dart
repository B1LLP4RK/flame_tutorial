import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tutorial/card.dart';
import 'package:flame_tutorial/components/foundation.dart';
import 'package:flame_tutorial/components/pile.dart';
import 'package:flame_tutorial/components/stock.dart';
import 'package:flame_tutorial/components/waste.dart';

class KlondikeGame extends FlameGame {
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardGap = 175.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);
  @override
  FutureOr<void> onLoad() async {
    await Flame.images.load('klondike-sprites.png');
    world.add(stock);
    world.add(waste);
    world.addAll(foundations);
    world.addAll(piles);
    camera.viewfinder.visibleGameSize = Vector2(
      cardWidth * 7 + cardGap * 8,
      4 * cardHeight + 3 * cardGap,
    );
    camera.viewfinder.position = Vector2(cardWidth * 3.5 + cardGap * 4, 0);
    camera.viewfinder.anchor = Anchor.topCenter;
    final random = Random();
    for (var i = 0; i < 7; i++) {
      for (var j = 0; j < 4; j++) {
        final card = Card(random.nextInt(12), random.nextInt(4))
          ..position = Vector2(100 + i * 1150, 100 + j * 1500)
          ..addToParent(world);
        if (random.nextDouble() < 0.9) {
          // flip face up with 90% probability
          card.flip();
        }
      }
    }
    return super.onLoad();
  }

  final stock = Stock()
    ..size = cardSize
    ..position = Vector2(cardGap, cardGap);

  final waste = Waste()
    ..size = cardSize
    ..position = Vector2(cardWidth + 2 * cardGap, cardGap);

  final foundations = List.generate(4, (int number) {
    return Foundation()
      ..size = cardSize
      ..position = Vector2(
        (number + 3) * (cardGap + cardWidth) + cardGap,
        cardGap,
      );
  });

  final piles = List.generate(7, (int number) {
    return Pile()
      ..size = cardSize
      ..position = Vector2(
        cardGap + number * (cardGap + cardWidth),
        2 * cardGap + cardHeight,
      );
  });
}

Sprite klondikeSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('klondike-sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
