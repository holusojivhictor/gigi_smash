import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:gigi_smash/main.dart';

import 'gigi_smash.dart';

class SessionManager extends BaseComponent {
  SessionManager({required this.game, required Vector2 size}) {
    TextPaint regular = TextPaint(config: const TextPaintConfig(color: Colors.white));
    scoreComponent = TextComponent('score: $_score', textRenderer: regular)
      ..anchor = Anchor.topCenter
      ..x = size.x / 1.7
      ..y = 32.0;
    
    healthLeftComponent = TextComponent('health: $_healthLeft', textRenderer: regular)
      ..anchor = Anchor.topCenter
      ..x = size.x / 2.5
      ..y = 32.0;
    isHud = true;
  }

  final GigiSmash game;

  int _score = 0;
  int get score => _score;
  late TextComponent scoreComponent;

  int _healthLeft = 3;
  late TextComponent healthLeftComponent;

  @override
  Future<void>? onLoad() {
    addChild(scoreComponent);
    addChild(healthLeftComponent);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    healthLeftComponent.x = gameSize.x / 2.5;
    scoreComponent.x = gameSize.x / 1.7;
    super.onGameResize(gameSize);
  }

  @override
  void update (double dt) {
    scoreComponent.text = 'score: $_score';
    healthLeftComponent.text = 'health: $_healthLeft';

    if (_healthLeft <= 0) {
      game.overlays.add(pauseMenu);
      game.pauseEngine();
    }
    super.update(dt);
  }

  void reset() {
    _score = 0;
    _healthLeft = 3;
  }

  void updateScore() {
    _score++;
  }

  void reduceHealth() {
    _healthLeft--;
    final particle = createRedScreenParticle();
    game.add(particle);
    FlameAudio.play('impact.mp3', volume: 0.4);
  }

  ParticleComponent createRedScreenParticle() {
    final particle = ParticleComponent(
      particle: ComputedParticle(
        lifespan: 0.3,
        renderer: (canvas, particle) {
          final rectangle = Rect.fromCenter(
            center: Offset(game.size.x / 2, game.size.y / 2),
            width: game.size.x * 3.5,
            height: game.size.y * 3.5,
          );
          canvas.drawRect(
            rectangle,
            Paint()
              ..color = Colors.redAccent
              ..style = PaintingStyle.fill
              ..shader = const RadialGradient(colors: [Colors.transparent, Colors.redAccent]).createShader(rectangle)
              ..strokeWidth = 2,
          );
        }
      )
    );

    return particle;
  }
}