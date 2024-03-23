import 'package:explore/app_colors.dart';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:explore/utils/realm_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:explore/widgets/score_calculator.dart';
import 'package:explore/widgets/sound_library.dart';

class GameResultScreen extends StatefulWidget {
  final Game game;
  final int currency;
  final int level;
  final GameTheme planet;
  final int time;

  GameResultScreen({
    super.key,
    required this.currency,
    required this.game,
    required this.level,
    required this.planet,
    required this.time,
  });

  late int score = calculateScore(game, currency, time);

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen> {
  late RocketAvatar rocketAvatar;

  @override
  void initState() {
    super.initState();
    stopMusic();
    _loadData();
  }

  Future<void> _loadData() async {
    playLevelComplete();
    try {
      rocketAvatar = RealmUtils().getRocketAvatar();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/StarsBackground.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top:
                        MediaQuery.of(context).size.height * 0.05, // 5% (5/100)
                    bottom:
                        MediaQuery.of(context).size.height * 0.05, // 5% (5/100)
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.35, // 35% of the screen (40/100)
                    child: Column(
                      children: [
                        Expanded(
                          child: DataBoxWidget(
                            imagePath: "assets/images/diamond.svg",
                            score: widget.currency,
                          ),
                        ),
                        Expanded(
                          child: DataBoxWidget(
                            imagePath: "clock",
                            score: widget.time,
                          ),
                        ),
                        Expanded(
                          child: DataBoxWidget(
                            imagePath: "assets/images/star.svg",
                            score: widget.score,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.35, // 45% of the screen (85/100),
                  child: AvatarWithRocketWidget(
                    rocketAvatar: rocketAvatar,
                  ),
                ),
                Expanded(
                  child:
                      Container(), // Empty container to take up remaining space
                ),
                Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle, // Shape of the container
                      color: AppColors
                          .lightPurple, // Background color of the button
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(15),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white, // Icon color
                        size: 40, // Icon size
                      ),
                      onPressed: () {
                        // Button Sound
                        playClick();
                        playTitleMusic();

                        // add the user score to the DB
                        RealmUtils().addUserScore(
                          level: widget.level,
                          planet: widget.planet,
                          time: widget.time,
                          currency: widget.currency,
                          score: widget.score,
                        );
                        // pop this pade to navigate back to the planet map screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PlanetMapScreen(selectedPlanet: 1)),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child:
                      Container(), // Empty container to take up remaining space
                ),
              ],
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height *
                          0.05, // 5% (5/100)
                      bottom: MediaQuery.of(context).size.height *
                          0.05, // 5% (5/100)
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.35, // 35% of the screen (40/100)
                      child: Column(
                        children: [
                          Expanded(
                            child: DataBoxWidget(
                              imagePath: "assets/images/diamond.svg",
                              score: widget.currency,
                            ),
                          ),
                          Expanded(
                            child: DataBoxWidget(
                              imagePath: "assets/images/burning.svg",
                              score: widget.time,
                            ),
                          ),
                          Expanded(
                            child: DataBoxWidget(
                              imagePath: "assets/images/star.svg",
                              score: widget.score,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.35, // 45% of the screen (85/100),
                    child: AvatarWithRocketWidget(
                      rocketAvatar: rocketAvatar,
                    ),
                  ),
                  Expanded(
                    child:
                        Container(), // Empty container to take up remaining space
                  ),
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle, // Shape of the container
                        color: AppColors
                            .lightPurple, // Background color of the button
                      ),
                      child: IconButton(
                        padding: const EdgeInsets.all(15),
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white, // Icon color
                          size: 40, // Icon size
                        ),
                        onPressed: () {
                          // add the user score to the DB
                          GameTheme planetToNavigateTo =
                              RealmUtils().addUserScore(
                            level: widget.level,
                            planet: widget.planet,
                            time: widget.time,
                            currency: widget.currency,
                            score: widget.score,
                          );
                          // pop the game result screen
                          Navigator.pop(context);
                          // push and replace with the game result screen in the
                          // correct selected planet location
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlanetMapScreen(
                                selectedPlanet: planetToNavigateTo.index,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        Container(), // Empty container to take up remaining space
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataBoxWidget extends StatelessWidget {
  final String imagePath;
  final int score;

  const DataBoxWidget({
    super.key,
    required this.imagePath,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.lightPurple,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ), // Adjust padding as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // First item taking 20% of the width
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                imagePath,
              ),
            ),
          ),
          // Second item taking 60% of the width
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '$score',
                style: const TextStyle(
                  fontFamily: "Fredoka",
                  color: Colors.white,
                  fontSize: 45,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // This takes up the remaining space just to help with centering
          Expanded(
            flex: 2,
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class AvatarWithRocketWidget extends StatelessWidget {
  final RocketAvatar rocketAvatar;

  const AvatarWithRocketWidget({super.key, required this.rocketAvatar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              // Rocket SVG
              Transform.rotate(
                angle: 1,
                child: SvgPicture.asset(
                  rocketAvatar.rocketPath,
                  width: 100,
                  fit: BoxFit.contain,
                  // Path to your bottom SVG file Adjust the width as needed
                ),
              ),
              // Top SVG
              Positioned(
                left: 53,
                bottom: 85,
                child: ClipOval(
                  child: Transform.scale(
                    scale: 1.5,
                    child: SvgPicture.asset(
                      rocketAvatar.avatarPath,
                      width:
                          37, // Path to your top SVG file Adjust the width as needed
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
