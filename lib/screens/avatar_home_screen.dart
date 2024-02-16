import 'package:explore/screens/choose_rocket_screen.dart';
import 'package:explore/screens/leaderboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:explore/app_colors.dart';

class AvatarHomeScreen extends StatefulWidget {
  const AvatarHomeScreen({Key? key});

  @override
  _AvatarHomeScreenState createState() => _AvatarHomeScreenState();
}

class _AvatarHomeScreenState extends State<AvatarHomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth * 0.25;
    double spacing = screenWidth * 0.06;

    // Image path for the circle buttons
    String buttonImage = "assets/images/Vector.png";
    String trophyImage = "assets/images/trophy.png"; // Path to additional image
    String rocketImage = "assets/images/rocket.png";

    // Define a map to assign colors to specific button indices
    Map<int, Color> buttonColors = {
      1: Color(0xFF9443DC),
      2: Color(0xFF2AB2D7),
      3: Color(0xFF3E7CDA),
      4: Color(0xFF6D4CF1),
      5: Color(0xFF9443DC),
      6: Color(0xFF2AB2D7),
      7: Color(0xFF3E7CDA),
      8: Color(0xFF6D4CF1),
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/StarsBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  rocketImage, // Rocket image
                  fit: BoxFit.contain,
                ),
              ),
              Center(
                child: Container(
                  width: screenWidth * .5,
                  height: screenWidth * 1.2,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 20,
                    childAspectRatio: .85,
                    children: List.generate(
                      8,
                      (index) => ElevatedButton(
                        onPressed: () {
                          // Navigate to the ChooseRocketScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseRocketScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          primary: buttonColors[index + 1],
                        ),
                        child: Image.asset(
                          buttonImage,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: spacing * 3,
                right: screenWidth * 0.15,
                left: screenWidth * 0.15,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LeaderboardScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      primary: Color(0xFF647F86),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        trophyImage,
                        width: 110,
                        height: 130,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
