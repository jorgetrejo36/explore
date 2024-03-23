import 'dart:ffi';
import 'dart:math';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:explore/widgets/racing_themes.dart';
import 'package:explore/widgets/score_calculator.dart';
import 'package:flutter/material.dart';
import 'package:explore/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:explore/utils/problem_generator.dart';
import 'package:explore/screens/game_result_screen.dart';
import 'package:flutter/services.dart';
import 'package:explore/utils/realm_utils.dart';

/// Creates instance of mining game given a specified theme and problem generator
class RacingGame extends StatefulWidget {
  final GameTheme planet;
  final ProblemGenerator racingProblem;
  final int level;
  const RacingGame({
    super.key,
    required this.level,
    required this.planet,
    required this.racingProblem,
  });

  @override
  State<RacingGame> createState() => _RacingGameState();
}

class _RacingGameState extends State<RacingGame>
    with SingleTickerProviderStateMixin {
  // Theme Variables
  late RacingTheme theme = RacingTheme(widget.planet);

  // Problem Variable Initialization
  late GeneratedProblem problem1 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem2 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem3 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem4 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem5 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem6 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem7 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem8 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem9 = widget.racingProblem.generateProblem();
  late GeneratedProblem problem10 = widget.racingProblem.generateProblem();
  // List of problem objects to reference
  late List<GeneratedProblem> problemList = [
    problem1,
    problem2,
    problem3,
    problem4,
    problem5,
    problem6,
    problem7,
    problem8,
    problem9,
    problem10,
  ];

  // Player animation points
  late List<List<double>> playerLocations = [
    [
      MediaQuery.of(context).size.width * 0.12,
      MediaQuery.of(context).size.width * 0.22
    ],
    [
      MediaQuery.of(context).size.width * 0.22,
      MediaQuery.of(context).size.width * 0.34
    ],
    [
      MediaQuery.of(context).size.width * 0.34,
      MediaQuery.of(context).size.width * 0.46
    ],
    [
      MediaQuery.of(context).size.width * 0.46,
      MediaQuery.of(context).size.width * 0.58
    ],
    [
      MediaQuery.of(context).size.width * 0.58,
      MediaQuery.of(context).size.width * 0.70
    ],
    [
      MediaQuery.of(context).size.width * 0.70,
      MediaQuery.of(context).size.width * 0.95
    ],
  ];

  // Player point data
  int animationIterator = 0;
  int enemy1Location = 0;
  int enemy2Location = 0;

  // Current Problem Data Generation
  late List<int> curChoices =
      problemList[currentProblem].answerChoices.getAnswers();
  late int curSolution =
      problemList[currentProblem].answerChoices.getAnswers()[0];
  int currentProblem = 0;

  // Player variables
  int playerLocation = 0;
  bool correct = false;
  bool test = true;
  late LeaderboardEntry player = LeaderboardEntry(playerAvatar, 0, "player");
  late String playerAvatar = "";
  late RocketAvatar rocketAvatar;

  // EnemyAI Data
  LeaderboardEntry enemy1 =
      LeaderboardEntry("assets/images/alien.svg", 0, "enemy");
  LeaderboardEntry enemy2 =
      LeaderboardEntry("assets/images/alien3.svg", 0, "enemy");

  // Leaderboard data
  late List<LeaderboardEntry> leaderboardData = [player, enemy1, enemy2];
  final timer = Stopwatch();
  late int finalTime = (timer.elapsedMilliseconds / 1000).round();

  void selectAnswer(int choiceNum) {
    decideEnemyMovement();

    if (curChoices[choiceNum] == curSolution) {
      setState(() {
        test = !test;
        animationIterator++;
        playerLocation++;
        player.incrementScore();
        test = !test;
      });
    }
    updateLeaderboard();
    checkGameEnd();
  }

  void setNextProblem() {
    setState(() {
      currentProblem++;
      curChoices = problemList[currentProblem].answerChoices.getAnswers();
      curSolution = problemList[currentProblem].answerChoices.getAnswers()[0];
      curChoices.shuffle();
    });
  }

  int determinePlacement() {
    if (player.score >= enemy1Location && player.score >= enemy2Location) {
      return 1;
    } else if ((player.score < enemy1Location) ||
        (player.score < enemy2Location)) {
      return 2;
    } else {
      return 3;
    }
  }

  void checkGameEnd() {
    if (playerLocation > 4 || enemy1Location > 4 || enemy2Location > 4) {
      timer.stop;
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Center(
            child: Text(
              '#${determinePlacement()}',
              style: const TextStyle(
                fontSize: 50,
                fontFamily: 'Fredoka',
              ),
            ),
          ),
          actions: <Widget>[
            Center(
              child: (playerLocation <= 4)
                  ? IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/reload.svg',
                        colorFilter:
                            ColorFilter.mode(Colors.black, BlendMode.srcIn),
                        semanticsLabel: "arrow pointing in circle",
                        height: 50,
                        width: 50,
                      ),
                      onPressed: () async => {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitUp,
                        ]),
                        // pop the dialog window
                        Navigator.pop(context),
                        // replace the game page with the game again to retry it
                        await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RacingGame(
                              level: widget.level,
                              planet: widget.planet,
                              racingProblem: widget.racingProblem,
                            ),
                          ),
                        ),
                      },
                    )
                  : ElevatedButton(
                      onPressed: () async => {
                        SystemChrome.setPreferredOrientations(
                          [
                            DeviceOrientation.portraitUp,
                          ],
                        ),
                        // pop the dialog windown
                        Navigator.pop(context),
                        // replace the game page with the game result screen
                        await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameResultScreen(
                              game: Game.racing,
                              level: widget.level,
                              planet: widget.planet,
                              currency: player.score,
                              time: finalTime,
                            ),
                          ),
                        ),
                      },
                      child: const Text("Game Complete"),
                    ),
            )
          ],
        ),
      );
    } else {
      setNextProblem();
    }
  }

  void decideEnemyMovement() {
    int rng = Random().nextInt(100);

    if (rng <= 10) {
      setState(() {
        enemy1Location++;
        enemy2Location++;
        enemy1.incrementScore();
        enemy2.incrementScore();
      });
    } else if (rng <= 50) {
      setState(() {
        enemy1Location++;
        enemy1.incrementScore();
      });
    } else if (rng > 40) {
      setState(() {
        enemy2Location++;
        enemy2.incrementScore();
      });
    }
  }

  void updateLeaderboard() {
    setState(() {
      leaderboardData.sort((a, b) => b.score.compareTo(a.score));
    });
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

  void repeatOnce() async {
    await _controller.forward();
    await _controller.reverse();
  }

  Future<void> _loadData() async {
    try {
      playerAvatar = RealmUtils().getAvatarPath();
      rocketAvatar = RealmUtils().getRocketAvatar();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    timer.start();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //repeatOnce();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: true,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xfff6f6f6),
                size: 35,
              ),
              // Navigate back when the back button is pressed
              onPressed: () => {
                SystemChrome.setPreferredOrientations(
                  [
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ],
                ),
                Navigator.pop(context),
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: MediaQuery.of(context).orientation == Orientation.portrait
              ? racing_start_screen(
                  theme: theme,
                  avatar: playerAvatar,
                  rocketAvatar: rocketAvatar,
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("assets/images/${theme.background}.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Game Info
                      Container(
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: Row(
                          children: [
                            // Equation and Solutions
                            Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.08),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.226,
                                      margin: EdgeInsets.symmetric(
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                      ),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color:
                                            Color.fromARGB(239, 248, 248, 248),
                                      ),
                                      child: Center(
                                        child: AnimatedSwitcher(
                                          duration: Duration(milliseconds: 800),
                                          child: Text(
                                            problemList[currentProblem]
                                                .problem
                                                .getProblemString(),
                                            key: ValueKey(
                                                problemList[currentProblem]
                                                    .problem
                                                    .getProblemString()),
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    238, 31, 31, 31),
                                                fontSize: 55,
                                                fontFamily: 'Fredoka'),
                                            //textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          selectAnswer(0);
                                        },
                                        child: Container(
                                          width: 75,
                                          height: 75,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                          ),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            color: Color.fromARGB(
                                                239, 248, 248, 248),
                                          ),
                                          child: Center(
                                            child: AnimatedSwitcher(
                                              duration:
                                                  Duration(milliseconds: 800),
                                              child: Text(
                                                "${curChoices[0]}",
                                                key: ValueKey(curChoices[0]),
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        238, 31, 31, 31),
                                                    fontSize: 50,
                                                    fontFamily: 'Fredoka'),
                                                //textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          selectAnswer(1);
                                        },
                                        child: Container(
                                          width: 75,
                                          height: 75,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                          ),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            color: Color.fromARGB(
                                                239, 248, 248, 248),
                                          ),
                                          child: Center(
                                            child: AnimatedSwitcher(
                                              duration:
                                                  Duration(milliseconds: 800),
                                              child: Text(
                                                "${curChoices[1]}",
                                                key: ValueKey(curChoices[1]),
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        238, 31, 31, 31),
                                                    fontSize: 50,
                                                    fontFamily: 'Fredoka'),
                                                //textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          selectAnswer(2);
                                        },
                                        child: Container(
                                          width: 75,
                                          height: 75,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                          ),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            color: Color.fromARGB(
                                                239, 248, 248, 248),
                                          ),
                                          child: Center(
                                            child: AnimatedSwitcher(
                                              duration:
                                                  Duration(milliseconds: 800),
                                              child: Text(
                                                "${curChoices[2]}",
                                                key: ValueKey(curChoices[2]),
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        238, 31, 31, 31),
                                                    fontSize: 50,
                                                    fontFamily: 'Fredoka'),
                                                //textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // Leaderboard
                            Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "1.",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    239, 248, 248, 248),
                                                fontSize: 46,
                                                fontFamily: 'Fredoka'),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 19),
                                          child: SvgPicture.asset(
                                            '${leaderboardData[0].sprite}',
                                            height: 50,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "2.",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    239, 248, 248, 248),
                                                fontSize: 46,
                                                fontFamily: 'Fredoka'),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: SvgPicture.asset(
                                            '${leaderboardData[1].sprite}',
                                            height: 50,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "3.",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    239, 248, 248, 248),
                                                fontSize: 46,
                                                fontFamily: 'Fredoka'),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: SvgPicture.asset(
                                            '${leaderboardData[2].sprite}',
                                            height: 50,
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      // Player Tracks
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 5),
                        child: Stack(
                          children: <Widget>[
                            AnimatedPositioned(
                              left: test
                                  ? playerLocations[enemy1Location][0]
                                  : playerLocations[enemy1Location][1],
                              duration: const Duration(seconds: 2),
                              curve: Curves.fastOutSlowIn,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    test = !test;
                                    currentProblem++;
                                    test = !test;
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/images/UFO2.svg',
                                  height: 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.13,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: <Widget>[
                            AnimatedPositioned(
                              left: test
                                  ? playerLocations[enemy2Location][0]
                                  : playerLocations[enemy2Location][1],
                              duration: const Duration(seconds: 2),
                              curve: Curves.fastOutSlowIn,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    test = !test;
                                    currentProblem++;
                                    test = !test;
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/images/UFO1.svg',
                                  height: 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: <Widget>[
                            AnimatedPositioned(
                                left: test
                                    ? playerLocations[animationIterator][0]
                                    : playerLocations[animationIterator][1],
                                duration: const Duration(seconds: 2),
                                curve: Curves.fastOutSlowIn,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      test = !test;
                                      currentProblem++;
                                      test = !test;
                                    });
                                  },
                                  child: Container(
                                    child: SvgPicture.asset(
                                      'assets/images/${theme.playerVehicle}.svg',
                                      height: 65,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
}

class racing_start_screen extends StatefulWidget {
  const racing_start_screen(
      {super.key,
      required this.theme,
      required this.avatar,
      required this.rocketAvatar});

  final RacingTheme theme;
  final String avatar;
  final RocketAvatar rocketAvatar;
  @override
  State<racing_start_screen> createState() => _racing_start_screenState();
}

class _racing_start_screenState extends State<racing_start_screen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage("assets/images/${widget.theme.racingStart}.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (widget.theme.theme != 'saturn')
          Container(
            margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.35,
                top: MediaQuery.of(context).size.height * 0.73),
            child: Stack(
              children: [
                Container(
                  child: SvgPicture.asset(
                    'assets/images/${widget.theme.playerVehicle}.svg',
                    height: 150,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 70, top: 60),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14159),
                    child: SvgPicture.asset(
                      widget.avatar,
                      height: 60,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (widget.theme.theme == 'saturn')
          Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.45,
                  top: MediaQuery.of(context).size.height * 0.73),
              child: Stack(
                children: [
                  // Rocket SVG
                  SvgPicture.asset(
                    widget.rocketAvatar.rocketPath,
                    width: 80,
                    fit: BoxFit.contain,
                    // Path to your bottom SVG file Adjust the width as needed
                  ),
                  // Top SVG
                  Positioned(
                    left: 22,
                    bottom: 75,
                    child: ClipOval(
                      child: Transform.scale(
                        scale: 1.1,
                        child: SvgPicture.asset(
                          widget.rocketAvatar.avatarPath,
                          width:
                              37, // Path to your top SVG file Adjust the width as needed
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        Center(
          child: FadeTransition(
            opacity: _animation,
            child: Center(
                child: Image(
              image: AssetImage("assets/images/rotate-smartphone.png"),
              width: 200,
            )),
          ),
        ),
      ],
    );
  }
}

class LeaderboardEntry {
  late String sprite;
  late int score;
  late String type;
  LeaderboardEntry(String playerSprite, int playerScore, String playerType) {
    sprite = playerSprite;
    score = playerScore;
    type = playerType;
  }

  void incrementScore() {
    score++;
  }
}
