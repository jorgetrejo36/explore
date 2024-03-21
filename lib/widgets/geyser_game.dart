import 'package:explore/screens/game_result_screen.dart';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:explore/utils/realm_utils.dart';
import 'package:explore/widgets/geyser_choice.dart';
import 'package:explore/widgets/geyser_data_repo.dart';
import 'package:explore/widgets/life_app_bar.dart';
import 'package:explore/widgets/life_counter.dart';
import 'package:explore/widgets/score_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:explore/utils/problem_generator.dart';
import 'package:audioplayers/audioplayers.dart';

class GeyserGameStateful extends StatefulWidget {
  const GeyserGameStateful({
    super.key,
    required this.level,
    required this.planet,
    required this.geyserProblem,
  });

  final int level;
  final GameTheme planet;
  final ProblemGenerator geyserProblem;

  @override
  State<GeyserGameStateful> createState() => _GeyserGameState();
}

class _GeyserGameState extends State<GeyserGameStateful> {
  // Variables
  int counter = 0;
  int lives = 3;
  int answer = -1;
  bool answeredQuestion = false;
  int questions = 5;
  int questionsAnswered = 0;
  late String playerAvatar = "";
  late RocketAvatar rocketAvatar;

  // Problem Generator Varibles
  late GeneratedProblem problem = widget.geyserProblem.generateProblem();
  late int correctAnswer = problem.answerChoices.getAnswers()[0];
  late List<dynamic> choices = problem.answerChoices.getAnswers();

  // Timer
  final timer = Stopwatch();
  late int finalTime = (timer.elapsedMilliseconds / 1000).round();

  @override
  void initState() {
    super.initState();
    _loadData();
    timer.start();
  }

  // For item counter
  void increment() {
    setState(() {
      counter++;
    });
  }

  // For life counting
  void loseLife() {
    setState(() {
      lives--;
    });
  }

  // Player chooses between choices
  void handleState(choice) {
    setState(() {
      answer = choice;
    });
  }

  // Player answers question
  void answerQuestion(choice) {
    setState(() {
      questionsAnswered++;
      if (choice == correctAnswer) {
        increment();
      } else {
        loseLife();
      }

      // Pop up of retry or game results
      if ((questionsAnswered == questions) || (lives == 0)) {
        timer.stop();
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
                    // Retry game
                    ? IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/reload.svg',
                          colorFilter:
                              ColorFilter.mode(Colors.black, BlendMode.srcIn),
                          semanticsLabel: "arrow pointing in circle",
                          height: 50,
                          width: 50,
                        ),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GeyserGameStateful(
                              level: widget.level,
                              planet: widget.planet,
                              geyserProblem: widget.geyserProblem,
                            ),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        // Game result screen
                        onPressed: () => {
                          Navigator.pop(context),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameResultScreen(
                                game: Game.geyser,
                                level: widget.level,
                                planet: widget.planet,
                                currency: counter,
                                time: finalTime,
                              ),
                            ),
                          ),
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                        ),
                        child: const Icon(
                          Icons.arrow_right_rounded,
                          color: Colors.black,
                          size: 60,
                        ),
                      ),
              )
            ],
          ),
        );
      }
      answeredQuestion = !answeredQuestion;
    });
  }

  // Generates new question and choices, resets player position to the middle position
  void nextQuestion(bool newAnsweredQuestion) {
    setState(() {
      problem = widget.geyserProblem.generateProblem();
      choices = problem.answerChoices.getAnswers();
      correctAnswer = problem.answerChoices.getAnswers()[0];
      choices.shuffle();
      answer = choices[1];
      answeredQuestion = newAnsweredQuestion;
    });
  }

  Future<void> _loadData() async {
    try {
      playerAvatar = RealmUtils().getAvatarPath();
      rocketAvatar = RealmUtils().getRocketAvatar();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _loadData() async {
    try {
      playerAvatar = RealmUtils().getAvatarPath();
      rocketAvatar = RealmUtils().getRocketAvatar();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future playCorrectSound() async {
    final player = AudioPlayer();
    return player.play(AssetSource("sound/correct.mp3"));
  }

  Future playWrongSound() async {
    final player = AudioPlayer();
    return player.play(AssetSource("sound/wrong.mp3"));
  }

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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 1,
                  child: FittedBox(
                    alignment: Alignment.center,
                    child: Text(
                      problem.problem.getProblemString(),
                      style:
                          TextStyle(fontFamily: 'Fredoka', color: Colors.white),
                      textAlign: TextAlign.center,
                      softWrap: true, // Allows text wrapping
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: !answeredQuestion
                        ? answer != -1
                            ? IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  iconSize:
                                      MediaQuery.of(context).size.height / 16,
                                ),
                                icon: const Icon(Icons.arrow_right_rounded),
                                onPressed: () {
                                  answerQuestion(answer);

                                  if (answer == correctAnswer) {
                                    playCorrectSound();
                                  } else {
                                    playWrongSound();
                                  }
                                },
                              )
                            : null
                        : Column(
                            children: [
                              SvgPicture.asset(
                                correctAnswer == answer
                                    ? 'assets/images/right.svg'
                                    : 'assets/images/wrong.svg',
                                height: MediaQuery.of(context).size.height / 14,
                                width: MediaQuery.of(context).size.height / 14,
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height / 30),
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    iconSize:
                                        MediaQuery.of(context).size.height / 17,
                                  ),
                                  icon: const Icon(Icons.arrow_right_rounded),
                                  onPressed: () =>
                                      {nextQuestion(!answeredQuestion)},
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ],
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
                        playerAvatar: playerAvatar,
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
                          height: MediaQuery.of(context).size.height / 6,
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
                        playerAvatar: playerAvatar,
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
                          height: MediaQuery.of(context).size.height / 4,
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
                        playerAvatar: playerAvatar,
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
                          height: MediaQuery.of(context).size.height / 6,
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
