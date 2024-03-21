import 'package:explore/screens/startup_screen.dart';
import 'package:explore/utils/problem_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
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
