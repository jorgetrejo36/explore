import 'package:explore/screens/game_result_screen.dart';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:explore/utils/problem_generator.dart';
import 'package:explore/widgets/geyser_game.dart';
import 'package:explore/widgets/score_calculator.dart';
import 'package:explore/widgets/shooting_game.dart';
import 'package:explore/widgets/mining_game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "This is a parent screen for all the games.The game will happen and when it is finished the result screen will automatically pop up. To simulate this behavior in the skeleton app the button acts as if the game has been completed.",
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => GameResultScreen(
                    game: Game.geyser,
                    level: 0,
                    planet: GameTheme.earth,
                    currency: 0,
                    time: 0,
                  ),
                ),
              ),
              child: const Text("Game Complete"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MiningGame(
                    level: 0,
                    planet: GameTheme.earth,
                    miningProblem: ProblemGenerator(1, true),
                  ),
                ),
              ),
              child: const Text("Mining Game"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ShootingGameStateful(
                    level: 0,
                    planet: GameTheme.earth,
                    shootingProblem: ProblemGenerator(1, true),
                  ),
                ),
              ),
              child: const Text("Shooting Game"),
            ),
          ],
        ),
      ),
    );
  }
}
