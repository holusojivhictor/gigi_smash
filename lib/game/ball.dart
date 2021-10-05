import 'dart:ui';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:gigi_smash/game/lines/ball_line.dart';

import 'gigi_smash.dart';


class Ball extends SpriteComponent with Hitbox, Collidable {
  Ball({
    required this.game,
  }) {
    // debugMode = true;
    addShape(HitboxCircle(definition: 0.8));
  }
  final GigiSmash game;

  bool isColliding = false;
  bool isOffScreen = false;
  List<Collidable> currentlyColliding = [];

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('Logo_2.png');
    size = Vector2.all(96.0);
    this.anchor = Anchor.center;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    position = gameSize / 2;
    super.onGameResize(gameSize);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (!currentlyColliding.contains(other)) {
      currentlyColliding.add(other);
      if (other is BallLine) {
        isColliding = true;
        game.camera.shake();
        game.sessionManager.updateScore();
        collisionParticle(Colors.blueAccent);
        FlameAudio.play('impact.mp3', volume: 0.4);
        other.remove();
      }
      if (other is ScreenCollidable) {
        collisionParticle(Colors.redAccent);
        game.sessionManager.reduceHealth();
        isOffScreen = true;
      }
    }
  }

  void collisionParticle(Color color) {
    math.Random rnd = math.Random();
    Vector2 randomVector2() => (Vector2.random(rnd) - Vector2.random(rnd)) * 800;
    game.add(
      ParticleComponent(
        particle: Particle.generate(
          count: 40,
          lifespan: 1,
          generator: (i) {
            return AcceleratedParticle(
              acceleration: randomVector2(),
              speed: randomVector2(),
              position: (position.clone() + Vector2(0, size.y / 1.5)),
              child: ComputedParticle(
                renderer: (canvas, particle) => canvas.drawCircle(
                  Offset.zero,
                  particle.progress * 10,
                  Paint()..color = Color.lerp(color, color.withAlpha(0), particle.progress)!,
                ),
              ),
            );
          }
        )
      )
    );
  }

  @override
  void onCollisionEnd(Collidable other) {
    currentlyColliding.remove(other);
  }
}