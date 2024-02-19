import 'dart:math';
import 'package:explore/widgets/sg_obstacle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  // How many obstacles (i.e. asteroids) should spawn per problem?
  int numObstaclesPerProblem = 3;
  // Stores how many obstacles will be generated in total.
  late int numObstacles;
  // Define a list to store generated obstacles.
  late List<SGObstacle> obstacles;
  // How many lives does the player have left? Starts with 3.
  int livesLeft = 3;
  // How many problems in total has the player answered (right or wrong)?
  int problemsAnswered = 0;
  // How many problems has the player gotten correct or incorrect, individually?
  // The first is used to keep track of
  int problemsCorrect = 0;
  int problemsWrong = 0;
  // Stores the answer choice the player selects.
  late int answerChoice;
  // Is the player allowed to click an answer?
  bool canSolve = false;
  // Has the game started?
  bool gameStarted = false;
  // Are the obstacles dropping?
  bool isDropping = false;

  // What should the range in pixels be that obstacles can randomly spawn in?
  double obstacleRangeY = 150;

  // How high should the obstacles begin to be generated?
  // Currently, they begin off-screen. Leave as such.
  double initialHeight = 100;

  // How much space should there be between
  // every set of obstacles per question?
  double obstaclePadding = 200;

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

  // Called shortly after the state loads with its dependencies.
  // Used in place of initState() for initial game loading/setup.
  // Note: This is still called before build().
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Apply the themed image paths to all assets in the game.
    applyTheme();

    // Set up the game (generate a list of & spawn obstacles, create
    // falling obstacle ticker to animate them.
    setUpGame();
  }

  void applyTheme()
  {
    // Switch planet, use based on shooting_themes.dart. Remove unused import.
  }

  // Function to generate random heights within a range
  double getRandomHeight(double minHeight, double maxHeight) {
    final random = Random();
    return minHeight + random.nextDouble() * (maxHeight - minHeight);
  }

  void setUpGame()
  {
    // Assign the instance.
    shootingGameStateInstance = this;

    // Rocket position setup (center on ground, turned off).
    rocketXPos = MediaQuery.of(context).size.width * 0.42;
    rocketYPos = MediaQuery.of(context).size.height * 0.75;
    rocketColumn = "center";

    // Set column positions
    leftX = rocketXPos - (MediaQuery.of(context).size.width * 0.3);
    centerX = rocketXPos;
    rightX = rocketXPos + (MediaQuery.of(context).size.width * 0.3);

    // Identify the number of obstacles to create.
    numObstacles = numProblems * numObstaclesPerProblem;

    // Initialize the current height range
    double currentMinHeight = initialHeight;
    double currentMaxHeight = initialHeight + obstacleRangeY;

    obstacles = List.generate(numObstacles, (index) {
      String col;
      double xPos;

      switch (index % 3)
      {
        case 0:
          col = "left";
          xPos = leftX - 4;
          break;
        case 1:
          col = "center";
          xPos = centerX - 4;
          break;
        default:
          col = "right";
          xPos = rightX - 4;
      }

      // Generate obstacleY based on the current height range
      double obstacleYVal = getRandomHeight(currentMinHeight, currentMaxHeight);

      // Update the current height range after every set of 3 obstacles
      if ((index + 1) % 3 == 0) {
        currentMinHeight = currentMaxHeight + obstaclePadding;
        currentMaxHeight = currentMinHeight + obstacleRangeY;
      }

      return SGObstacle(
        obstacleImg: "assets/images/sg_asteroid_earth.svg",
        obstacleRewardImg: "assets/images/diamond.svg",
        obstacleDestroyedImg: "assets/images/sg_asteroid_destroyed_earth.svg",
        obstacleIndex: index,
        obstacleX: xPos,
        obstacleY: -1 * obstacleYVal,
        obstacleCol: col,
      );
    });

  }

  void shootObstacle(int obstacleID)
  {
    // Get a reference to this obstacle we tapped.
    SGObstacle thisObs = obstacles[obstacleID];

    if (!canSolve || !thisObs.isDropping)
      {
        // Don't shoot an asteroid that has already stopped moving or
        // if we aren't allowed to solve things yet.
        return;
      }

    setState(() {
      if (thisObs.obstacleCol == "left")
      {
        // Move the rocket left.
        moveRocket("left");
        thisObs.isDestroyed = true;
        thisObs.isDropping = false;
      }
      else if (thisObs.obstacleCol == "center")
      {
        // Move the rocket center.
        moveRocket("center");
        thisObs.isDestroyed = true;
        thisObs.isDropping = false;
      }
      else
      {
        // Move the rocket right.
        moveRocket("right");
        thisObs.isDestroyed = true;
        thisObs.isDropping = false;
      }
    });



    int answerPicked = thisObs.answerValue;
    print("Clicked answer choice $answerPicked.");
  }

  void loseGame()
  {
    // Stop the game and obstacles from continuing.
    canSolve = false;
    for (int i = 0; i < numObstacles; i++)
    {
      obstacles[i].isDropping = false;
    }

    // Turn the rocket off.
    rocketOn = false;

    // Show the retry window.
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(
          child: Text(
            '$problemsCorrect / $numProblems',
            style: const TextStyle(
              fontFamily: 'Fredoka',
            ),
          ),
        ),
        actions: <Widget>[
          Center(
            child: problemsCorrect / numProblems < 0.8
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
                  builder: (context) => ShootingGameStateful(
                      planet: widget.planet,
                      shootingProblem: widget.shootingProblem),
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
                    builder: (context) => const GameResultScreen(),
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

  void loseLife()
  {
    // Lose a life.
    livesLeft -= 1;

    // Update the lives indicator. Needs state conversion first.

    print("Lives left: $livesLeft");

    // Check; if we have no lives left, we have lost.
    if (livesLeft == 0)
      {
        loseGame();
      }
  }

  void collideRocket(int obstacleID)
  {
    // If this is called, an obstacle has collided with our rocket.

    // First, grab any important info from the obstacle.
    // int obstacleValue = obstacles[obstacleID].answerValue;

    // Hide the obstacle.
    obstacles[obstacleID].isDropping = false;
    obstacles[obstacleID].isDestroyed = true;
    obstacles[obstacleID].alive = false;
    obstacles[obstacleID].answerValue = filledObstacle;

    // Update lives.
    loseLife();

    // Finally, check. If that obstacle contained the CORRECT answer to the
    // current problem, we need to get rid of the other obstacles and
    // skip the problem; it's a loss.
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
          rocketYPos -= (MediaQuery.of(context).size.height * 0.185);
        }
    });
  }

  // Generate a new problem.
  void nextQuestion(bool newAnsweredQuestion) {
    setState(() {
      problem = widget.shootingProblem.generateProblem();
    });
  }

  // Start the game (turn rocket on and move it up, create first
  // question and answers, drop obstacles and show first problem.
  void startGame()
  {
    // Start the game, move the rocket up, and load questions!
    setState(() {
      gameStarted = true;
    });

    // Move rocket up and turn it on so it's ready.
    moveRocket("up1");
    rocketOn = true;

    for (int i = 0; i < numObstacles; i++)
    {
      obstacles[i].isDropping = true;
    }

    // Load the first problem.
    // nextProblem() here.

    // Temporary; fixing state in SGInfoBar first.
    obstacles[0].answerValue = 1;
    obstacles[1].answerValue = 0;
    obstacles[2].answerValue = 2;

    // Allow solving.
    canSolve = true;
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                // Replace 0 with the int value of the planet attached to this
                // shooting game instance.
                builder: (context) => const PlanetMapScreen(selectedPlanet: 0),
              ),
            )
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

          // Ground (ground_art) for the shooting game.
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

          // Player rocket:
          SGPlayerRocket(
            isOn: rocketOn,
            rocketX: rocketXPos,
            rocketY: rocketYPos,
          ),

          // Game Info bar (displays question, lives, rewards)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SGInfoBar(),
          ),

          for (int i = 0; i < numObstacles; i++)
            obstacles[i],
          // obstacles[0],

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

        ],
      ),
    );
  }
}

// Global reference to this specific game just so we can call collideRocket
// when SGObstacles collide with the rocket. It's not a clean way of doing
// this but there's no other way due to Flutter.
_ShootingGameState? shootingGameStateInstance;