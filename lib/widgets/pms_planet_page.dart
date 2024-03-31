import 'package:explore/utils/problem_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';
import 'package:explore/screens/planet_home_screen.dart';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:explore/widgets/pms_pin.dart';

// This is where the mapping between the problem generator and levels go. These
// are manually written so they can be adjusted as seen fit
final List<List<ProblemGenerator>> problemGeneratorCurriculum = [
  // Earth
  [
    ProblemGenerator(1, true),
    ProblemGenerator(2, true),
    ProblemGenerator(2, false),
    ProblemGenerator(2, false),
    ProblemGenerator(2, false),
  ],
  // Mars
  [
    ProblemGenerator(3, true),
    ProblemGenerator(4, true),
    ProblemGenerator.withRange(3, 4),
    ProblemGenerator(4, false),
    ProblemGenerator(4, false),
  ],
  // Saturn
  [
    ProblemGenerator(5, true),
    ProblemGenerator(6, true),
    ProblemGenerator(7, true),
    ProblemGenerator.withRange(5, 7),
    ProblemGenerator(7, false),
  ],
  // Neptune
  [
    ProblemGenerator(8, true),
    ProblemGenerator(9, true),
    ProblemGenerator(10, true),
    ProblemGenerator.withRange(8, 10),
    ProblemGenerator(10, false),
  ],
];

// Loads a single "page" for the Planet Map Screen.
// This includes the respective planet, its pinned levels, and the
// background art. Pages are repeated as many times as there are
// planets. Planets are currently manually added with 4 added in total,
// but dynamically loaded once added to this file.

// Remember: to add more planets, update numPlanets in
// planet_map_screen.dart and the code from the start of building
// the widget below to before we return a Stack in this file.
// Then, update pms_pin.dart with more paths to pin colors if desired.

/// A single planet with its level pins & background for the map screen.
class PlanetPage extends StatelessWidget {
  // Index of the current planet we're building onto the map screen.
  // Starts at 1 due to level naming scheme (1-1, 1-2, 1-3, 2-1, 2-2...).
  final int index;
  final bool isPlanetLocked;
  final List<CompletionStatus> levelStatuses;

  // Constructor (requires planet index parameter).
  const PlanetPage({
    Key? key,
    required this.index,
    required this.isPlanetLocked,
    required this.levelStatuses,
  }) : super(key: key);

  // Function used to generate a list of games for a planet in a random
  // order, based on the number of game types and levels per planet.
  // All planets receive the same number of levels.
  List<GameType> getRandomGamesList(int gameListSeed) {
    // Determine the number of times each game should appear;
    // using truncated division in case it does not evenly divide.
    int gamesPerType = levelsPerPlanet ~/ numGameTypes;

    // In case it does not divide evenly, calculate the remaining games.
    int remainingGames = levelsPerPlanet % numGameTypes;

    // First, make a list with as even a distribution of games possible.
    List<GameType> allGameTypes = List.generate(
      numGameTypes,
      (index) => GameType.values[index],
    );

    // Shuffle this list of games.
    allGameTypes.shuffle(Random(gameListSeed));

    // Fill any remaining spaces with an uneven amount of remaining
    // game types (this is done so if we have a case like 5 game types
    // and 9 levels, it will generate an even amount and fill the
    // remaining spaces with random extra games differently per planet.
    List<GameType> games = List.generate(
      numGameTypes,
      (index) => List.filled(
        gamesPerType + (index < remainingGames ? 1 : 0),
        allGameTypes[index],
      ),
    ).expand((list) => list).toList();

    // Shuffle this again so that the first and last game change
    // between planets. Not shuffling twice caused this.
    games.shuffle(Random(gameListSeed));

    // To view the games for each level, enable debugView in
    // the planet_map_screen.dart page.

    return games;
  }

