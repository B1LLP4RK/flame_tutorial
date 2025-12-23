import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tutorial/card.dart';
import 'package:flame_tutorial/components/waste.dart';
import 'package:flame_tutorial/klondike_game.dart';

class StockPile extends PositionComponent with TapCallbacks {
  @override
  bool get debugMode => true;

  final List<Card> _cards = [];

  void acquireCard(Card card) {
    assert(!card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_cards.isEmpty) {
      final wastePile = parent!.firstChild<WastePile>()!;
      wastePile.removeAllCards().reversed.forEach((card) {
        card.flip();
        acquireCard(card);
      });
    } else {
      final wastepile = parent!.firstChild<WastePile>()!;
      for (var i = 0; i < 3; i++) {
        if (_cards.isNotEmpty) {
          final card = _cards.removeLast();
          card.flip();
          wastepile.acquireCard(card);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Color(0xFF3F5B5D);
    final _circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 100
      ..color = const Color(0x883F5B5D);
    canvas.drawRRect(KlondikeGame.cardRRect, _borderPaint);
    canvas.drawCircle(
      Offset(width / 2, height / 2),
      KlondikeGame.cardWidth * 0.3,
      _circlePaint,
    );
    super.render(canvas);
  }
}
