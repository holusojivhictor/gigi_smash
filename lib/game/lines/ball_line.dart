import 'dart:math';

import 'package:flame/geometry.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:gigi_smash/game/gigi_smash.dart';

import '../game_colors.dart';

class LevelInfo {
  final String text;
  final double speed;
  LevelInfo({required this.text, required this.speed});
}

List<LevelInfo> levelInfo = [
  LevelInfo(
    text: "Easy",
    speed: 3,
  ),
  LevelInfo(
    text: "Medium",
    speed: 5,
  ),
  LevelInfo(
    text: "Hard",
    speed: 8,
  ),
];

class LevelButton extends StatelessWidget {
  const LevelButton({Key? key, required this.levelInfo, required this.press, required this.levelSpeed}) : super(key: key);
  final LevelInfo levelInfo;
  final double levelSpeed;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 64),
        primary: GameColors.primary,
      ),
      onPressed: press,
      child: Text(levelInfo.text),
    );
  }
}

class Level {
  final double speed;
  Level({required this.speed});
}

List<Level> level = [
  Level(speed: 3),
  Level(speed: 5),
  Level(speed: 8),
];

class BallLine extends ShapeComponent with Hitbox, Collidable {
  BallLine({
    required Shape shape,
    required Paint shapePaint,
    required this.game,
    required double x,
    required double y,
  }) : super(shape, shapePaint) {
    position = Vector2(x, y);
    // debugMode = true;
    addShape(HitboxRectangle());
  }

  final GigiSmash game;
  // final double speed = 3;

  @override
  void update(double dt) {
    position.x -= level[1].speed;
    super.update(dt);
  }
}

class RoundedRectangle extends Shape {
  double normalizedRadius = 1;

  RoundedRectangle({
    double? radius,
    Vector2? position,
    Vector2? size,
    double angle = 0,
  }) : super(
    position: position,
    size: size,
    angle: angle,
  );

  RoundedRectangle.fromDefinition({
    this.normalizedRadius = 1.0,
    Vector2? position,
    Vector2? size,
    double? angle,
  }) : super(position: position, size: size, angle: angle ?? 0);

  double get radius => (min(size.x, size.y) / 2) * normalizedRadius;

  @override
  void render(Canvas canvas, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: localCenter.toOffset(),
          width: size.x,
          height: size.y,
        ),
        Radius.circular(radius),
      ),
      paint,
    );
  }

  @override
  bool containsPoint(Vector2 point) {
    return absoluteCenter.distanceToSquared(point) < radius * radius;
  }

  List<Vector2> lineSegmentIntersections(LineSegment line, {double epsilon = double.minPositive,}) {
    double sq(double x) => pow(x, 2).toDouble();

    final cx = absoluteCenter.x;
    final cy = absoluteCenter.y;

    final point1 = line.from;
    final point2 = line.to;

    final delta = point2 - point1;

    final A = sq(delta.x) + sq(delta.y);
    final B = 2 * (delta.x * (point1.x - cx) + delta.y * (point1.y - cy));
    final C = sq(point1.x - cx) + sq(point1.y - cy) - sq(radius);

    final det = B * B - 4 * A * C;
    final result = <Vector2>[];
    if (A <= epsilon || det < 0) {
      return [];
    } else if (det == 0) {
      final t = -B / (2 * A);
      result.add(Vector2(point1.x + t * delta.x, point1.y + t * delta.y));
    } else {
      final t1 = (-B + sqrt(det)) / (2 * A);
      final i1 = Vector2(
        point1.x + t1 * delta.x,
        point1.y + t1 * delta.y,
      );

      final t2 = (-B - sqrt(det)) / (2 * A);
      final i2 = Vector2(
        point1.x + t2 * delta.x,
        point1.y + t2 * delta.y,
      );
      
      result.addAll([i1, i2]);
    }
    result.removeWhere((v) => !line.containsPoint(v));
    return result;
  }
}