import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'shooting_game.dart';

// Assigned to all obstacles that do not yet have an answer option. Hides
// the text on the obstacle.
const int emptyObstacle = 9999;
// Assigned to obstacles if they are solved correctly; hides the text, but
// displays the reward image (when destroyed).
const int correctObstacle = -9999;
// Assigned to obstacles if they have been filled before. Hides the text, and
// prevents us from adding an answer choice to them.
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
  // Has this obstacle been marked for deletion (to disappear)?
  late bool markForDeletion;
  // Has this obstacle been marked for an update (to re-build)?
  late bool markForUpdate;
  // How many seconds should this obstacle exist before being deleted?
  int secondsToExist = 2;

  // Is this entire obstacle and everything else visible?
  late bool alive;

  // What is the answer displayed on this obstacle?
  late int answerValue;

  // What is the index of this obstacle in the list of all obstacles?
  // There are 3 obstacles per question, so this is [0-(3*numProblems - 1)].
  final int obstacleIndex;

  // At what X value is this obstacle currently at?
  late double obstacleX;
  // At what Y value is this obstacle currently at?
  late double obstacleY;
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
    this.markForDeletion = false,
    this.markForUpdate = false,
    required this.obstacleIndex,
    required this.obstacleX,
    required this.obstacleY,
    required this.obstacleCol,
  }) : super(key: key);

  @override
  SGObstacleState createState() => SGObstacleState();
}

class SGObstacleState extends State<SGObstacle> with TickerProviderStateMixin {
  // Stores the Y position of this obstacle.
  late double obstacleY;
  // The ticker used to repeatedly drop this obstacle.
  late Ticker dropTicker;
  // Gets assigned in build(); same as rocketYPos in shooting_game.dart.
  late double rocketYTop;
  // How fast should this obstacle drop?
  double dropRate = 0.85;

  // Used for animation.
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize this obstacle's Y position and turn it on (make it visible).
    obstacleY = widget.obstacleY;
    widget.alive = true;

    // Calculate the distance each obstacle needs to cover
    double distanceToCover = MediaQuery.of(context).size.height + 100 - obstacleY;

    // Calculate the duration based on the distance and drop rate
    double durationInSeconds = ( distanceToCover / dropRate) / 40;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: durationInSeconds.toInt()), // Adjust duration as needed
    );

    // Use Tween to animate the obstacleY from its initial position to the bottom of the screen
    _animation = Tween<double>(
      begin: obstacleY,
      end: MediaQuery.of(context).size.height,
      // Note that "end" does not matter as collisions occur before this.
    ).animate(_controller);

    // Create a ticker and instruct it to move the obstacle and update
    // its visual information.
    dropTicker = createTicker((_) {

      // Check if this obstacle needs an update; if so, set its state.
      if (widget.markForUpdate)
      {
        // Update this widget's fields and rebuild it on the screen.
        setState(() {
          widget.markForUpdate = false;
          widget.alive = widget.alive;
          widget.isDestroyed = widget.isDestroyed;
          widget.answerValue = widget.answerValue;
          widget.isDropping = widget.isDropping;
        });
      }

      // Check if we have invoked a deletion. If so, prime the obstacle to
      // delete itself after X secondsToExist.
      if (widget.markForDeletion)
      {
        widget.markForDeletion = false;
        _controller.stop();

        // Delete this obstacle after X secondsToExist.
        Timer(Duration(seconds: widget.secondsToExist), () {
          setState(() {
            widget.alive = false;
            widget.isDropping = false;
            dropTicker.stop();
          });
        });
      }

      // Every tick, move the obstacle down.
      if (widget.isDropping)
      {
        if (!_controller.isAnimating)
          {
            _controller.forward();
          }

        // Caused lag with setState; now updated in AnimatedBuilder widget.
        //obstacleY += dropRate;

        // Check if it has passed the yValue of the rocket.
        if (obstacleY >= rocketYTop)
        {
          // This obstacle has collided with the rocket.
          shootingGameStateInstance?.collideRocket(widget.obstacleIndex);
        }
      }
      else
      {
        _controller.stop();
      }
    });

    dropTicker.start();
  }

  @override
  Widget build(BuildContext context) {

    // Assign the same value as we did for the rocket so we know what height
    // a "collision" occurs in our dropTicker.
    rocketYTop = MediaQuery.of(context).size.height * 0.48;

    return Visibility(
      visible: widget.alive,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          obstacleY = _animation.value;
          return Positioned(
            left: widget.obstacleX,
            top: obstacleY,
            child: GestureDetector(
              onTap: () {
                shootingGameStateInstance?.shootObstacle(widget.obstacleIndex);
              },
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
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                    ),
                  ),

                  // SVG image for obstacle (when not destroyed)
                  Visibility(
                    visible: !widget.isDestroyed,
                    child: SvgPicture.asset(
                      widget.obstacleImg,
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                  ),

                  // SVG image for obstacle (when destroyed)
                  Visibility(
                    visible: widget.isDestroyed,
                    child: SvgPicture.asset(
                      widget.obstacleDestroyedImg,
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                  ),

                  // Text overlay displaying value
                  Visibility(
                    visible: (widget.answerValue != emptyObstacle &&
                        widget.answerValue != correctObstacle &&
                        widget.answerValue != filledObstacle),
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
                                // Black outline around white text.
                                // In order, the shadows display on the:
                                // bottomLeft, bottomRight, topRight, topLeft.
                                Shadow(
                                  offset: Offset(-1.5, -1.5),
                                  color: Colors.black,
                                ),
                                Shadow(
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.black,
                                ),
                                Shadow(
                                  offset: Offset(1.5, 1.5),
                                  color: Colors.black,
                                ),
                                Shadow(
                                  offset: Offset(-1.5, 1.5),
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Override dispose to clear the dropTicker when done.
  @override
  void dispose() {
    dropTicker.dispose();
    _controller.dispose();
    super.dispose();
  }
}
