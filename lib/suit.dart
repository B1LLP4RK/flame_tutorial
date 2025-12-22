import 'package:flame/components.dart';
import 'package:flame_tutorial/klondike_game.dart';
import 'package:meta/meta.dart';

@immutable
class Suit {
  factory Suit.fromInt(int i) {
    assert(i >= 0 && i <= 3);
    return _singletons[i];
  }

  final int value;
  final String label;
  final Sprite sprite;

  Suit._(this.value, this.label, double x, double y, double w, double h)
    : sprite = klondikeSprite(x, y, w, h);

  static final List<Suit> _singletons = [
    Suit._(0, '♥', 1176, 17, 172, 183),
    Suit._(1, '♦', 973, 14, 177, 182),
    Suit._(2, '♣', 974, 226, 184, 172),
    Suit._(3, '♠', 1178, 220, 176, 182),
  ];

  bool get isRed => value <= 1;
  bool get isBlack => value > 1;
}
