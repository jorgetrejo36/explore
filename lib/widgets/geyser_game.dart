import 'package:explore/screens/game_result_screen.dart';
import 'package:explore/widgets/life_app_bar.dart';
import 'package:explore/widgets/life_counter.dart';
import 'package:explore/widgets/retry_window.dart';
import 'package:flutter/material.dart';

class GeyserGameStateful extends StatefulWidget {
  const GeyserGameStateful({super.key});

  @override
  State<GeyserGameStateful> createState() => _GeyserGameState();
}

class _GeyserGameState extends State<GeyserGameStateful> {
  int counter = 0;
  int lives = 3;
  void increment() {
    setState(() {
      counter++;
      print(counter);
    });
  }

  void loseLife() {
    setState(() {
      lives--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LifeAppBar(
        title: "App Bar",
        counter: counter,
        titleWidget: LifeCounterStateful(lives: lives),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            increment();
          },
          child: Icon(Icons.add)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("This is the geyser game screen"),
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
              onPressed: () => {loseLife()},
              child: const Text("lose a life"),
            ),
            RetryWidget(
              correctAnswers: 3,
              questions: 5,
              gameWidget: GeyserGameStateful(),
            ),
          ],
        ),
      ),
    );
  }
}
