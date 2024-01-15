import 'package:explore/screens/avatar_home_screen.dart';
import 'package:flutter/material.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Startup screen with animation"),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AvatarHomeScreen(),
                ),
              ),
              child: const Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}
