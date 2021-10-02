import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import 'package:gigi_smash/game/gigi_smash.dart';
import 'ball_line.dart';
import 'spawn_line.dart';
import 'de_spawner.dart';

class BallLineManager {
  BallLineManager({required this.game});

  final GigiSmash game;
  late SpawnLine _spawnLine;

  final List<BallLine> lines = List.empty(growable: true);

  void addDeSpawner() {
    final deSpawner = DeSpawner(
      game: game,
      shape: Rectangle(size: Vector2(20, 200)),
      shapePaint: Paint()..color = Colors.transparent,
      x: 0,
      y: game.size.y,
    );
    game.add(deSpawner);
  }

  void addBallLineSpawner() {
    _spawnLine = SpawnLine(
      game: game,
      shape: Rectangle(size: Vector2(20, 200)),
      shapePaint: Paint()..color = Colors.transparent,
      onSpawn: () {
        final subsequentPlatform = createBallLine();
        lines.add(subsequentPlatform);
        game.add(subsequentPlatform);
      },
    );
    game.add(_spawnLine);
  }

  BallLine createBallLine() {
    Random rnd = Random();
    final randomWidth = rnd.nextInt(100) + 50;
    final platform = BallLine(
      shape: RoundedRectangle(radius: 8, size: Vector2(randomWidth.toDouble(), 20)),
      shapePaint: Paint()..color = Colors.blueAccent,
      game: game,
      x: game.canvasSize.x + 100,
      y: game.canvasSize.y - 50,
    );
    return platform;
  }

  void reset() {
    game.components.removeAll(lines);
    lines.clear();
  }
}