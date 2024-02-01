import 'package:explore/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GameResultScreen extends StatelessWidget {
  const GameResultScreen({super.key});

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
                    child: const Column(
                      children: [
                        Expanded(
                          child: DataBoxWidget(
                            imagePath: "assets/images/diamond.svg",
                            score: 5,
                          ),
                        ),
                        Expanded(
                          child: DataBoxWidget(
                            imagePath: "assets/images/star.svg",
                            score: 123,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.35, // 45% of the screen (85/100),
                  child: const AvatarWithRocketWidget(),
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
  const AvatarWithRocketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/images/car.svg',
        width: 200, // Set the width of the SvgPicture
        height: 200, // Set the height of the SvgPicture
      ),
    );
  }
}
