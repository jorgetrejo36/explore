import 'package:explore/widgets/racing_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:explore/screens/game_screen.dart';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:explore/widgets/geyser_game.dart';
import 'package:explore/widgets/shooting_game.dart';
import '../utils/problem_generator.dart';
import 'mining_game.dart';
import '../screens/planet_home_screen.dart';
import 'pms_rocket.dart';

// Used to display a clickable pin on a planet which has 3 states:
// Complete (checkmark icon), Locked (lock icon and grayed out), and
// Current (displaying the PMSRocketWidget beside it).

// Here to add more planets? Update the color paths & switch below.
// Here to add more game types? Update the loadGame() function below.

/// A single pin (level) on a planet, associated with a specific game.
class PinWidget extends StatelessWidget {
  // The level's (pin's) name (1-1, 1-2, 1-3, 2-1, etc.).
  final String name;
  // The level, respective to the planet, for this pin
  final int level;
  // Determines the color pin to use based on the planet.
  final int pinColor;
  // Is this level pin complete (checked), current (rocket), or locked?
  final CompletionStatus status;
  // What is the game attached to this pin?
  final GameType game;
  // What is the theme of this pin? Assigned based on levelName
  // currently, so there are no space themes yet.
  final GameTheme theme;
  // problem generator object
  final ProblemGenerator problemGenerator;

  // Constructor.
  // Refer to "name" (i.e. "1-4") to determine the theme type.
  const PinWidget({
    Key? key,
    required this.pinColor,
    required this.name,
    required this.level,
    required this.status,
    required this.game,
    required this.theme,
    required this.problemGenerator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Stores the path of the correct pin color based on the planet.
    String pinPath;

    // Manually assign pic color paths. Update me and the switch
    // below to add colors for new planets.
    String planet1 = "assets/images/pms_pin_earth.svg";
    String planet2 = "assets/images/pms_pin_mars.svg";
    String planet3 = "assets/images/pms_pin_saturn.svg";
    String planet4 = "assets/images/pms_pin_neptune.svg";
    // Add new planets here as necessary.

    // Loads a game based on its type and sends theme information.
    void loadGame(String name, GameType game, CompletionStatus status) {
      // Notify which level is selected. Can remove when no longer nec.
      print("Loading level $name. Game: $game. Status: $status.");

      // If the level is locked, do not load a game.
      if (status == CompletionStatus.locked) {
        print("Status is locked. Load cancelled.");
        return;
      }

      // Identify which game to load and apply theme information.
      Widget gameToLoad;

      // FIXME Update planet for your game to be GameTheme enum.
      // Identify which game to load based on the GameType.
      // To add more game types, add to this switch statement.
      switch (game) {
        case GameType.geyser:
          gameToLoad = GeyserGameStateful(
            level: level,
            planet: theme,
            geyserProblem: problemGenerator,
          );

        case GameType.shooting:
          gameToLoad = ShootingGameStateful(
            level: level,
            planet: theme,
            shootingProblem: problemGenerator,
          );

        case GameType.mining:
          // Add mining game with theme
          gameToLoad = MiningGame(
            level: level,
            planet: theme,
            miningProblem: problemGenerator,
          );

        case GameType.racing:
          // Add racing game w/ theme. Temp GameScreen until it's made.
          gameToLoad = RacingGame(
            level: level,
            planet: theme,
            racingProblem: problemGenerator,
          );

        // Add GameType.scrolling if we make a fifth game.

        // Add more GameTypes here, as desired.
        default:
          // default should never occur, always set a valid game type.
          gameToLoad = const GameScreen();
      }

      // Load the game.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => gameToLoad,
        ),
      );
    }

    // Assign the path based on what planet we're pasting pins on
    // so we know what colors to set the pins.
    switch (pinColor) {
      case 1:
        pinPath = planet1;
        break;
      case 2:
        pinPath = planet2;
        break;
      case 3:
        pinPath = planet3;
        break;
      case 4:
        pinPath = planet4;
        break;
      // If adding more planets, add more cases here for pin colors.
      default:
        pinPath = planet1;
        break;
    }

    // Build the pin widget. It should entirely be clickable.
    return GestureDetector(
      onTap: () {
        // Load the game associated with this pin when clicked.
        loadGame(name, game, status);
      },

      // Use a Stack to display the correct pin and icon beside it.
      child: Stack(
        children: [
          // Display a locked pin level if the status is locked.
          Visibility(
            visible: status == CompletionStatus.locked,
            child: Stack(
              children: [
                // Display the pin icon, but grayed-out.
                // Use planet4 as it looks best grayed-out.
                SizedBox(
                  width: 34,
                  height: 34,
                  child: SvgPicture.asset(
                    planet4,
                    fit: BoxFit.fill,
                    // Applies a grayscale color filter. Sourced
                    // from online to skip entire library import.
                    colorFilter: const ColorFilter.matrix(<double>[
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ]),
                  ),
                ),

                // Display the lock icon over the pin icon.
                // Add padding so the 28x28 is centered in the 34x34.
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: SizedBox(
                    child: SvgPicture.asset(
                      "assets/images/locked.svg",
                      height: 28,
                      width: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Otherwise, display a completed pin level if it is completed.
          Visibility(
            visible: status == CompletionStatus.complete,
            child: Stack(
              children: [
                // Display the pin icon in its normal color.
                SizedBox(
                  width: 34,
                  height: 34,
                  child: SvgPicture.asset(
                    pinPath,
                    fit: BoxFit.fill,
                  ),
                ),

                // Display a checkmark close to the pin with padding.
                Padding(
                  padding: const EdgeInsets.only(top: 28.0, left: 22),
                  child: SizedBox(
                    child: SvgPicture.asset(
                      "assets/images/right.svg",
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // The only remaining option is if the level is unlocked
          // but has not been completed yet, in which case we show
          // just the pin and the player's rocket instead.
          Visibility(
            visible: status == CompletionStatus.current,
            child: Stack(
              // Set clipBehavior so the rocket/avatar shows properly.
              clipBehavior: Clip.none,
              children: [
                // Display the pin icon in its normal color.
                SizedBox(
                  width: 34,
                  height: 34,
                  child: SvgPicture.asset(
                    pinPath,
                    fit: BoxFit.fill,
                  ),
                ),

                // Display the rocket close to the pin (its own widget).
                const Positioned(
                  left: 20,
                  bottom: -12,
                  child: PMSRocketWidget(),
                ),
              ],
            ),
          ),

          // Helpful debug text that displays the level's name and
          // game with each pin (i.e. 1-1 mining).
          Visibility(
            visible: debugView,
            child: Text(
              "       $name ${game.toString().split('.').last}",
              style: const TextStyle(
                fontSize: 22,
                fontFamily: "Fredoka",
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
