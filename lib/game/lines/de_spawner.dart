import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';

import 'package:gigi_smash/game/gigi_smash.dart';
import 'ball_line.dart';

class DeSpawner extends ShapeComponent with Hitbox, Collidable {
  DeSpawner({
    required this.game,
    required Shape shape,
    required Paint shapePaint,
    required double x,
    required double y,
  }) : super(shape, shapePaint) {
    // debugMode = true;
    addShape(HitboxRectangle());
  }

  final GigiSmash game;

  @override
  void onGameResize(Vector2 gameSize) {
    position = Vector2(0, game.canvasSize.y - height / 2);
    super.onGameResize(gameSize);
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is BallLine) {
      game.sessionManager.reduceHealth();
      other.remove();
    }
    super.onCollisionEnd(other);
  }
}