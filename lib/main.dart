import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:gigi_smash/game/game_colors.dart';

import 'package:gigi_smash/game/gigi_smash.dart';

const startMenu = 'startMenu';
const pauseMenu = 'pauseMenu';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  final gigiSmash = GigiSmash();
  runApp(
    GameWidget<GigiSmash>(
      game: gigiSmash,
      initialActiveOverlays: const [
        startMenu,
      ],
      overlayBuilderMap: {
        'startMenu': (context, game) {
          return StartMenuOverlay(gigiSmash: game);
        },
        'pauseMenu': (context, game) {
          return PauseMenuOverlay(gigiSmash: game);
        }
      },
    ),
  );
}

class StartMenuOverlay extends StatelessWidget {
  final GigiSmash gigiSmash;

  const StartMenuOverlay({Key? key, required this.gigiSmash}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 400,
        height: 340,
        decoration: BoxDecoration(
          color: GameColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Gigi Smash',
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            if (gigiSmash.sessionManager.score > 0)
              Text(gigiSmash.sessionManager.scoreComponent.text,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            const Spacer(),
            Image.asset(
              'assets/images/Logo_2.png',
              height: 160,
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 64),
                primary: GameColors.primary,
              ),
              onPressed: () {
                gigiSmash.overlays.remove(startMenu);
                gigiSmash.start();

                gigiSmash.sessionManager.reset();
              },
              child: const Text('Start Game'),
            ),
            /*Row(
              children: [
                ...List.generate(
                  levelInfo.length,
                    (index) => LevelButton(
                      levelSpeed: levelInfo[index].speed,
                      press: () {
                        gigiSmash.overlays.remove(startMenu);
                        gigiSmash.start();

                        gigiSmash.sessionManager.reset();
                      },
                      levelInfo: levelInfo[index],
                    ),
                )
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}

class PauseMenuOverlay extends StatelessWidget {
  final GigiSmash gigiSmash;

  const PauseMenuOverlay({Key? key, required this.gigiSmash}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 400,
        height: 340,
        decoration: BoxDecoration(
          color: GameColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Gigi Smash',
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            if (gigiSmash.sessionManager.score > 0)
              Text(gigiSmash.sessionManager.scoreComponent.text,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            const Spacer(),
            Image.asset(
              'assets/images/Logo_2.png',
              height: 160,
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 64),
                primary: GameColors.primary,
              ),
              onPressed: () {
                gigiSmash.overlays.remove(pauseMenu);
                gigiSmash.start();
                },
              child: const Text('Resume'),
            ),
          ],
        ),
      ),
    );
  }
}