import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';

import 'package:gigi_smash/game/gigi_smash.dart';
import 'ball_line.dart';

class SpawnLine extends ShapeComponent with Hitbox, Collidable {
  SpawnLine({
    required this.game,
    required this.onSpawn,
    required Shape shape,
    required Paint shapePaint,
  }) : super(shape, shapePaint) {
    // debugMode = true;
    addShape(HitboxRectangle());
  }

  final GigiSmash game;
  final VoidCallback onSpawn;

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    position = Vector2(game.canvasSize.x - 100, game.canvasSize.y - 100);
    super.onGameResize(gameSize);
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is BallLine) {
      onSpawn();
    }
    super.onCollisionEnd(other);
  }
}