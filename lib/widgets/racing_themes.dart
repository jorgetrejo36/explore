// Each theme contains the name of the svg/png file needed for each varible
// to plug in use "${ThisClass.varible}.svg" for icons
// or "${ThisClass.varible}.png" for backgrounds

import 'package:explore/screens/planet_map_screen.dart';

class RacingTheme {
  late String theme;
  late String racingStart;
  late String background;
  late String playerVehicle;
  late String enemyVehicle;

  RacingTheme(GameTheme inputTheme) {
    switch (inputTheme) {
      case GameTheme.earth:
        playerVehicle = "car";
        enemyVehicle = "ufo";
        background = "EarthRacing";
        racingStart = "EarthRacingStart";
        break;

      case GameTheme.mars:
        playerVehicle = "car";
        enemyVehicle = "ufo";
        background = "MarsRacing";
        racingStart = "MarsRacingStart";
        break;

      case GameTheme.neptune:
        playerVehicle = "car";
        enemyVehicle = "ufo";
        background = "NeptuneRacing";
        racingStart = "NeptuneRacingStart";
        break;

      case GameTheme.saturn:
        playerVehicle = "car";
        enemyVehicle = "ufo";
        background = "SaturnRacing";
        racingStart = "SaturnRacingStart";
        break;

      default:
        playerVehicle = "car";
        enemyVehicle = "diamond";
        background = "EarthRacing";
        racingStart = "EarthRacingStart";
        break;
    }
  }
}
