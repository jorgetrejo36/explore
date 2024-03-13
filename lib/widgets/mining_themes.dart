// Each theme contains the name of the svg/png file needed for each varible
// to plug in use "${ThisClass.varible}.svg" for icons
// or "${ThisClass.varible}.png" for backgrounds

import 'package:explore/screens/planet_map_screen.dart';

class MiningTheme {
  late String theme;
  late String miningSurface;
  late String miningCurrency;
  late String background;

  MiningTheme(GameTheme inputTheme) {
    switch (inputTheme) {
      case GameTheme.earth:
        miningSurface = "meteorite";
        miningCurrency = "diamond";
        background = "EarthMining";
        break;

      case GameTheme.mars:
        miningSurface = "meteorite";
        miningCurrency = "ruby";
        background = "MarsMining";
        break;

      case GameTheme.neptune:
        miningSurface = "bubbles";
        miningCurrency = "pearl";
        background = "NeptuneMining";
        break;

      case GameTheme.saturn:
        miningSurface = "one-asteroid";
        miningCurrency = "gem";
        background = "SaturnMining";
        break;

      case GameTheme.space:
        miningSurface = "one-asteroid";
        miningCurrency = "crystals";
        background = "SpaceMining";
        break;

      default:
        miningSurface = "one-asteroid";
        miningCurrency = "crystals";
        background = "SpaceMining";
        break;
    }
  }
}
