import 'package:explore/screens/game_result_screen.dart';
import 'package:explore/widgets/geyser_choice.dart';
import 'package:explore/widgets/life_app_bar.dart';
import 'package:explore/widgets/life_counter.dart';
import 'package:explore/widgets/retry_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

  void handleState(choice) {
    setState(() {
      answer = choice;
    });
  }

  void answerQuestion(choice) {
    setState(() {
      answeredQuestion = !answeredQuestion;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            'assets/images/mars-bg.svg',
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
                  ElevatedButton(
                    onPressed: () => {answerQuestion(answer)},
                    child: const Text("Answer"),
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
                      choice: choiceOne,
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
                      choice: choiceTwo,
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
                      choice: choiceThree,
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
