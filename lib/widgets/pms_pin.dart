import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:explore/screens/game_screen.dart';
import 'package:explore/widgets/geyser_game.dart';
import 'package:explore/widgets/shooting_game.dart';
import '../screens/planet_home_screen.dart';
import 'pms_rocket.dart';

// Used to display a clickable pin on a planet which has 3 states:
// Complete (checkmark icon), Locked (lock icon and grayed out), and
// Current (displaying the PMSRocketWidget beside it).

// FIXME Methods to loadGame() and getGame() are temp. in pms_pin.dart.

class PinWidget extends StatelessWidget {
  // The level's (pin's) name (1-1, 1-2, 1-3, etc.).
  final String name;
  // Determines the color pin to use based on the planet.
  final int planet;
  // Is this level pin complete (checked), current (rocket), or locked?
  final CompletionStatus status;

  // Constructor. All pins must have an accompanying planet.
  const PinWidget(
      {Key? key,
        required this.planet,
        required this.name,
        required this.status,
        // Potentially add this.game to attach games to levels?
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Stores the path of the correct pin color based on the planet.
    String pinPath;

    // FIXME Access paths from DB.
    String planet1 = "assets/images/pms_pin_earth.svg";
    String planet2 = "assets/images/pms_pin_mars.svg";
    String planet3 = "assets/images/pms_pin_saturn.svg";
    String planet4 = "assets/images/pms_pin_neptune.svg";

    // Temporarily being used to map a level to a specific game.
    // We will want to obviously do something different for release.
    // An enum GameType.(shooting, mining, etc.) would be helpful.
    // Note: This function is called from loadGame() below.
    Widget getGame(String levelName)
    {
      switch (levelName) {
        case "1-1":
          // First pin will temp. be the Geyser game. Skeleton added.
          return const GeyserGameStateful();
        case "1-2":
          // Second pin will temp. be the Shooting game. Skeleton added.
          return const ShootingGameStateful();
        case "1-3":
          // Third pin will temp. be the Mining game.
          // Not added! Defaulting to Geyser.
          return const GeyserGameStateful();
        case "1-4":
          // Fourth pin will temp. be the Racing game.
          // Not added! Defaulting to Geyser.
          return const GeyserGameStateful();
        default:
          // Remaining pins will temp. take you to the main game screen.
          return const GameScreen(); // Default case
      }
    }

    // Called to load a game from a level. Import the pin to load this
    // function OR move this to a better file?
    // This does not determine the game currently; getGame() does this.
    void loadGame(String levelName, CompletionStatus levelStatus,
        /*GameType gameType? not nec. if we choose to attach to pins */)
    {

      // Notify which level is selected. Can remove when no longer nec.
      print("Loading level $name. Status: $status.");

      // If the level is locked, do not load a game.
      if (status == CompletionStatus.locked)
      {
        print("Status is locked. Load cancelled.");
        return;
      }

      // TODO Dynamic load game instead of setting manually in getGame().
      // Currently, the first four will manually direct to one of each
      // game as an example, & the rest will default to the game screen.
      // To see where each game is defined, see getGame() above.
      Navigator.push(
        context,
        MaterialPageRoute(
          // Load the game gotten from getGame(), passing in "#-#".
          builder: (context) => getGame(levelName),
        ),
      );
    }

    // Assign the path based on what planet we're pasting pins on
    // so we know what colors to set the pins.
    switch (planet)
    {
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
      default:
        pinPath = planet1;
        break;
    }

    // On clicking anywhere around a pin, load the game.
    return GestureDetector(
      onTap: () {
        loadGame(name, status); // Add , game? Or add games to pins.
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
                      0.2126,0.7152,0.0722,0,0,
                      0.2126,0.7152,0.0722,0,0,
                      0.2126,0.7152,0.0722,0,0,
                      0,0,0,1,0,
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
                  child: SvgPicture.asset(pinPath, fit: BoxFit.fill,),
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
                  child: SvgPicture.asset(pinPath, fit: BoxFit.fill,),
                ),

                // Display the rocket close to the pin (its own widget).
                const Positioned(
                  left: 6,
                  bottom: -22,
                  child: PMSRocketWidget(),
                ),
              ],

            ),
          ),

          // Helpful debug text that displays the level name beside
          // the pin (i.e. 1-1). Uncomment the below 7 lines to display.
          // Text("       $name",
          //   style: const TextStyle(
          //     fontSize: 22,
          //     fontFamily: "Fredoka",
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }
}