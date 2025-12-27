import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_tutorial/card.dart';
import 'package:flame_tutorial/klondike_game.dart';
import 'package:flame_tutorial/suit.dart';

class FoundationPile extends PositionComponent {
  FoundationPile(int suitInt)
    : suit = Suit.fromInt(suitInt),
      super(size: KlondikeGame.cardSize);
  final Suit suit;

  @override
  bool get debugMode => true;

  List<Card> _cards = [];

  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(KlondikeGame.cardRRect, _borderPaint);
  }

  static final Paint _borderPaint = Paint()
    ..color = Color(0xffdbe2da)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
}
