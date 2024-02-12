import '../screens/planet_map_screen.dart';

class ShootingTheme {
  late GameTheme theme;
  late String shootingPlanet;
  late String shootingSky;
  late String shootingObstacles;
  late String background;

  // To be implemented this week along with animiations.

  shootingTheme() {

    switch (theme) {
      case GameTheme.earth:
        shootingPlanet = "earth";
        shootingSky = "cloudsEarth";
        shootingObstacles = "asteroids";
        background = "earthShootingBackground";
        break;

      case GameTheme.mars:
        shootingPlanet = "mars";
        shootingSky = "cloudsMars";
        shootingObstacles = "asteroids";
        background = "marsShootingBackground";
        break;

      case GameTheme.saturn:
        shootingPlanet = "saturn";
        shootingSky = "stars";
        shootingObstacles = "rings";
        background = "saturnShootingBackground";
        break;

      case GameTheme.neptune:
        shootingPlanet = "neptune";
        shootingSky = "none";
        shootingObstacles = "fish";
        background = "neptuneShootingBackground";
        break;

      case GameTheme.space:
        shootingPlanet = "none";
        shootingSky = "stars";
        shootingObstacles = "asteroids";
        background = "spaceShootingBackground";
        break;

      default:
        shootingPlanet = "none";
        shootingSky = "none";
        shootingObstacles = "none";
        background = "none";
        break;
    }
  }
}