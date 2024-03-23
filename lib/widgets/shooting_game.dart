import 'dart:async';
import 'dart:math';
import 'package:explore/widgets/score_calculator.dart';
import 'package:explore/widgets/sg_obstacle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../screens/game_result_screen.dart';
import '../screens/planet_map_screen.dart';
// ignore: unused_import
import 'shooting_themes.dart';
import 'package:explore/utils/problem_generator.dart';
import 'package:explore/widgets/sg_info_bar.dart';
import 'package:explore/widgets/sg_player_rocket.dart';

class ShootingGameStateful extends StatefulWidget {
  const ShootingGameStateful({
    super.key,
    required this.planet,
    required this.level,
    required this.shootingProblem,
  });

  // Stores the planet this game is themed to (coming soon) and
  // its associated problem set.
  final GameTheme planet;
  final ProblemGenerator shootingProblem;
  final int level;

  @override
  State<ShootingGameStateful> createState() => _ShootingGameState();
}

class _ShootingGameState extends State<ShootingGameStateful> {
  // VARIABLES - Customizable Settings

  // How many problems does the player have to answer for this game?
  int numProblems = 5;
  // How many obstacles (i.e. asteroids) should spawn per problem?
  int numObstaclesPerProblem = 3;
  // How many lives does the player have left? Starts with 3.
  // Note: If you offer more than 3, only a maximum of 3 hearts will be
  // displayed. When the user gets to less than 3, they will update.
  int livesLeft = 3;
  // What should the range in pixels be that obstacles can randomly spawn in?
  double obstacleRangeY = 150;
  // How high should the obstacles begin to be generated?
  // Currently, they begin off-screen. Leave as such.
  double initialHeight = 90;
  // How much space should there be between
  // every set of numObstaclesPerProblem?
  double obstaclePadding = 115;
  // How long should the correct/incorrect icon display for, in seconds?
  int resultIconDelay = 3;

  // VARIABLES - Game Statistics

  // How many problems in total has the player answered (right or wrong)?
  int problemsAnswered = 0;
  // How many problems has the player gotten correct or incorrect, individually?
  int problemsCorrect = 0;
  int problemsWrong = 0;
  // Stores the answer choice the player selects.
  late int answerChoice;
  // Is the player allowed to click an answer?
  bool canSolve = false;
  // Has the game started?
  bool gameStarted = false;
  // Is the rocket on?
  bool rocketOn = false;
  // What column is the player in?
  late String rocketColumn = "center";
  // What are the BOTTOM 3 obstacle indices we can fill in next with answers?
  late List<int> bottomThree;
  // Index of the last obstacle we started checking from the bottom up?
  int lastBottomObs = 0;
  // How many obstacles currently have an answer value filled in for the
  // current problem?
  int activeObstacles = 0;
  // Should the correct or incorrect indicator display? Updates at runtime.
  late bool showCorrectResult = false;
  late bool showIncorrectResult = false;

  // VARIABLES - Game Elements

  // Stores how many obstacles will be generated in total.
  late int numObstacles;
  // Define a list to store generated obstacles.
  late List<SGObstacle> obstacles;
  // What's the player rocket's X and Y positions at initialization?
  late double rocketXPos;
  late double rocketYPos;
  // What are the X positions of the columns?
  late double leftX;
  late double centerX;
  late double rightX;
  // Timer used to show/hide icons with a delay. Initialize to 0 for now.
  late Timer iconTimer = Timer(Duration.zero, () {});
  // Timer and counter used to track how long a user spends in-game.
  // Started in startGame(), stopped in winGame() and loseGame().
  final gameTimer = Stopwatch();
  late int finalTime = (gameTimer.elapsedMilliseconds / 1000).round();

  // VARIABLES - Problem Generator Elements

  // Stores the current problem the player has to answer.
  late GeneratedProblem currentProblem;
  // Holds the toString version of the currentProblem (i.e. "2+2").
  String currentProblemText = "";
  // Stores the correct answer and list of answer choices to the current problem.
  late int correctAnswer;
  late List<dynamic> possibleAnswers;
  // Stores the indices of the active obstacles.
  late List<int> activeObstacleIndices = [];

  // VARIABLES - Theming (temporary until switching to shooting_themes.dart).
  late String skyImage;
  late String groundImage;
  late String obstacleImage;
  late String rewardImage;
  late String destroyedImage;
  late BoxDecoration gameBackgroundColor;

