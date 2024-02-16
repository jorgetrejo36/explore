import 'package:flutter/material.dart';
import 'package:explore/widgets/sg_obstacle.dart';
import 'dart:math';
// import 'package:explore/widgets/shooting_game.dart';

class SGObstacleContainer extends StatefulWidget {
  // Constructor
  const SGObstacleContainer({Key? key}) : super(key: key);

  @override
  _SGObstacleContainerState createState() => _SGObstacleContainerState();
}

class _SGObstacleContainerState extends State<SGObstacleContainer> {
  // List of boxes, each containing 3 obstacles
  late List<List<SGObstacle>> boxes;

  // List containing references to all obstacles
  late List<SGObstacle> allObstacles;

  @override
  void initState() {
    super.initState();
    // Initialize lists
    boxes = [];
    allObstacles = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: allObstacles,
    );
  }

  // Function to generate obstacles for each box
  void generateObstacles(int numProblems) {
    // Clear existing obstacles
    setState(() {
      boxes.clear();
      allObstacles.clear();
    });

    // Generate obstacles for each problem
    for (int i = 1; i <= numProblems; i++) {
      // Generate a box for the current problem
      List<SGObstacle> box = generateBox(i);
      // Add the box to the list of boxes
      boxes.add(box);
      // Add the obstacles from the box to the list of all obstacles
      allObstacles.addAll(box);
    }

    // Sort all obstacles by their heights
    allObstacles.sort((a, b) => a.obstacleHeight.compareTo(b.obstacleHeight));
  }

  // Function to generate a box with 3 obstacles for a problem
  List<SGObstacle> generateBox(int problemNum) {
    // Generate three obstacles with random heights
    double minHeight = 0;
    double maxHeight = 200; // Adjust max height as needed
    Random random = Random();

    List<SGObstacle> box = [];
    for (int i = 0; i < 3; i++) {
      // Set random heights.
      double obstacleHeight = minHeight +
          random.nextDouble() * (maxHeight - minHeight);

      // Assign X position based on column.
      double obstacleX;

      // Replace, in order, with leftX, centerX, rightX, and centerX.
      switch (i) {
        case 0:
          obstacleX = 0;
          break;
        case 1:
          obstacleX = 0;
          break;
        case 2:
          obstacleX = 0;
          break;
        default:
          obstacleX = 0;
      }
      // Create obstacle widget
      SGObstacle obstacle = SGObstacle(
        obstacleImg: 'assets/images/asteroids.svg',
        obstacleRewardImg: 'assets/images/diamond.svg',
        answerValue: 0, // Will be filled in via problem generator when ready.
        obstacleIndex: i,
        problemNum: problemNum,
        obstacleHeight: obstacleHeight,
      );
      box.add(obstacle);
    }
    return box;
  }
}