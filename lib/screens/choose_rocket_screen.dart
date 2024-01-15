import 'package:explore/screens/choose_avatar_screen.dart';
import 'package:flutter/material.dart';

class ChooseRocketScreen extends StatelessWidget {
  const ChooseRocketScreen({super.key});

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
            const Text("Choose rocket for new avatar"),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChooseAvatarScreen(),
                ),
              ),
              child: const Text("Choose Rocket"),
            ),
          ],
        ),
      ),
    );
  }
}
