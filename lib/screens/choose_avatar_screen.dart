import 'package:explore/screens/create_name_screen.dart';
import 'package:flutter/material.dart';

class ChooseAvatarScreen extends StatelessWidget {
  const ChooseAvatarScreen({super.key});

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
            const Text("Choose new avatar"),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateNameScreen(),
                ),
              ),
              child: const Text("Choose Avatar"),
            ),
          ],
        ),
      ),
    );
  }
}
