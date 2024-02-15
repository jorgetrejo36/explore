import 'package:explore/schemas.dart';
import 'package:explore/screens/choose_rocket_screen.dart';
import 'package:explore/screens/leaderboard_screen.dart';
import 'package:explore/screens/planet_home_screen.dart';
import 'package:explore/utils/realm_utils.dart';
import 'package:explore/utils/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:explore/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

const int maxUsers = 8;

class AvatarHomeScreen extends StatefulWidget {
  const AvatarHomeScreen({Key? key}) : super(key: key);

  @override
  _AvatarHomeScreenState createState() => _AvatarHomeScreenState();
}

class _AvatarHomeScreenState extends State<AvatarHomeScreen> {
  late List<KeyUserInfo> users;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      users = RealmUtils().getAllUsers();
      print(users[0].name);
      print(users[0].avatar);
    } catch (e) {
      print('Error loading data: $e');
    }
  }

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
              Center(
                child: Container(
                  width: screenWidth * 2.5,
                  height: screenWidth * 2.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(rocketImage), // Rocket image
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.3,
                    children: List.generate(
                      maxUsers,
                      (index) => index < users.length
                          ? ElevatedButton(
                              onPressed: () {
                                // get the user controller
                                final UserController loggedInUser = Get.find();
                                // take the id of the user that was selected and assign it to the user
                                // controller
                                loggedInUser.updateId(users[index].id);
                                // Navigate to the planet home screen for this user
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlanetHomeScreen(),
                                  ),
                                  // this is used so the page reloads when it comes back
                                ).then((_) => setState(() {
                                      _loadData();
                                    }));
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: buttonColors[index + 1],
                              ),
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    users[index].avatar,
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text(users[index].name,
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            )
                          : index == users.length
                              ? ElevatedButton(
                                  onPressed: () {
                                    // Navigate to the choose rocket screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChooseRocketScreen(),
                                      ),
                                      // this is used so the page reloads when it comes back
                                    ).then((_) => setState(() {
                                          _loadData();
                                        }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: buttonColors[index + 1],
                                  ),
                                  child: Image.asset(
                                    buttonImage,
                                    width: 40,
                                    height: 40,
                                  ),
                                )
                              : const SizedBox
                                  .shrink(), // this is an emtpy widget intended to show nothing
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -spacing * 3,
                right: 0,
                left: 0,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LeaderboardScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: avatarSize,
                      height: avatarSize * 1.2,
                      decoration: BoxDecoration(
                        color: Color(0xFFBFCDDB),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            trophyImage,
                            width: 110,
                            height: 130,
                          ),
                        ],
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
