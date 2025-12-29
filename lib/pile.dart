import 'package:flame_tutorial/card.dart';

abstract class Pile {
  bool canMoveCard(Card card);
  bool canAcceptcard(Card card);
  void removeCard(Card card);
  void acquireCard(Card card);
  void returnCard(Card card);
}