  // METHODS - Setup

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

  // Applies the themed image paths based on the planet.
  void applyTheme() {
    // Switch planet, use based on shooting_themes.dart. Remove unused import;
    // In progress, will be finished early this week and use the other file.

    switch (widget.planet) {
      case GameTheme.earth:
        skyImage = "assets/images/shooting_earth_sky_art.png";
        groundImage = "assets/images/shooting_earth_ground_art.png";
        obstacleImage = "assets/images/sg_asteroid_earth.svg";
        rewardImage = "assets/images/diamond.svg";
        destroyedImage = "assets/images/sg_asteroid_destroyed_earth.svg";
        gameBackgroundColor = const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 144, 195, 243),
              Color.fromARGB(255, 218, 231, 247),
            ],
          ),
        );
        break;

      case GameTheme.mars:
        skyImage = "assets/images/shooting_mars_sky_art.png";
        groundImage = "assets/images/shooting_mars_ground_art.png";
        obstacleImage = "assets/images/one-asteroid.svg";
        rewardImage = "assets/images/ruby.svg";
        destroyedImage = "assets/images/asteroids.svg";
        gameBackgroundColor = const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 252, 153, 98),
              Color.fromARGB(255, 252, 153, 98),
            ],
          ),
        );
        break;

      case GameTheme.saturn:
        skyImage = "assets/images/transparency.png";
        groundImage = "assets/images/shooting_saturn_ground_art.png";
        obstacleImage = "assets/images/ring.svg";
        rewardImage = "assets/images/gem.svg";
        destroyedImage = "assets/images/ring-faded.svg";
        gameBackgroundColor = const BoxDecoration(
          color: Color.fromARGB(255, 0, 9, 59),
          image: DecorationImage(
            image: AssetImage("assets/images/shooting_saturn_sky_art.png"),
            fit: BoxFit.cover,
          ),
        );
        break;

      case GameTheme.neptune:
        skyImage = "assets/images/shooting_neptune_sky_art.png";
        groundImage = "assets/images/shooting_neptune_ground_art.png";
        obstacleImage = "assets/images/blue-fish.svg";
        rewardImage = "assets/images/pearl.svg";
        destroyedImage = "assets/images/blue-fish.svg";
        gameBackgroundColor = const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/shooting_neptune_sky_art.png"),
            fit: BoxFit.cover,
          ),
        );
        break;

      default:
        skyImage = "";
        groundImage = "";
        obstacleImage = "";
        rewardImage = "";
        destroyedImage = "";
        gameBackgroundColor = const BoxDecoration();
        break;
    }
  }

  // Function to generate random heights within a range
  double getRandomHeight(double minHeight, double maxHeight) {
    final random = Random();
    return minHeight + random.nextDouble() * (maxHeight - minHeight);
  }

  void setUpGame() {
    // Assign the instance.
    shootingGameStateInstance = this;

    // Rocket position setup (center on ground, turned off).
    rocketXPos = MediaQuery.of(context).size.width * 0.42;
    rocketYPos = MediaQuery.of(context).size.height * 0.75;
    rocketColumn = "center";

    // Set column positions.
    leftX = rocketXPos - (MediaQuery.of(context).size.width * 0.3);
    centerX = rocketXPos;
    rightX = rocketXPos + (MediaQuery.of(context).size.width * 0.3);

    // Identify the number of obstacles to create.
    numObstacles = numProblems * numObstaclesPerProblem;

    // Initialize the current height range
    double currentMinHeight = initialHeight;
    double currentMaxHeight = initialHeight + obstacleRangeY;

    // Generate a list of obstacles which will be placed on the screen in build.
    obstacles = List.generate(numObstacles, (index) {
      String col;
      double xPos;

      // Every set of 3 gets one left, one middle, and one right obstacle.
      switch (index % 3) {
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
        obstacleImg: obstacleImage,
        obstacleRewardImg: rewardImage,
        obstacleDestroyedImg: destroyedImage,
        obstacleIndex: index,
        obstacleX: xPos,
        obstacleY: -1 * obstacleYVal,
        obstacleCol: col,
        isDestroyed: false,
      );
    });
  }

  // METHODS - Interaction

  // Assign any passed-in parameters to the correct fields associated with the
  // obstacle we choose to update. All parameters are optional.
  void updateObstacle(
    int index, {
    bool? isDestroyed,
    bool? isDropping,
    bool? alive,
    int? answerValue,
    bool? markForDeletion,
  }) {
    setState(() {
      final obstacle = obstacles[index];
      if (isDestroyed != null) obstacle.isDestroyed = isDestroyed;
      if (isDropping != null) obstacle.isDropping = isDropping;
      if (alive != null) obstacle.alive = alive;
      if (answerValue != null) obstacle.answerValue = answerValue;
      if (markForDeletion != null) obstacle.markForDeletion = markForDeletion;
      // If we called updateObstacle, we must have changed at least one thing.
      // So, the obstacle needs to be visually re-built.
      obstacle.markForUpdate = true;
    });
  }

  // Called whenever we tap on a falling obstacle.
  // Moves the rocket to it and fires; calls the function to check the answer.
  void shootObstacle(int obstacleID) {
    // Get a reference to this obstacle we tapped.
    SGObstacle thisObs = obstacles[obstacleID];

    // Don't shoot an asteroid that has already stopped moving or
    // if we aren't allowed to solve things yet.
    if (!canSolve || !thisObs.isDropping) {
      return;
    }

    // If this obstacle is empty (has no answer), is filled (has been used
    // already), or has the correct answer (has been used to solve a problem),
    // do NOT shoot it.
    if (thisObs.answerValue == emptyObstacle ||
        thisObs.answerValue == filledObstacle ||
        thisObs.answerValue == correctObstacle) {
      return;
    }

    // We are able to shoot this obstacle. Prevent clicking on any others until
    // we complete this operation (and animation).
    canSolve = false;

    // Identify the obstacle we clicked on, move the rocket to it, and shoot.
    if (thisObs.obstacleCol == "left") {
      // Move the rocket left.
      moveRocket("left");
    } else if (thisObs.obstacleCol == "center") {
      // Move the rocket center.
      moveRocket("center");
    } else {
      // Move the rocket right.
      moveRocket("right");
    }

    // Check if we got the problem right or wrong.
    // Each function appropriately shows the icon and breaks any remaining
    // asteroids, updating associated variables and also checking if we lost.
    if (thisObs.answerValue == correctAnswer) {
      answerCorrect(obstacleID);
    } else {
      answerWrong(obstacleID);
    }

    // If we made it this far, the game isn't over yet (or we just made it past
    // the last problem but have not run out of lives). Generate the next
    // problem.
    nextProblem();
  }

  void answerCorrect(int obstacleID) {
    // We answered a problem correctly.

    // Break the obstacle upon shooting it and show the reward.
    updateObstacle(
      obstacleID,
      answerValue: correctObstacle,
      isDestroyed: true,
      isDropping: false,
      markForDeletion: true,
    );

    problemsCorrect++;

    // Prevent a previous timer from affecting showing our icon, if it exists.
    iconTimer.cancel();

    // Display the correct icon and set a timer so it hides itself.
    showCorrectResult = true;
    showIncorrectResult = false;
    iconTimer = Timer(Duration(seconds: resultIconDelay), () {
      setState(() {
        showCorrectResult = false;
        showIncorrectResult = false;
      });
    });

    // Break any remaining obstacles so the player doesn't have to worry.
    breakRemaining();

    // No need to check if we won; that's done every time nextProblem is called.
  }

  void answerWrong(int obstacleID) {
    // We answered a problem wrong.

    // Break the obstacle upon shooting it. Fill it so we can't use it again.
    updateObstacle(
      obstacleID,
      answerValue: filledObstacle,
      isDestroyed: true,
      isDropping: false,
      markForDeletion: true,
    );

    problemsWrong++;

    // Prevent a previous timer from affecting showing our icon, if it exists.
    iconTimer.cancel();

    // Display the incorrect icon and set a timer so it hides itself.
    showIncorrectResult = true;
    showCorrectResult = false;
    iconTimer = Timer(Duration(seconds: resultIconDelay), () {
      setState(() {
        showIncorrectResult = false;
        showCorrectResult = false;
      });
    });

    // Break any remaining obstacles so the player doesn't have to worry.
    breakRemaining();

    // Lose a life; note that this also will check if the game needs to end
    // due to being out of lives.
    loseLife();
  }

  // Break all active obstacles other than the one we already destroyed, with no
  // penalty to the user.
  void breakRemaining() {
    for (int i = 0; i < activeObstacles; i++) {
      if (!obstacles[activeObstacleIndices[i]].isDestroyed) {
        // We found an obstacle that has not been destroyed!
        updateObstacle(
          activeObstacleIndices[i],
          answerValue: filledObstacle,
          isDestroyed: true,
          isDropping: false,
          markForDeletion: true,
        );
      }
    }

    // We have broken all remaining active obstacles, so now we can clear it.
    activeObstacles = 0;
    activeObstacleIndices.clear();
  }

  // Function to move the rocket (does not animate yet)
  void moveRocket(String column) {
    setState(() {
      if (column == "left") {
        // Move left.
        rocketXPos = leftX;
        rocketColumn = "left";
      }
      if (column == "center") {
        // Move center.
        rocketXPos = centerX;
        rocketColumn = "center";
      } else if (column == "right") {
        // Move right.
        rocketXPos = rightX;
        rocketColumn = "right";
      } else if (column == "up1") {
        // Game starting, move rocket UP.
        rocketYPos -= (MediaQuery.of(context).size.height * 0.185);
      }
    });
  }

  // If this is called, an obstacle has collided with our rocket.
  void collideRocket(int obstacleID) {
    // Because an obstacle has collided, we will break all obstacles associated
    // with the current problem and generate a new one if possible.
    // This is almost the same as answeredWrong.

    // Prevent clicking on anything until we're done.
    canSolve = false;

    // Hide the obstacle.
    updateObstacle(
      obstacleID,
      isDestroyed: true,
      isDropping: false,
      alive: false,
      answerValue: filledObstacle,
      markForDeletion: true,
    );

    problemsWrong++;

    // Prevent a previous timer from affecting showing our icon, if it exists.
    iconTimer.cancel();

    // Display the incorrect icon and set a timer so it hides itself.
    showIncorrectResult = true;
    showCorrectResult = false;
    iconTimer = Timer(Duration(seconds: resultIconDelay), () {
      setState(() {
        showIncorrectResult = false;
        showCorrectResult = false;
      });
    });

    // Update lives. Note: The game may end early here if we are out of lives.
    loseLife();

    // Break the remaining obstacles.
    breakRemaining();

    // Generate a new problem (the game may end early here if we have finished
    // all problems. The player is allowed to canSolve in this function).
    nextProblem();
  }

  // METHODS - Game Loop

  // Start the game (turn rocket on and move it up, create first
  // question and answers, drop obstacles and show first problem.
  void startGame() {
    // Start the game, move the rocket up, and load questions!
    setState(() {
      gameStarted = true;
    });

    // Move rocket up and turn it on so it's ready.
    moveRocket("up1");
    rocketOn = true;

    for (int i = 0; i < numObstacles; i++) {
      updateObstacle(i, isDropping: true);
    }

    // Load the first problem (assign problem text and 3 answers to 3 obstacles).
    // Note: This turns canSolve on and officially allows the game to begin.
    nextProblem();

    // Now that the game has started and the first problem is showing, start
    // tracking how long a user spends in-game.
    gameTimer.start();
  }

  void loseLife() {
    // Update both the lives left and the lives indicator in the SGInfoBar.
    setState(() {
      livesLeft--;
    });

    // Check; if we have no lives left, we have lost.
    if (livesLeft == 0) {
      loseGame();
      return;
    }
  }

  void loseGame() {
    // Stop the game and obstacles from continuing.
    canSolve = false;
    for (int i = 0; i < numObstacles; i++) {
      updateObstacle(i, isDropping: false);
    }

    // Stop tracking player time.
    gameTimer.stop();

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
            child: IconButton(
                icon: SvgPicture.asset(
                  'assets/images/reload.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  semanticsLabel: "arrow pointing in circle",
                  height: 50,
                  width: 50,
                ),
                onPressed: () => {
                      // pop the dialog window
                      Navigator.pop(context),
                      // replace the game page with another game page to reset it for
                      // the user
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShootingGameStateful(
                            level: widget.level,
                            planet: widget.planet,
                            shootingProblem: widget.shootingProblem,
                          ),
                        ),
                      ),
                    }),
          ),
        ],
      ),
    );
  }

  // Called if the user has solved all problems with at least 70% being correct.
  // When called, all obstacles will already be destroyed.
  void winGame() {
    // Prevent clicking on anything. Note, all obstacles are destroyed, anyway.
    canSolve = false;

    // Stop the timers.
    iconTimer.cancel();
    gameTimer.stop();

    // Wait for at least the icon to fully finish its timer (prevents memory
    // leak; even though we end the timer, we have to wait for the setState
    // to update before transitioning). This may be replaced with a little
    // rocket flying-up animation in the near future.
    Timer(Duration(seconds: resultIconDelay), () {
      // Navigate the user to the game results screen.
      // To do: Send amount of correct problems and timer to game result screen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameResultScreen(
            game: Game.shooting,
            level: widget.level,
            planet: widget.planet,
            currency: problemsCorrect,
            time: finalTime,
          ),
        ),
      );
    });
  }

  // Generate a new problem.
  void nextProblem() {
    // First, check. If the last problem we answered made us hit our limit,
    // we have reached the end of the game.
    if (problemsAnswered == numProblems) {
      // The game is over. Win the game ONLY if we scored at least a 70%.
      if (problemsCorrect / numProblems > 0.7) {
        winGame();
        return;
      } else {
        loseGame();
        return;
      }
    }

    // Otherwise, we are now about to answer a new problem. We can increment
    // this now as we only do so once anyway, and the next time we check is
    // when we've completed it and try to generate a new one.
    problemsAnswered++;

    // Generate a new problem; save the correct answer and its shuffled answers.
    currentProblem = widget.shootingProblem.generateProblem();
    correctAnswer = currentProblem.answerChoices.getAnswers()[0];
    possibleAnswers = currentProblem.answerChoices.getAnswers();
    possibleAnswers.shuffle();

    // Fill up the 3 lowest obstacles with 3 answers, respectively.
    // Note: activeObstacles always starts at 0. We fill in for 0, 1, and 2.
    // Note 2: While this is O(3*numObstacles), it's really NOT because the loop
    // will only ever check a maximum of 5 obstacles per cycle (assuming a
    // worst-case scenario where the user gets 2 obstacles wrong). It won't
    // check all 15 every time due to starting at lastBottomObs.
    while (activeObstacles != 3) {
      //print("activeObstacles: " + activeObstacles.toString() + ", ");
      // Always start at the last lowest index we left off and check for
      // open spaces.
      for (int i = lastBottomObs; i < numObstacles; i++) {
        if (obstacles[i].answerValue == emptyObstacle) {
          // Found an empty obstacle. Fill it in and update its state.
          updateObstacle(i, answerValue: possibleAnswers[activeObstacles]);

          // Keep track of the obstacles we've added.
          activeObstacles++;
          activeObstacleIndices.add(i);

          // Because we managed to fill in an obstacle, increment the index
          // and also break out of the for loop to move onto the next.
          lastBottomObs++;
          break;
        } else {
          // If we didn't encounter an empty obstacle and still need more, just
          // increment the lowest index so the next loop always starts one higher.
          lastBottomObs++;
        }
      }
    }

    // Update the SGInfoBar to display the current problem.
    currentProblemText = currentProblem.problem.getProblemString();

    // Once the problem is generated, allow the player to solve it.
    canSolve = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // No back buttons in games, so no app bar.
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background sky gradient for the game (all art will
          // change soon to use shooting_themes.dart).
          Container(
            decoration: gameBackgroundColor,
          ),

          // Clouds (sky_art) for the Earth shooting game.
          Visibility(
            visible: !gameStarted,
            child: Positioned(
              top: 0,
              child: Image.asset(
                skyImage,
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
                groundImage,
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SGInfoBar(
              gameStarted: gameStarted,
              livesLeft: livesLeft,
              problemText: currentProblemText,
            ),
          ),

          for (int i = 0; i < numObstacles; i++) obstacles[i],

          Center(
            child: Visibility(
              visible: !gameStarted,
              child: ElevatedButton(
                onPressed: startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Set button color to white
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                  size: 64,
                ),
              ),
            ),
          ),

          // Indicator for getting the problem correct.
          Visibility(
            visible: showCorrectResult,
            child: Positioned(
              bottom: MediaQuery.of(context).size.height * 0.825,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                "assets/images/right.svg",
                width: 96,
                height: 96,
              ),
            ),
          ),

          // Indicator for getting the problem correct.
          Visibility(
            visible: showIncorrectResult,
            child: Positioned(
              bottom: MediaQuery.of(context).size.height * 0.825,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                "assets/images/wrong.svg",
                width: 96,
                height: 96,
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
// this, but there's no other way due to Flutter.
_ShootingGameState? shootingGameStateInstance;
