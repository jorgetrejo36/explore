import 'package:flutter/material.dart';

class GameResultScreen extends StatelessWidget {
  const GameResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Game Results",
            ),
            ElevatedButton(
              // this pops the game result screen and should take you back to
              // the level select
              onPressed: () => Navigator.pop(context),
              child: const Text("Go to level select"),
            ),
          ],
        ),
      ),
    );
  }
}
