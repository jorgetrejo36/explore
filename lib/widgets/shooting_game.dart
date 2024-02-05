import 'package:flutter/material.dart';

import '../screens/planet_map_screen.dart';

// The Shooting Game's contents are included here.
// Currently a skeleton of the base game (some elements/art).
// Adding most basic functionality this week (lives, points,
// game end/win and widgets).

class ShootingGameStateful extends StatefulWidget {
  final GameTheme planet;
  const ShootingGameStateful({super.key, required this.planet});

  @override
  State<ShootingGameStateful> createState() => _ShootingGameState();
}

class _ShootingGameState extends State<ShootingGameStateful> {

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
            // Note...in games, may want to make this always take you to
            // LEVEL SELECT instead.
            onPressed: () => Navigator.pop(context),
          ),

        ),
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          
          // Background sky gradient for the game (all art will
          // change soon to use theming settings based on the planet).
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
          Positioned(
            top: 0,
            child: Image.asset(
              'assets/images/shooting_earth_sky_art.png',
              height: MediaQuery.of(context).size.height * 1.05,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),

          // Text at the top to display the skeleton title (temp).
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "\nShooting Game",
                  style: TextStyle(
                    fontFamily: "Fredoka",
                    fontSize: 36,
                  ),
                ),
              ],
            ),
          ),

          // Ground (ground_art) for the Earth shooting game.
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/images/shooting_earth_ground_art.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          ),

          // Player rocket (also temporary).
          Positioned(
            bottom: -325,
            right: -185,
            child: Image.asset(
              'assets/images/shooting_player.png',
              height: MediaQuery.of(context).size.height,
            ),
          ),

        ],
      ),
    );
  }
}
