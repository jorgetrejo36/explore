import 'package:explore/screens/planet_map_screen.dart';

class GeyserRepo {
  Map<String, String> getVariant(variant) {
    Map<String, String> skins;

    switch (variant) {
      case GameTheme.mars:
        skins = {
          "background": 'assets/images/MarsGeyser.png',
          "ground": 'assets/images/geyser-off.svg',
          "top": 'assets/images/smoke.svg',
          "item": 'assets/images/ruby.svg',
        };

      case GameTheme.earth:
        skins = {
          "background": 'assets/images/EarthGeyser.png',
          "ground": 'assets/images/GeyserGround.svg',
          "top": 'assets/images/ufo.svg',
          "item": 'assets/images/diamond.svg',
        };

      case GameTheme.saturn:
        skins = {
          "background": 'assets/images/SaturnGeyser.png',
          "ground": 'assets/images/asteroids.svg',
          "top": 'assets/images/ufo.svg',
          "item": 'assets/images/gem.svg',
        };

      case GameTheme.neptune:
        skins = {
          "background": 'assets/images/NeptuneMining.png',
          "ground": 'assets/images/neptune-geyser.svg',
          "top": 'assets/images/GeyserBubbles.svg',
          "item": 'assets/images/pearl.svg',
        };

      default:
        skins = {
          "background": 'assets/images/MarsGeyser.png',
          "ground": 'assets/images/geyser-off.svg',
          "top": 'assets/images/smoke.svg',
          "item": 'assets/images/ruby.svg',
        };
    }

    return skins;
  }
}
