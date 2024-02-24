// Each theme contains the name of the svg/png file needed for each varible
// to plug in use "${ThisClass.varible}.svg" for icons
// or "${ThisClass.varible}.png" for backgrounds

class RacingTheme {
  late String theme;
  late String racingStart;
  late String background;
  late String playerVehicle;
  late String enemyVehicle;

  RacingTheme(String inputTheme) {
    theme = inputTheme.toLowerCase();

    switch (theme) {
      case "earth":
        playerVehicle = "car";
        enemyVehicle = "ufo";
        background = "EarthRacing";
        racingStart = "EarthRacingStart";
        break;

      case "mars":
        playerVehicle = "car";
        enemyVehicle = "ufo";
        background = "MarsRacing";
        racingStart = "MarsRacingStart";
        break;

      case "neptune":
        playerVehicle = "car";
        enemyVehicle = "ufo";
        background = "NeptuneRacing";
        racingStart = "NeptuneRacingStart";
        break;

      case "saturn":
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
