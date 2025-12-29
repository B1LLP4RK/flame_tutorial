import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_tutorial/card.dart';
import 'package:flame_tutorial/klondike_game.dart';
import 'package:flame_tutorial/pile.dart';

class TableauPile extends PositionComponent implements Pile {
  TableauPile({super.position}) : super(size: KlondikeGame.cardSize);
  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = Color(0x50ffffff);
  @override
  void render(Canvas canvas) {
    canvas.drawRRect(KlondikeGame.cardRRect, _borderPaint);
  }

  final _fanOffset = Vector2(0, 0.05 * KlondikeGame.cardHeight);

  final List<Card> _cards = [];
  void acquireCard(Card card) {
    if (_cards.isEmpty) {
      card.position = position;
    } else {
      card.position = _cards.last.position + _fanOffset;
    }
    card.priority = _cards.length;
    _cards.add(card);
    card.pile = this;
  }

  void flipTopCard() {
    assert(_cards.last.isFaceDown);
    _cards.last.flip();
  }

  @override
  bool canMoveCard(Card card) {
    return _cards.isNotEmpty && _cards.last == card;
  }

  @override
  bool canAcceptcard(Card card) {
    if (_cards.isEmpty) {
      return card.rank.value == 13;
    } else {
      Card topCard = _cards.last;
      return topCard.suit.isRed != card.suit.isRed &&
          topCard.rank.value - 1 == card.rank.value;
    }
  }

  @override
  void removeCard(Card card) {
    assert(_cards.contains(card) && card.isFaceUp);
    int index = _cards.indexOf(card);
    _cards.removeRange(index, _cards.length);
    if (_cards.isNotEmpty && _cards.last.isFaceDown) {
      flipTopCard();
    }
  }

  @override
  void returnCard(Card card) {
    int index = _cards.indexOf(card);
    card.priority = index;
    card.position = index == 0
        ? position
        : _cards[index - 1].position + _fanOffset;
  }
}
