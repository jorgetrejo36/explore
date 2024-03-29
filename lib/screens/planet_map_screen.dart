import 'package:flutter/material.dart';
import 'package:explore/widgets/pms_planet_page.dart';
import 'package:explore/widgets/pms_appbar.dart';

// Variables for planets, levels, and games

// Enable to view level names and types beside each pin.
const bool debugView = true;

// How many planets are there?
// Update this and the code in pms_planet_page to add more planets.
int numPlanets = 4;

// Possible games that can be played from a level.
// Update both variables when adding or removing a game & hot restart.
// Want to add more game types? Update these two variables and
// the loadGame() function found in pms_pin.dart.
enum GameType {geyser, shooting, mining, racing}
int numGameTypes = 4;

// Possible themes for games.
enum GameTheme {earth, mars, saturn, neptune, space}

// Test changing the seed per each planet below after updating
// levels per planet so the pins always look nicely placed.
int levelsPerPlanet = 8;



/// Screen that dynamically builds a scrollable list of planet pages.
class PlanetMapScreen extends StatelessWidget {

  // Used to scroll to the planet we selected on the previous page.
  final int selectedPlanet;

  const PlanetMapScreen({Key? key, required this.selectedPlanet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // Use the custom AppBar for the Planet Map Screen.
      appBar: const PMSAppBarWidget(),
      body: Stack(
        children: [

          // Use a scroll view to store the planet pages.
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            reverse: true,
            controller: ScrollController(
              // Calculate which page height to scroll to.
              initialScrollOffset:
              (selectedPlanet) * MediaQuery.of(context).size.height,
            ),

            child: Column(
              // Generate the planet pages in reverse order so
              // they grow in indices from bottom to top.
              children: List.generate(numPlanets, (index) {
                return PlanetPage(index: index + 1);
              }).reversed.toList(),
            ),

          ),
        ],
      ),
    );
  }
}
