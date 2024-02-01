import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';
import 'package:explore/screens/planet_home_screen.dart';
import 'package:explore/widgets/pms_pin.dart';

// Loads a single "page" for the Planet Map Screen.
// This includes the respective planet, its pinned levels, and the
// background art. Pages are repeated as many times as there are
// planets. Planets are currently manually added with 4 added in total,
// but dynamically loaded once added to this file.

class PlanetPage extends StatelessWidget {
  // Index of the current planet we're building onto the map screen.
  // Starts at 1 due to level naming scheme (1-1, 1-2, 1-3, 2-1, 2-2...).
  final int index;

  // Constructor (requires planet index parameter).
  const PlanetPage({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Manually add planets and change the number of levels
    // per planet here. When adding a new SVG, update pubspec.yaml.

    // I recommended cycling the seed per each planet below after
    // updating levels, so the pins always look nicely placed.
    int levelsPerPlanet = 8;

    // FIXME Access paths from DB.
    String planet1 = "assets/images/pms_earth.svg";
    String planet2 = "assets/images/pms_mars.svg";
    String planet3 = "assets/images/pms_saturn.svg";
    String planet4 = "assets/images/pms_neptune.svg";

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Values for calculating the size at which to display planets.
    // Calculated from the width/height of all planet images, which
    // are the same. If you add a new planet image, ensure it matches
    // the other planet SVGs' sizes & shapes (i.e. pms_earth.svg).
    double planetAspectRatio = 360/620;
    double planetHeight = screenWidth / planetAspectRatio;

    // Used for identifying which planet we're displaying on the map
    // screen and its exact image path.
    String planetIndex = index.toString();
    String planetPath;

    // TODO Load from DB if planet is locked or not.
    // Currently, this is temporarily set only on planet 4 below
    // in the switch statement to demo the locking ability.
    // Levels lock independently from planets.
    bool isPlanetLocked = false;

    // Seed to be used to randomly place the pins on a planet.
    int seed;

    // Set the planet image path. Currently, this needs to be updated
    // manually if adding more planets.
    // !!! Note: We also set the seed for pin placements here.
    // Don't like how the pins are for a specific planet? Keep
    // re-rolling the seed.
    // !!! Note: Also temporarily setting the planet locked state here
    // to check if it works. This needs to be loaded from the DB.
    switch (planetIndex)
    {
      case "1":
        planetPath = planet1;
        seed = 11;
        isPlanetLocked = false;
        break;
      case "2":
        planetPath = planet2;
        seed = 129;
        isPlanetLocked = false;
        break;
      case "3":
        planetPath = planet3;
        seed = 298;
        isPlanetLocked = false;
        break;
      case "4":
        planetPath = planet4;
        seed = 404;
        isPlanetLocked = true;
        break;
      default:
        // Default to the superior planet in case of error (Earth).
        planetPath = planet1;
        seed = 20;
        isPlanetLocked = false;
        break;
    }

    // Generate a list of pins to place on this planet, naming
    // them properly and placing them on the correct locations.
    List<Widget> pinWidgets = List.generate(levelsPerPlanet, (pinIndex) {

      // Name the pin as "planet-level", i.e. "1-1, 1-2, 2-4", etc.
      String pinName = '$index-${pinIndex + 1}';

      // Use a random variable with a seed (preset above for each planet)
      // to achieve random pin placement that is always the same.
      Random random = Random(pinIndex * seed); // Adjust the seed as needed

      // Prevent the 0th pin (the top one) from staying in the same spot.
      if (pinIndex == 0)
      {
        random = Random((pinIndex+5) * seed);
      }

      // Assign a random padding based on the random value and the width
      // of the screen.
      double randomLeftPadding = random.nextDouble() * (screenWidth - 30);

      // Evenly space the pins apart by height based on the number.
      // The randomLeftPadding moves them left and right randomly.
      return Positioned(
        top: ((levelsPerPlanet - 1) - pinIndex) *
            (planetHeight / levelsPerPlanet + 0),
        left: randomLeftPadding,

        // Place a pin. Assign its name, the planet it belongs to,
        // and load whether it's complete, locked, or the current level.
        // TODO Load pin completion status/assign game to each pin?
        // Temporarily defaulting to all pins being complete.
        child: PinWidget(
            name: pinName,
            planet: index,
            status: CompletionStatus.complete,
            // Optionally add a game enum: GameType.anyGame???

        ),
      );
      },
    );

    // Return a stack of this planet page's images and content.
    return Stack(
      children: [

        // First, each page always gets the background art.
        Image.asset(
          'assets/images/StarsBackground.png',
          fit: BoxFit.cover,
          height: screenHeight,
          width: double.infinity,
        ),

        // Next, we should load the planet this page refers to.

        // Pad the planet so it's directly in the middle of the screen.
        Padding(
          padding: EdgeInsets.only(
            top: (screenHeight - planetHeight) / 2,
          ),

          // This Stack will hold the planet/pins with its number below.
          child: Stack(
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
                            0.2126,0.7152,0.0722,0,0,
                            0.2126,0.7152,0.0722,0,0,
                            0.2126,0.7152,0.0722,0,0,
                            0,0,0,1,0,
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
                      height: planetHeight/2,
                      width: planetHeight/2,
                    ),
                  ),
                ),
              ),

              // Add the number below the planet. Use padding to
              // place it slightly below and to the left of the planet.
              Padding(
                padding: EdgeInsets.only(left: 40.0, top: planetHeight - 25),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    planetIndex, // Starting at 1
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Fredoka",
                      fontSize: 70,
                    ),
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