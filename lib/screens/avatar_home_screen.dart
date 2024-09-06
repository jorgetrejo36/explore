import 'package:explore/screens/choose_rocket_screen.dart';
import 'package:explore/screens/delete_avatar_screen.dart';
import 'package:explore/screens/leaderboard_screen.dart';
import 'package:explore/screens/planet_home_screen.dart';
import 'package:explore/utils/realm_utils.dart';
import 'package:explore/utils/user_controller.dart';
import 'package:explore/widgets/sound_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

const int maxUsers = 8;

class AvatarHomeScreen extends StatefulWidget {
  const AvatarHomeScreen({Key? key}) : super(key: key);

  @override
  AvatarHomeScreenState createState() => AvatarHomeScreenState();
}

class AvatarHomeScreenState extends State<AvatarHomeScreen> {
  late List<KeyUserInfo> users;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      users = RealmUtils().getAllUsers();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Align(
          alignment: Alignment.centerRight,
          child: users.isNotEmpty
              ? IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/trash-can.svg',
                    height: MediaQuery.of(context).size.height / 15,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeleteAvatarScreen(),
                    ),
                  ).then(
                    (_) => setState(() {
                      _loadData();
                    }),
                  ),
                )
              : null,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/StarsBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                rocketImage, // Rocket image
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: SizedBox(
                width: screenWidth * .60,
                height: screenWidth * 1.15,
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.5,
                  children: List.generate(
                    maxUsers,
                    (index) => index < users.length
                        ? ElevatedButton(
                            onPressed: () {
                              // Button Sound
                              playClick();

                              // get the user controller
                              final UserController loggedInUser = Get.find();
                              // take the id of the user that was selected and assign it to the user
                              // controller
                              loggedInUser.updateId(users[index].id);
                              // Navigate to the planet home screen for this user
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PlanetHomeScreen(),
                                ),
                                // this is used so the page reloads when it comes back
                              ).then(
                                (_) => setState(() {
                                  _loadData();
                                }),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: buttonColors[index + 1],
                            ),
                            child: Stack(
                              children: [
                                SvgPicture.asset(
                                  users[index].avatar,
                                  width: 450,
                                  height: 450,
                                ),
                                Positioned(
                                  bottom: -1,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFAC6FE3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      users[index].name,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : index == users.length
                            ? ElevatedButton(
                                onPressed: () {
                                  // Button Sound
                                  playClick();

                                  // Navigate to the choose rocket screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ChooseRocketScreen(),
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
                    backgroundColor: Color(0xFF647F86),
                    shadowColor:
                        Colors.black, //specify the button's elevation color
                    elevation: 5.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      trophyImage,
                      width: 110,
                      height: MediaQuery.of(context).size.height / 7,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
