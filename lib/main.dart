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
    // this will give you problems from levels 1 - 7
    ProblemGenerator problemGenerator = ProblemGenerator(7, false);
    GeneratedProblem generatedProblem = problemGenerator.generateProblem();
    print(generatedProblem);

    return const MaterialApp(
      title: "Explore",
      home: StartupScreen(),
    );
  }
}
