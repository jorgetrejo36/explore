import 'package:flutter/material.dart';
// ignore: unused_import
import '../screens/game_result_screen.dart';
import '../screens/planet_map_screen.dart';
// ignore: unused_import
import 'shooting_themes.dart';
// ignore: unused_import
import 'package:explore/widgets/retry_window.dart';
import 'package:explore/utils/problem_generator.dart';
import 'package:explore/widgets/sg_info_bar.dart';
import 'package:explore/widgets/sg_player_rocket.dart';
// ignore: unused_import
import 'package:explore/widgets/sg_obstacle_container.dart';

class ShootingGameStateful extends StatefulWidget {
  const ShootingGameStateful(
      {super.key, required this.planet, required this.shootingProblem});

  // Stores the planet this game is themed to (coming soon) and
  // its associated problem set.
  final GameTheme planet;
  final ProblemGenerator shootingProblem;

  @override
  State<ShootingGameStateful> createState() => _ShootingGameState();
}

class _ShootingGameState extends State<ShootingGameStateful> {
  // How many problems does the player have to answer for this game?
  int numProblems = 5;
  // How many lives does the player have left? Starts with 3.
  int livesLeft = 3;
  // How many problems in total has the player answered (right or wrong)?
  int problemsAnswered = 0;
  // How many problems has the player gotten correct or incorrect, individually?
  // The first is used to keep track of
  int problemsCorrect = 0;
  int problemsWrong = 0;
  // Stores the answer choice the player selects.
  int answerChoice = 0;
  // Has the player answered the current problem yet?
  bool hasAnswered = false;
  // Has the game started?
  bool gameStarted = false;

  // Stores the problem the player has to answer.
  late GeneratedProblem problem = widget.shootingProblem.generateProblem();
  // Stores the correct answer and list of answer choices to the current problem.
  late int correctAnswer = problem.answerChoices.getAnswers()[0];
  late List<dynamic> choices = problem.answerChoices.getAnswers();

  // What's the player rocket's X and Y positions at initialization?
  late double rocketXPos;
  late double rocketYPos;
  // Is the rocket on?
  bool rocketOn = false;

  // What are the X positions of the columns?
  late double leftX;
  late double centerX;
  late double rightX;

  // What column is the player in?
  late String rocketColumn = "center";

  @override
  void didChangeDependencies() {
    // Sets player rocket to center ground on initialization.
    super.didChangeDependencies();
    rocketXPos = MediaQuery.of(context).size.width / 2 - 35;
    rocketYPos = MediaQuery.of(context).size.height - 255;
    rocketColumn = "center";

    // Set column positions
    leftX = rocketXPos - 150;
    centerX = rocketXPos;
    rightX = rocketXPos + 150;
  }

  // Function to move the rocket
  void moveRocket(String column) {
    setState(() {
      if (column == "left")
        {
          // Move left.
          rocketXPos = leftX;
          rocketColumn = "left";
        }
      if (column == "center")
        {
          // Move center.
          rocketXPos = centerX;
          rocketColumn = "center";
        }
      else if (column == "right")
        {
          // Move right.
          rocketXPos = rightX;
          rocketColumn = "right";
        }
      else if (column == "up1")
        {
          // Game starting, move rocket UP.
          rocketYPos -= 175;
        }
    });

    print("Player rocket moved to $rocketColumn column.");
  }

  // Generate a new problem.
  void nextQuestion(bool newAnsweredQuestion) {
    setState(() {
      problem = widget.shootingProblem.generateProblem();
    });
  }


  void dropObstacles()
  {
    print("Dropping obstacles.");
  }

  void startGame()
  {
    // Start the game, move the rocket up, and load questions!
    setState(() {
      gameStarted = true;
    });

    // Move rocket up and turn it on so it's ready.
    moveRocket("up1");
    rocketOn = true;

    // Load the first problem.
    // nextProblem() here.
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      // Transparent AppBar to store the back button.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
          // Circle around back button.
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            shape: BoxShape.rectangle,
            color: const Color(0xFFCCCCCB),
          ),

          // Back button arrow and functionality. Will need to add a
          // warning if you quit a game before it is complete!
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),

            // Navigate back when the back button is pressed.
            // Will be an issue on game end screen, update!
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [

          // Background sky gradient for the game (all art will
          // change soon to use shooting_themes.dart).
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 144, 195, 243),
                  Color.fromARGB(255, 218, 231, 247),
                ],
              ),
            ),
          ),

          // Clouds (sky_art) for the Earth shooting game.
          Visibility(
            visible: !gameStarted,
            child: Positioned(
              top: 0,
              child: Image.asset(
                'assets/images/shooting_earth_sky_art.png',
                height: MediaQuery.of(context).size.height * 1.05,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),

          // Ground (ground_art) for the Earth shooting game.
          Visibility(
            visible: !gameStarted,
            child: Positioned(
              bottom: 0,
              child: Image.asset(
                'assets/images/shooting_earth_ground_art.png',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
            ),
          ),

          // Game Info bar (displays question, lives, rewards)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SGInfoBar(),
          ),

          // Player rocket:
          SGPlayerRocket(
              isOn: rocketOn,
              rocketX: rocketXPos,
              rocketY: rocketYPos,
          ),

          // Right answer button.
          Visibility(
            visible: gameStarted,
            child: Positioned(
              bottom: 16,
              right: 16,
              child: TextButton(
                onPressed: () {
                  moveRocket("right");
                },
                child: Text('Right Answer'),
              ),
            ),
          ),

          // Center answer button
          Visibility(
            visible: gameStarted,
            child: Positioned(
              bottom: 16,
              left: MediaQuery.of(context).size.width / 3,
              child: TextButton(
                onPressed: () {
                  moveRocket("center");
                },
                child: Text('Center Answer'),
              ),
            ),
          ),

          // Left answer button
          Visibility(
            visible: gameStarted,
            child: Positioned(
              bottom: 16,
              left: 16,
              child: TextButton(
                onPressed: () {
                  moveRocket("left");
                },
                child: Text('Left Answer'),
              ),
            ),
          ),

          Center(
            child: Visibility(
              visible: !gameStarted,
              child: ElevatedButton(
                onPressed: startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set button color to white
                ),
                child: const Text('Start Game',  style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                )
                ),
              ),
            ),
          ),

          // Button to make objects fall
          Center(
            child: Visibility(
              visible: gameStarted,
              child: ElevatedButton(
                onPressed: dropObstacles,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Set button color to white
                ),
                child: const Text('Drop Obstacles',  style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}