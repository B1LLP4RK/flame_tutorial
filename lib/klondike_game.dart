import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame_tutorial/card.dart';
import 'package:flame_tutorial/components/foundation_pile.dart';
import 'package:flame_tutorial/components/tableau_pile.dart';
import 'package:flame_tutorial/components/stock_pile.dart';
import 'package:flame_tutorial/components/waste_pile.dart';
import 'package:flutter/rendering.dart';

class KlondikeGame extends FlameGame {
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardGap = 175.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);
  @override
  FutureOr<void> onLoad() async {
    await Flame.images.load('klondike-sprites.png');

    final stock = StockPile()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);

    final waste = WastePile()
      ..size = cardSize
      ..position = Vector2(cardWidth + 2 * cardGap, cardGap);

    final foundations = List.generate(4, (int number) {
      return FoundationPile(number)
        ..size = cardSize
        ..position = Vector2(
          (number + 3) * (cardGap + cardWidth) + cardGap,
          cardGap,
        );
    });

    final piles = List.generate(7, (int number) {
      return TableauPile()
        ..size = cardSize
        ..position = Vector2(
          cardGap + number * (cardGap + cardWidth),
          2 * cardGap + cardHeight,
        );
    });
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
    final cards = [
      for (var rank = 1; rank <= 13; rank++)
        for (int suit = 0; suit < 4; suit++) Card(rank, suit),
    ];
    cards.shuffle();
    world.addAll(cards);
    int cardsToDeal = cards.length - 1;
    for (int i = 0; i < 7; i++) {
      for (int j = i; j < 7; j++) {
        piles[j].acquireCard(cards[cardsToDeal--]);
      }
      piles[i].flipTopCard();
    }
    for (int i = 0; i <= cardsToDeal; i++) {
      stock.acquireCard(cards[i]);
    }
    return super.onLoad();
  }

  static RRect cardRRect = RRect.fromRectAndRadius(
    Rect.fromLTWH(0, 0, cardWidth, cardHeight),
    Radius.circular(cardRadius),
  );
}

Sprite klondikeSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('klondike-sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