  @override
  Widget build(BuildContext context) {
    // Planets can be manually added within this block of code.
    // To add more, add cases and variables where necessary until
    // we return the Stack below.
    // Remember to add new SVGs to pubspec.yaml.

    // FIXME Access paths from DB.
    String planet1 = "assets/images/pms_earth.svg";
    String planet2 = "assets/images/pms_mars.svg";
    String planet3 = "assets/images/pms_saturn.svg";
    String planet4 = "assets/images/pms_neptune.svg";
    // Add more planets here as desired.

    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    // Values for calculating the size at which to display planets.
    // Calculated from the width/height of all planet images, which
    // are the same. If you add a new planet image, ensure it matches
    // the other planet SVGs' sizes & shapes (i.e. pms_earth.svg).
    double planetAspectRatio = 360 / 620;
    double planetHeight = screenWidth / planetAspectRatio;

    // Used for identifying which planet we're displaying on the map
    // screen and its exact image path.
    String planetIndex = index.toString();
    String planetPath;

    // Seed to be used to randomly place the pins on a planet.
    int seed;

    // Levels lock independently from planets. Loaded from DB.
    //bool isPlanetLocked = false;

    // Set the planet image path/seed. Add more planet cases as desired.
    // Update the seed here if you do not like the pin placement.
    switch (planetIndex) {
      // Change to "isPlanetLocked = getPlanetLockedFromDB(planetIndex)
      case "1":
        planetPath = planet1;
        seed = 11;
        break;
      case "2":
        planetPath = planet2;
        seed = 129;
        break;
      case "3":
        planetPath = planet3;
        seed = 298;
        break;
      case "4":
        planetPath = planet4;
        seed = 404;
        break;
      // Add more cases here if adding more planets, with correct path.
      default:
        // Default to the superior planet in case of error (Earth).
        planetPath = planet1;
        seed = 20;
        break;
    }

    // You have reached the point of code that needs to be changed
    // if adding new planets. The below code refers only to the pin
    // generation for the planet.

    // Generate a list of games that will correlate with the pins on
    // this planet. We generate the list and then randomize the order;
    // this currently uses the same seed as above, which is unique per
    // planet. Works with any number of levels/game types.
    List<GameType> planetGames = getRandomGamesList(seed);

    // Generate a list of pins to place on this planet, naming
    // them properly and placing them on the correct locations.
    // Note: No need to update this list gen if adding new planets.
    List<Widget> pinWidgets = List.generate(
      levelsPerPlanet,
      (pinIndex) {
        // Name the pin as "planet-level", i.e. "1-1, 1-2, 2-4", etc.
        String pinName = '$index-${pinIndex + 1}';

        // Define a variable to store the level's theme temporarily.
        GameTheme gameTheme;

        // Identify the theme of the game based on the planet.
        switch (index) {
          case 1:
            gameTheme = GameTheme.earth;
            break;
          case 2:
            gameTheme = GameTheme.mars;
            break;
          case 3:
            gameTheme = GameTheme.saturn;
            break;
          case 4:
            gameTheme = GameTheme.neptune;
            break;
          default:
            // Space levels not yet implemented.
            gameTheme = GameTheme.space;
            break;
        }

        // Use a random variable with a seed (preset above for each planet)
        // to achieve random pin placement that is always the same.
        Random random = Random(pinIndex * seed); // Adjust the seed as needed

        // Prevent the 0th pin (the top one) from staying in the same spot.
        if (pinIndex == 0) {
          random = Random((pinIndex + 5) * seed);
        }

        // Assign a random padding based on the random value and the width
        // of the screen.
        double randomLeftPadding = random.nextDouble() * (screenWidth - 30);

        // Evenly space the pins apart by height based on the number.
        // The randomLeftPadding moves them left and right randomly.
        return Visibility(
          visible: !isPlanetLocked,
          child: Positioned(
            top: ((levelsPerPlanet - 1) - pinIndex) *
                (planetHeight / levelsPerPlanet + 0),
            left: randomLeftPadding,

            // Place a pin. Assign its name, the planet it belongs to,
            // and load whether it's complete, locked, or the current level.
            // Temporarily defaulting to all pins being complete.
            child: PinWidget(
              name: pinName,
              level: pinIndex + 1,
              pinColor: index,
              status: isPlanetLocked
                  ? CompletionStatus.locked
                  : levelStatuses[pinIndex], // Load from DB
              game: planetGames.removeLast(),
              theme: gameTheme,
              problemGenerator: problemGeneratorCurriculum[index - 1][pinIndex],
            ),
          ),
        );
      },
    );

    // Return a stack of this planet page's images and content.
    // Again, no need to update this code if adding new planets.
    return Stack(
      alignment: Alignment.center,
      children: [
        // First, each page always gets the background art.
        Image.asset(
          'assets/images/StarsBackground.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: planetHeight + (MediaQuery.of(context).size.height * 0.15),
        ),

        // Next, we should load the planet this page refers to.

        // Pad the planet so it's directly in the middle of the screen.
        Padding(
          padding: EdgeInsets.only(top: 100),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Size a box to store the correctly-sized planet
              // based on the screen size; calculated above.
              SizedBox(
                width: screenWidth,
                height: planetHeight,

                // Create a Stack to display the planet & its pins.
                child: Stack(
                  children: [
                    // Show the planet image.
                    Visibility(
                      // This shows a normal, unlocked planet.
                      visible: !isPlanetLocked,
                      child: Positioned.fill(
                        // Load this planet's SVG image.
                        child: SvgPicture.asset(
                          planetPath,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),

                    // Alternatively show this instead if locked.
                    Visibility(
                      visible: isPlanetLocked,
                      child: Positioned.fill(
                        // Load this planet's SVG image in grayscale.
                        child: SvgPicture.asset(
                          planetPath,
                          fit: BoxFit.fill,
                          // Grayscale color filter. Used on pins, too.
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
                    ),

                    // Display the level pins on this planet; iterate
                    // 1 at a time. This list is calculated at the
                    // top of this file.
                    ...pinWidgets,
                  ],
                ),
              ),

              // Display a locked icon on the planet itself if necessary.
              Visibility(
                visible: isPlanetLocked,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: planetHeight / 4),
                    child: SvgPicture.asset(
                      "assets/images/locked.svg",
                      height: planetHeight / 2,
                      width: planetHeight / 2,
                    ),
                  ),
                ),
              ),

              // Add the number below the planet. Use padding to
              // place it slightly below and to the left of the planet.
              Positioned(
                left: (MediaQuery.of(context).size.width * 0.075),
                bottom: 0,
                child: Text(
                  planetIndex, // Starting at 1
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Fredoka",
                    fontSize: 70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
