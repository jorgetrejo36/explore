import 'package:explore/screens/game_result_screen.dart';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:explore/widgets/geyser_choice.dart';
import 'package:explore/widgets/geyser_data_repo.dart';
import 'package:explore/widgets/life_app_bar.dart';
import 'package:explore/widgets/life_counter.dart';
import 'package:explore/widgets/retry_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:explore/utils/problem_generator.dart';

class GeyserGameStateful extends StatefulWidget {
  const GeyserGameStateful(
      {super.key, required this.planet, required this.geyserProblem});

  final GameTheme planet;
  final ProblemGenerator geyserProblem;

  @override
  State<GeyserGameStateful> createState() => _GeyserGameState();
}

class _GeyserGameState extends State<GeyserGameStateful> {
  int counter = 0;
  int lives = 3;
  int answer = 0;
  bool answeredQuestion = false;

  late GeneratedProblem problem = widget.geyserProblem.generateProblem();
  late int correctAnswer = problem.answerChoices.getAnswers()[0];
  late List<dynamic> choices = problem.answerChoices.getAnswers();

  int questions = 5;
  int questionsAnswered = 0;

  void increment() {
    setState(() {
      counter++;
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
      questionsAnswered++;
      if (choice == correctAnswer) {
        increment();
      } else {
        loseLife();
      }
      if ((questionsAnswered == questions) || (lives == 0)) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Center(
              child: Text(
                '$counter / $questions',
                style: const TextStyle(
                  fontFamily: 'Fredoka',
                ),
              ),
            ),
            actions: <Widget>[
              Center(
                child: counter / questions < 0.8
                    ? IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/reload.svg',
                          colorFilter:
                              ColorFilter.mode(Colors.black, BlendMode.srcIn),
                          semanticsLabel: "arrow pointing in circle",
                          height: 50,
                          width: 50,
                        ),
                        // Navigate back when the back button is pressed
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GeyserGameStateful(
                                planet: widget.planet,
                                geyserProblem: widget.geyserProblem),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GameResultScreen(),
                          ),
                        ),
                        child: const Text("Game Complete"),
                      ),
              )
            ],
          ),
        );
      }
      answeredQuestion = !answeredQuestion;
    });
  }

  void nextQuestion(bool newAnsweredQuestion) {
    setState(() {
      problem = widget.geyserProblem.generateProblem();
      choices = problem.answerChoices.getAnswers();
      correctAnswer = problem.answerChoices.getAnswers()[0];
      choices.shuffle();
      answeredQuestion = newAnsweredQuestion;
    });
  }

  void checkLives() {}

  @override
  Widget build(BuildContext context) {
    GeyserRepo geyserRepo = new GeyserRepo();
    Map<String, String> skins = geyserRepo.getVariant(widget.planet);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: LifeAppBar(
        item: skins['item']!,
        title: "App Bar",
        counter: counter,
        titleWidget: LifeCounterStateful(lives: lives),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(skins['background']!),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              right: MediaQuery.of(context).size.width / 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      problem.problem.getProblemString(),
                      style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 60,
                          color: Colors.white),
                    ),
                    !answeredQuestion
                        ? IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              iconSize: 50,
                            ),
                            icon: const Icon(Icons.arrow_right_rounded),
                            onPressed: () => {answerQuestion(answer)},
                          )
                        : Column(
                            children: [
                              SvgPicture.asset(
                                correctAnswer == answer
                                    ? 'assets/images/right.svg'
                                    : 'assets/images/wrong.svg',
                                width: 70,
                                height: 70,
                              ),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    iconSize: 50,
                                  ),
                                  icon: Icon(Icons.arrow_right_rounded),
                                  onPressed: () =>
                                      {nextQuestion(!answeredQuestion)},
                                ),
                              )
                            ],
                          )
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
                      GeyserChoiceStateful(
                        handleState: handleState,
                        choice: choices[0],
                        answer: answer,
                        correctAnswer: correctAnswer,
                        answeredQuestion: answeredQuestion,
                        item: skins['item']!,
                        top: skins['top']!,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SvgPicture.asset(
                          skins['ground']!,
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
                      GeyserChoiceStateful(
                        handleState: handleState,
                        choice: choices[1],
                        answer: answer,
                        correctAnswer: correctAnswer,
                        answeredQuestion: answeredQuestion,
                        item: skins['item']!,
                        top: skins['top']!,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SvgPicture.asset(
                          skins['ground']!,
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
                      GeyserChoiceStateful(
                        handleState: handleState,
                        choice: choices[2],
                        answer: answer,
                        correctAnswer: correctAnswer,
                        answeredQuestion: answeredQuestion,
                        item: skins['item']!,
                        top: skins['top']!,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SvgPicture.asset(
                          skins['ground']!,
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
      ),
    );
  }
}
