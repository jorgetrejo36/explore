import 'package:explore/screens/startup_screen.dart';
import 'package:explore/utils/problem_generator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ProblemGenerator problemGenerator = ProblemGenerator(2, true);
    print(problemGenerator.generateProblem());

    return const MaterialApp(
      title: "Explore",
      home: StartupScreen(),
    );
  }
}
