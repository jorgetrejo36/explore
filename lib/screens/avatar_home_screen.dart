import 'package:explore/screens/choose_rocket_screen.dart';
import 'package:explore/screens/leaderboard_screen.dart';
import 'package:explore/screens/planet_home_screen.dart';
import 'package:flutter/material.dart';

class AvatarHomeScreen extends StatelessWidget {
  const AvatarHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Avator home screen where user can choose an old avator, make a new one, or look at the leaderboard.",
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaderboardScreen(),
                ),
              ),
              child: const Text("Leaderboard"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlanetHomeScreen(),
                ),
              ),
              child: const Text("Old avatar"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChooseRocketScreen(),
                ),
              ),
              child: const Text("New avatar"),
            ),
          ],
        ),
      ),
    );
  }
}
