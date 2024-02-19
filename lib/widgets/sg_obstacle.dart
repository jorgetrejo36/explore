import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'shooting_game.dart';

// Assigned to all obstacles that do not yet have an answer option.
const int emptyObstacle = 9999;
// Assigned to obstacles if they are used on the 1st try to correctly
// solve a problem.
const int correctObstacle = -9999;
// Assigned to obstacles if they have been filled before.
const int filledObstacle = 99999;

class SGObstacle extends StatefulWidget {
  // Shooting Game obstacle properties.

  // Stores the image paths to the obstacle, its reward, and destroyed variant.
  final String obstacleImg;
  final String obstacleRewardImg;
  final String obstacleDestroyedImg;

  // Is this obstacle destroyed?
  late bool isDestroyed;
  // Is this obstacle dropping?
  late bool isDropping;

  // Is this entire obstacle and everything else visible?
  late bool alive;

  // What is the answer displayed on this obstacle?
  late int answerValue;

  // What is the index of this obstacle in the list of all obstacles?
  // There are 3 obstacles per question, so this is [0-(3*numProblems - 1)].
  final int obstacleIndex;

  // At what X value is this obstacle currently at?
  final double obstacleX;
  // At what Y value is this obstacle currently at?
  final double obstacleY;
  // What column is this obstacle in?
  final String obstacleCol;

  // Constructor; all obstacles begin with no (empty) values.
  SGObstacle({
    Key? key,
    required this.obstacleImg,
    required this.obstacleRewardImg,
    required this.obstacleDestroyedImg,
    this.isDestroyed = false,
    this.answerValue = emptyObstacle,
    this.isDropping = false,
    this.alive = true,
    required this.obstacleIndex,
    required this.obstacleX,
    required this.obstacleY,
    required this.obstacleCol,
  }) : super(key: key);

  @override
  _SGObstacleState createState() => _SGObstacleState();

}

class _SGObstacleState extends State<SGObstacle> with TickerProviderStateMixin {
  // Stores the Y position of this obstacle.
  late double obstacleY;
  // The ticker used to repeatedly drop this obstacle.
  late Ticker dropTicker;
  // Gets assigned in build(); same as rocketYPos in shooting_game.dart.
  late double rocketYTop;

  // How fast should this obstacle drop?
  double dropRate = 0.3;

  @override
  void initState() {
    super.initState();
    obstacleY = widget.obstacleY;
    widget.alive = true;

    // Create a ticker and instruct it to move the obstacle on every tick.
    dropTicker = createTicker((_) {
      // Every tick, move the obstacle down
      if (widget.isDropping)
        {
          setState(() {
            obstacleY += dropRate; // Adjust the rate of falling as needed
          });

          // Check if it has passed the yValue of the rocket.
          if (obstacleY >= rocketYTop)
            {
              // This obstacle has collided with the rocket.
              shootingGameStateInstance?.collideRocket(widget.obstacleIndex);
            }
        }
    });

    dropTicker.start();
  }

  @override
  Widget build(BuildContext context) {
    rocketYTop = MediaQuery.of(context).size.height * 0.48;

    return Visibility(
      visible: widget.alive,
      child: Positioned(
        left: widget.obstacleX,
        top: obstacleY,
        child: GestureDetector(
          onTap: () {
            // Attempt to shoot the obstacle.
            shootingGameStateInstance?.shootObstacle(widget.obstacleIndex);
          },
          // The SMASHED image should also stop moving, so it should be a diff
          // object and, when created, appear at the exact position of the origin
          // obstacle.
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // SVG image for reward (if answered correctly)
              Visibility(
                visible: widget.isDestroyed && widget.answerValue == correctObstacle,
                child: Positioned(
                  top: -54,
                  child: SvgPicture.asset(
                    widget.obstacleRewardImg,
                    width: 56,
                    height: 56,
                  ),
                ),
              ),

              // SVG image for obstacle (when not destroyed)
              Visibility(
                visible: !widget.isDestroyed,
                child: SvgPicture.asset(
                  widget.obstacleImg,
                  width: 92,
                  height: 92,
                ),
              ),

              // SVG image for obstacle (when destroyed)
              Visibility(
                visible: widget.isDestroyed,
                child: SvgPicture.asset(
                  widget.obstacleDestroyedImg,
                  width: 92,
                  height: 92,
                ),
              ),

              // Text overlay displaying value
              Visibility(
                visible: (widget.answerValue != emptyObstacle &&
                          widget.answerValue != correctObstacle),
                child: Stack(
                  children: [
                    // White text for answer value.
                    Visibility(
                      visible: !widget.isDestroyed,
                      child: Text(
                        widget.answerValue.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Fredoka",
                            shadows: [
                              Shadow( // bottomLeft
                                  offset: Offset(-1.5, -1.5),
                                  color: Colors.black
                              ),
                              Shadow( // bottomRight
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.black
                              ),
                              Shadow( // topRight
                                  offset: Offset(1.5, 1.5),
                                  color: Colors.black
                              ),
                              Shadow( // topLeft
                                  offset: Offset(-1.5, 1.5),
                                  color: Colors.black
                              ),
                            ]
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    dropTicker.dispose();
    super.dispose();
  }
}
