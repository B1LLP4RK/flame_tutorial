import 'package:flame_tutorial/klondike_game.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() {
  final game = KlondikeGame();
  runApp(GameWidget(game: game));
}
