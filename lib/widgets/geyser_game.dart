import 'package:explore/screens/game_result_screen.dart';
import 'package:explore/widgets/geyser_choice.dart';
import 'package:explore/widgets/geyser_data_repo.dart';
import 'package:explore/widgets/life_app_bar.dart';
import 'package:explore/widgets/life_counter.dart';
import 'package:explore/widgets/retry_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:explore/utils/problem_generator.dart';

class GeyserGameStateful extends StatefulWidget {
  const GeyserGameStateful({super.key});

  @override
  State<GeyserGameStateful> createState() => _GeyserGameState();
}

class _GeyserGameState extends State<GeyserGameStateful> {
  int counter = 0;
  int lives = 3;
  int answer = 0;
  bool answeredQuestion = false;
  int correctAnswer = 25;
  int choiceOne = 5;
  int choiceTwo = 10;
  int choiceThree = 25;
  late List<dynamic> choices = [choiceOne, choiceTwo, choiceThree];

  int questions = 5;
  int questionsRight = 0;

  void increment() {
    setState(() {
      print(choices);
      counter++;
      print(counter);
      ProblemGenerator problemGenerator = ProblemGenerator(2, true);
      GeneratedProblem generatedProblem = problemGenerator.generateProblem();

      print(generatedProblem.problem.getX());
      print(generatedProblem.problem.getOperator());
      print(generatedProblem.problem.getY());

      print("Hello");

      print(generatedProblem.answerChoices.getWrongAnswer1());
      print(generatedProblem.answerChoices.getWrongAnswer2());
      print(generatedProblem.answerChoices.getCorrectAnswer());
    });
  }

  void loseLife() {
    setState(() {
      lives--;
    });
  }

  void handleState(choice) {
    setState(() {
      answer = choice;
    });
  }

  void answerQuestion(choice) {
    setState(() {
      if (choice == correctAnswer) {
        increment();
      } else {
        loseLife();
      }
      answeredQuestion = !answeredQuestion;
    });
  }

  void nextQuestion() {
    setState(() {
      answeredQuestion = !answeredQuestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    GeyserRepo geyserRepo = new GeyserRepo();
    Map<String, String> skins = geyserRepo.getVariant('mars');
    print(skins);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: LifeAppBar(
        item: 'assets/images/ruby.svg',
        title: "App Bar",
        counter: counter,
        titleWidget: LifeCounterStateful(lives: lives),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            skins['background']!,
            alignment: Alignment.center,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            right: MediaQuery.of(context).size.width / 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "5 x 2",
                    style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 60,
                        color: Colors.white),
                  ),
                  !answeredQuestion
                      ? ElevatedButton(
                          onPressed: () => {answerQuestion(answer)},
                          child: const Text("Answer"),
                        )
                      : ElevatedButton(
                          onPressed: () => {nextQuestion()},
                          child: const Text("Continue"),
                        ),
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
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GeyserChoice(
                      handleState: handleState,
                      choice: choices[0],
                      answer: answer,
                      correctAnswer: correctAnswer,
                      answeredQuestion: answeredQuestion,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: SvgPicture.asset(
                        'assets/images/geyser-off.svg',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GeyserChoice(
                      handleState: handleState,
                      choice: choices[1],
                      answer: answer,
                      correctAnswer: correctAnswer,
                      answeredQuestion: answeredQuestion,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: SvgPicture.asset(
                        'assets/images/geyser-off.svg',
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GeyserChoice(
                      handleState: handleState,
                      choice: choices[2],
                      answer: answer,
                      correctAnswer: correctAnswer,
                      answeredQuestion: answeredQuestion,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: SvgPicture.asset(
                        'assets/images/geyser-off.svg',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
