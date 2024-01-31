import 'package:explore/screens/choose_rocket_screen.dart';
import 'package:explore/screens/leaderboard_screen.dart';
import 'package:explore/screens/planet_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:explore/app_colors.dart';



class AvatarHomeScreen extends StatelessWidget {
  const AvatarHomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth * 0.25; 
    double spacing = screenWidth * 0.06; 

    // Image path for the circle buttons
    String buttonImage = "assets/images/Vector.png";
    String trophyImage = "assets/images/trophy.png"; // Path to additional image

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

    
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: Center(
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(290, 0, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      primary: Colors.transparent, // Set transparent background
                      elevation: 0, // No shadow
                    ),
                    child: Image.asset(
                      'assets/images/VectorSetting.png',
                      width: 30, // Adjust icon size as needed
                      height: 30, // Adjust icon size as needed
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
                  height: MediaQuery.of(context).size.height * 0.7, // Adjust height as needed
                  decoration: BoxDecoration(
                    color: Color(0xFFBFCDDB), // BFCDDB color
                    borderRadius: BorderRadius.circular(20.0), // Set border radius
                  ),
                  padding: EdgeInsets.symmetric(vertical: spacing),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30, // Adjust the spacing between rows
                    crossAxisSpacing: 10, // Adjust the spacing between columns
                    childAspectRatio: 1.3, // Adjust the aspect ratio of each grid item
                    children: List.generate(
                      8,
                      (index) => ElevatedButton(
                        onPressed: () {
                          // Navigate to the LeaderboardScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseRocketScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          primary: buttonColors[index + 1], // Assign button color from the map
                        ),
                        child: Image.asset(
                          buttonImage,
                          width: 40, // Adjust image size as needed
                          height: 40, // Adjust image size as needed
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing), // Fixed spacing between containers
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeaderboardScreen()
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
                    height: MediaQuery.of(context).size.height * 0.2, // Adjust height as needed
                    decoration: BoxDecoration(
                    color: Color(0xFFBFCDDB), // BFCDDB color
                    borderRadius: BorderRadius.circular(20.0), // Set border radius
                  ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          trophyImage,
                          width: 110, // Adjust image size as needed
                          height: 130, // Adjust image size as needed
                        ),
                        const Text(
                          "Leaderboard",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 30,
                            fontFamily: 'Fredoka',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
