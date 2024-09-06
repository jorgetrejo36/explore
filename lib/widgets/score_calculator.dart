// this needs to be made official

import 'package:explore/screens/planet_map_screen.dart';

enum Game { mining, shooting, geyser, racing }

int calculateScore(Game game, int currency, int timer) {
  int score;

  switch (game) {
    // Fast run through time: 15s
    case Game.geyser:
      {
        score = helperFunction(15, timer);
      }
    // Fast run through time: 10s
    case Game.mining:
      {
        score = helperFunction(10, timer);
      }
    // Fast run through time: 25s
    case Game.shooting:
      {
        score = helperFunction(25, timer);
      }
    // Fast run through time: 10s
    case Game.racing:
      {
        score = helperFunction(10, timer);
      }
  }

  // worst score possible: 40
  if (score < 40) {
    score = 40;
  }

  return score;
}

int helperFunction(int gameConstant, int time) {
  final double overallConstant = 100 / levelsPerPlanet;
  return (levelsPerPlanet * overallConstant * (gameConstant / time)).round();
}
