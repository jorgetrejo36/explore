import 'package:explore/screens/game_screen.dart';
import 'package:flutter/material.dart';

class PlanetMapScreen extends StatelessWidget {
  const PlanetMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Navigate back when the back button is pressed
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Planet Map Screen where you can choose an individual level.",
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GameScreen(),
                ),
              ),
              child: const Text("Choose Level"),
            ),
          ],
        ),
      ),
    );
  }
}
