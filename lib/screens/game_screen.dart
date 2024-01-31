import 'package:explore/screens/game_result_screen.dart';
import 'package:explore/widgets/geyser_game.dart';
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
                  builder: (context) => const GameResultScreen(),
                ),
              ),
              child: const Text("Game Complete"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const GeyserGameStateful(),
                ),
              ),
              child: const Text("Geyser Game"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MiningGame(planet: "saturn"),
                ),
              ),
              child: const Text("Mining Game"),
            ),
          ],
        ),
      ),
    );
  }
}
