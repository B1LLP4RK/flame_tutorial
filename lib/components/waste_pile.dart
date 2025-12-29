import 'package:flame/components.dart';
import 'package:flame_tutorial/card.dart';
import 'package:flame_tutorial/klondike_game.dart';
import 'package:flame_tutorial/pile.dart';

class WastePile extends PositionComponent implements Pile {
  @override
  bool get debugMode => true;
  final List<Card> _cards = [];

  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
    _fanOutTopCards();
    card.pile = this;
  }

  void _fanOutTopCards() {
    final n = _cards.length;
    for (var i = 0; i < n; i++) {
      _cards[i].position = position;
    }
    if (n == 2) {
      _cards[1].position.add(_fanOffset);
    } else if (n >= 3) {
      _cards[n - 2].position.add(_fanOffset);
      _cards[n - 1].position.addScaled(_fanOffset, 2);
    }
  }

  final Vector2 _fanOffset = Vector2(KlondikeGame.cardWidth * 0.2, 0);
  List<Card> removeAllCards() {
    final cards = _cards.toList();
    _cards.clear();
    return cards;
  }

  @override
  bool canMoveCard(Card card) {
    return _cards.isNotEmpty && _cards.last == card;
  }

  @override
  bool canAcceptcard(Card card) {
    return false;
  }

  @override
  void removeCard(Card card) {
    _cards.removeLast();
    _fanOutTopCards();
  }

  @override
  void returnCard(Card card) {
    card.priority = _cards.indexOf(card);
    _fanOutTopCards();
  }
}
