import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:gigi_smash/game/ball.dart';
import 'package:gigi_smash/game/game_colors.dart';
import 'package:gigi_smash/game/lines/ball_line_manager.dart';
import 'package:gigi_smash/game/session_manager.dart';

class GigiSmash extends BaseGame with TapDetector, HasCollidables {
  bool hasTapped = false;
  late Ball ball;

  late final SessionManager sessionManager;
  late final BallLineManager ballLineSpawner;

  @override
  Future<void> onLoad() async {
    FlameAudio.bgm.initialize();
    camera.defaultShakeIntensity = 10;
    ball = Ball(
      game: this,
    );
    sessionManager = SessionManager(game: this, size: size);
    ballLineSpawner = BallLineManager(game: this);

    final backgroundComponent = await loadParallaxComponent(
      [
        ParallaxImageData('Background.jpg'),
      ],
      baseVelocity: Vector2(50, 0),
    );
    add(backgroundComponent);
    
    add(sessionManager);
    add(ScreenCollidable());
    add(ball);
    ballLineSpawner.addDeSpawner();
    ballLineSpawner.addBallLineSpawner();
    return super.onLoad();
  }

  void start() {
    resumeEngine();
    ballLineSpawner.reset();

    final initialPlatform = ballLineSpawner.createBallLine();
    add(initialPlatform);
    ballLineSpawner.lines.add(initialPlatform);
    if (!FlameAudio.bgm.isPlaying) {
      FlameAudio.bgm.play('Automation.mp3', volume: 0.2);
    }
  }

  @override
  void onDetach() {
    FlameAudio.bgm.dispose();
    super.onDetach();
  }

  @override
  void onTap() {
    ball.isOffScreen = false;
    ball.isColliding = false;
    hasTapped = true;
    super.onTap();
  }

  @override
  void update(double dt) {
    //print("isOffscreen: ${ball.isOffScreen}, hasTapped: ${hasTapped}, isColliding: ${ball.isColliding}");
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if (hasTapped) {
      ball.position.moveToTarget(Vector2(canvasSize.x / 2, canvasSize.y + 60), 20);
      if (ball.isColliding || ball.isOffScreen) {
        hasTapped = false;
      }
    } else {
      ball.position.moveToTarget(canvasSize / 2, 20);
    }
    super.render(canvas);
  }

  @override
  Color backgroundColor() {
    return GameColors.background;
  }
}