import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_tutorial/card.dart';
import 'package:flame_tutorial/klondike_game.dart';
import 'package:flame_tutorial/pile.dart';
import 'package:flame_tutorial/suit.dart';

class FoundationPile extends PositionComponent implements Pile {
  FoundationPile(int suitInt)
    : suit = Suit.fromInt(suitInt),
      super(size: KlondikeGame.cardSize);
  final Suit suit;

  final List<Card> _cards = [];

  @override
  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
    card.pile = this;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(KlondikeGame.cardRRect, _borderPaint);
    suit.sprite.render(
      canvas,
      position: size / 2,
      anchor: Anchor.center,
      size: Vector2.all(KlondikeGame.cardWidth * 0.6),
      overridePaint: _suitPaint,
    );
  }

  static final Paint _borderPaint = Paint()
    ..color = Color(0xffdbe2da)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;

  late final _suitPaint = Paint()
    ..color = suit.isRed ? const Color(0x3a000000) : const Color(0x64000000)
    ..blendMode = BlendMode.luminosity;

  @override
  bool canMoveCard(Card card) {
    if (_cards.isEmpty) {
      return false;
    } else {
      return _cards.last == card;
    }
  }

  @override
  bool canAcceptcard(Card card) {
    int currentRank = _cards.isEmpty ? 0 : _cards.last.rank.value;
    return card.suit == this.suit && card.rank.value == currentRank + 1;
  }

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    _cards.removeLast();
  }

  @override
  void returnCard(Card card) {
    card.position = position;
    card.priority = _cards.indexOf(card);
  }
}
