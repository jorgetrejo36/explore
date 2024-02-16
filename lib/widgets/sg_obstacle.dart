import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SGObstacle extends StatelessWidget {
  // Shooting Game obstacle properties.

  // Stores the image path to the obstacle and the reward once it's broken.
  final String obstacleImg;
  final String obstacleRewardImg;

  // Is this obstacle destroyed?
  final bool isDestroyed;

  // What is the answer displayed on this obstacle?
  final int answerValue;

  // What is the index of this obstacle in the list of all obstacles?
  final int obstacleIndex;

  // What problem number is this obstacle associated with?
  final int problemNum;

  // At what Y value is this obstacle currently at?
  final double obstacleHeight;

  // Constructor
  const SGObstacle({
    Key? key,
    required this.obstacleImg,
    required this.obstacleRewardImg,
    this.isDestroyed = false,
    required this.answerValue,
    required this.obstacleIndex,
    required this.problemNum,
    required this.obstacleHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: obstacleHeight,
      child: GestureDetector(
        onTap: () {
          // Handle obstacle click
          print("Obstacle clicked: Index $obstacleIndex");
        },
        child: Column(
          children: [

            // SVG image for obstacle
            SvgPicture.asset(
              obstacleImg,
              width: 50,
              height: 50,
            ),

            // Text overlay displaying value
            Text(
              answerValue.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Fredoka",
              ),
            ),

          ],
        ),
      ),
    );
  }
}