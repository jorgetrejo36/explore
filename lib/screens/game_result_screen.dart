import 'package:explore/app_colors.dart';
import 'package:explore/utils/realm_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:explore/widgets/score_calculator.dart';

class GameResultScreen extends StatefulWidget {
  final int currency;
  final int time;
  GameResultScreen({super.key, required this.currency, required this.time});

  late int score = calculateScore(currency, time);

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen> {
  late RocketAvatar rocketAvatar;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
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
                            imagePath: "assets/images/star.svg",
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
                      onPressed: () => Navigator.pop(context),
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
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
                imagePath, // Replace 'assets/your_image.svg' with your SVG file path/ Adjust height as needed
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
                  fontSize: 65,
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
