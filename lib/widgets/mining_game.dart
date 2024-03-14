import 'dart:math';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:explore/widgets/mining_themes.dart';
import 'package:explore/widgets/score_calculator.dart';
import 'package:flutter/material.dart';
import 'package:explore/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:explore/utils/problem_generator.dart';
import 'package:explore/screens/game_result_screen.dart';

/// Creates instance of mining game given a specified theme and problem generator
class MiningGame extends StatefulWidget {
  final GameTheme planet;
  final int level;
  final ProblemGenerator miningProblem;
  const MiningGame({
    super.key,
    required this.planet,
    required this.level,
    required this.miningProblem,
  });

  @override
  State<MiningGame> createState() => _MiningGameState();
}

class _MiningGameState extends State<MiningGame>
    with SingleTickerProviderStateMixin {
  // Theme Variables
  late MiningTheme theme = MiningTheme(widget.planet);

  // Problem Variable Initialization
  late GeneratedProblem problem1 = widget.miningProblem.generateProblem();
  late GeneratedProblem problem2 = widget.miningProblem.generateProblem();
  late GeneratedProblem problem3 = widget.miningProblem.generateProblem();
  late GeneratedProblem problem4 = widget.miningProblem.generateProblem();
  late GeneratedProblem problem5 = widget.miningProblem.generateProblem();

  // List of problem objects to reference
  late List<GeneratedProblem> problemList = [
    problem1,
    problem2,
    problem3,
    problem4,
    problem5,
  ];

  late List<MiningRow> miningRowList = [
    MiningRow(theme: this.theme, problem: problem1, update: _updateQuestion)
  ];

  List<bool> problemVisibility = [false, false, false, false, false];
  int currentProblem = 0;

  // Player variables
  int score = 0;
  bool correct = false;
  final timer = Stopwatch();
  late int finalTime = (timer.elapsedMilliseconds / 1000).round();

  // Pushes game results screen to user
  // Todo: Send game data to second screen
  void gameFinish() {
    timer.stop();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(
          child: Text(
            '${score} / 5',
            style: const TextStyle(
              fontFamily: 'Fredoka',
            ),
          ),
        ),
        actions: <Widget>[
          Center(
            child: score / 5 < 0.8
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
                        builder: (context) => MiningGame(
                          planet: widget.planet,
                          level: widget.level,
                          miningProblem: widget.miningProblem,
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
                            game: Game.mining,
                            level: widget.level,
                            planet: GameTheme.earth,
                            currency: score,
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

  // Displays the problem in the list to the game
  void newQuestion(int problemNum) {
    setState(() {
      miningRowList.add(MiningRow(
          theme: theme,
          problem: problemList[problemNum],
          update: _updateQuestion));
    });
  }

  // Iterates problem list by one, then deicdes to either end game or update the question
  _updateQuestion(int level) {
    if (level == 0) {
      displayIncorrect();
      currentProblem = currentProblem + 1;
    } else if (level == 1) {
      displayCorrect();
      setState(() {
        currentProblem = currentProblem + level;
        score++;
        //correct = false;
      });
    }
    if (currentProblem < 5) {
      newQuestion(currentProblem);
    } else {
      gameFinish();
    }
  }

  displayCorrect() {
    setState(() {
      correct = true;
    });
    repeatOnce();
  }

  displayIncorrect() {
    setState(() {
      correct = false;
    });
    repeatOnce();
  }

  // Correctness Animations
  double startingOpacity = 0;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );
  @override
  void initState() {
    super.initState();
    timer.start();
    //repeatOnce();
  }

  void repeatOnce() async {
    await _controller.forward();
    await _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xfff6f6f6),
            size: 35,
          ),
          // Navigate back when the back button is pressed
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/${theme.background}.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.0445,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (currentProblem < 5)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.14,
                    child: Text(
                      problemList[currentProblem].problem.getProblemString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.white,
                          fontFamily: 'Fredoka',
                          fontSize: 102),
                    ),
                  ),
                if (currentProblem >= 5)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: const Text(
                      "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.white,
                          fontFamily: 'Fredoka',
                          fontSize: 102),
                    ),
                  ),
                Stack(
                  children: [
                    if (correct == true)
                      FadeTransition(
                        opacity: _animation,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.085,
                            margin: EdgeInsets.only(
                                top:
                                    MediaQuery.of(context).size.height * 0.005),
                            child: SvgPicture.asset('assets/images/right.svg')),
                      ),
                    if (correct == false)
                      FadeTransition(
                        opacity: _animation,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.085,
                            margin: EdgeInsets.only(
                                top:
                                    MediaQuery.of(context).size.height * 0.005),
                            child: SvgPicture.asset('assets/images/wrong.svg')),
                      ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.725,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.725,
                        child: ListView.builder(
                            physics: new NeverScrollableScrollPhysics(),
                            itemCount: miningRowList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return miningRowList[index];
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Builds a clickable row of mining objects with given problem data
class MiningRow extends StatefulWidget {
  final MiningTheme theme;
  final GeneratedProblem problem;
  final ValueChanged<int> update;

  const MiningRow(
      {super.key,
      required this.theme,
      required this.problem,
      required this.update});

  @override
  State<MiningRow> createState() => _MiningRowState();
}

class _MiningRowState extends State<MiningRow> {
  late RowData row = RowData(
    widget.theme,
    widget.problem.answerChoices.getAnswers(),
    widget.problem.answerChoices.getAnswers()[0],
  );

  void selectAnswer(int rowNumber) {
    setState(() {
      row.showNumber[rowNumber] = false;
      row.selected[rowNumber] = true;

      if (row.rowChoices[rowNumber] == row.solution) {
        //row.rowImages[rowNumber] = row.currentTheme.miningCurrency;
        row.rowRotation[rowNumber] = 0;

        row.showNumber[0] = false;
        row.showNumber[1] = false;
        row.showNumber[2] = false;

        widget.update(1);
      } else {
        widget.update(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.127,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (row.showNumber[0] == true) {
                selectAnswer(0);
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 15),
              child: AnimatedCrossFade(
                firstChild: Stack(
                  children: [
                    Transform.rotate(
                      angle: row.rowRotation[0],
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/${row.rowImages[0]}.svg',
                            height: 80,
                            width: 25,
                            semanticsLabel: "bubble",
                          ),
                        ),
                      ),
                    ),
                    if (row.showNumber[0])
                      Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: MediaQuery.of(context).size.height * 0.1,
                        //decoration: BoxDecoration(color: Colors.red),
                        child: Center(
                          child: StrokeText(
                            text: " ${row.rowChoices[0]} ",
                            textStyle: TextStyle(
                                color: AppColors.white,
                                fontFamily: 'Fredoka',
                                fontSize: 42),
                            strokeColor: AppColors.darkGrey,
                            strokeWidth: 6.5,
                          ),
                        ),
                      )
                  ],
                ),
                secondChild: Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: SvgPicture.asset(
                    'assets/images/${row.currentTheme.miningCurrency}.svg',
                    height: 80,
                    width: 25,
                    semanticsLabel: "bubble",
                  ),
                ),
                crossFadeState:
                    !(row.selected[0] && (row.rowChoices[0] == row.solution))
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 500),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (row.showNumber[1] == true) {
                selectAnswer(1);
              }
            },
            child: AnimatedCrossFade(
              firstChild: Stack(
                children: [
                  Transform.rotate(
                    angle: row.rowRotation[1],
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: SvgPicture.asset(
                        'assets/images/${row.rowImages[0]}.svg',
                        height: 80,
                        width: 25,
                        semanticsLabel: "bubble",
                      ),
                    ),
                  ),
                  if (row.showNumber[1])
                    Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      height: MediaQuery.of(context).size.height * 0.1,
                      //decoration: BoxDecoration(color: Colors.red),
                      child: Center(
                        child: StrokeText(
                          text: " ${row.rowChoices[1]} ",
                          textStyle: TextStyle(
                              color: AppColors.white,
                              fontFamily: 'Fredoka',
                              fontSize: 42),
                          strokeColor: AppColors.darkGrey,
                          strokeWidth: 6.5,
                        ),
                      ),
                    )
                ],
              ),
              secondChild: Container(
                width: MediaQuery.of(context).size.width * 0.33,
                child: SvgPicture.asset(
                  'assets/images/${row.currentTheme.miningCurrency}.svg',
                  height: 80,
                  width: 25,
                  semanticsLabel: "bubble",
                ),
              ),
              crossFadeState:
                  !(row.selected[1] && (row.rowChoices[1] == row.solution))
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 500),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (row.showNumber[2] == true) {
                selectAnswer(2);
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 25),
              child: AnimatedCrossFade(
                firstChild: Stack(
                  children: [
                    Transform.rotate(
                      angle: row.rowRotation[2],
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        child: SvgPicture.asset(
                          'assets/images/${row.rowImages[2]}.svg',
                          height: 78,
                          width: 25,
                          semanticsLabel: "bubble",
                        ),
                      ),
                    ),
                    if (row.showNumber[2])
                      Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: MediaQuery.of(context).size.height * 0.1,
                        //decoration: BoxDecoration(color: Colors.red),
                        child: Center(
                          child: StrokeText(
                            text: " ${row.rowChoices[2]} ",
                            textStyle: TextStyle(
                                color: AppColors.white,
                                fontFamily: 'Fredoka',
                                fontSize: 42),
                            strokeColor: AppColors.darkGrey,
                            strokeWidth: 6.5,
                          ),
                        ),
                      )
                  ],
                ),
                secondChild: Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: SvgPicture.asset(
                    'assets/images/${row.currentTheme.miningCurrency}.svg',
                    height: 80,
                    width: 25,
                    semanticsLabel: "bubble",
                  ),
                ),
                crossFadeState:
                    !(row.selected[2] && (row.rowChoices[2] == row.solution))
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Manages data in a given row. Includes theme, visibility, and problem data
class RowData {
  static double randomSeed = Random().nextDouble() * 360;
  List<double> rowRotation = [
    270 + randomSeed,
    90 + randomSeed,
    180 + randomSeed
  ];

  List<bool> showNumber = [true, true, true];
  List<bool> selected = [false, false, false];
  late String reward;
  late int solution;
  late List<String> rowImages;
  late List<int> rowChoices;
  late MiningTheme currentTheme;

  RowData(theme, choices, answer) {
    currentTheme = theme;
    rowImages = [
      "${currentTheme.miningSurface}",
      "${currentTheme.miningSurface}",
      "${currentTheme.miningSurface}"
    ];
    rowChoices = choices;
    reward = "${currentTheme.miningCurrency}";
    solution = answer;

    rowChoices.shuffle();
  }
}
