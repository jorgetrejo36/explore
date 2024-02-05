// Each theme contains the name of the svg/png file needed for each varible
// to plug in use "${ThisClass.varible}.svg" for icons
// or "${ThisClass.varible}.png" for backgrounds

class MiningTheme {
  late String theme;
  late String miningSurface;
  late String miningCurrency;
  late String background;

  MiningTheme(String inputTheme) {
    theme = inputTheme.toLowerCase();

    switch (theme) {
      case "earth":
        miningSurface = "meteorite";
        miningCurrency = "diamond";
        background = "EarthMining";
        break;

      case "mars":
        miningSurface = "meteorite";
        miningCurrency = "ruby";
        background = "MarsMining";
        break;

      case "neptune":
        miningSurface = "bubbles";
        miningCurrency = "pearl";
        background = "NeptuneMining";
        break;

      case "saturn":
        miningSurface = "one-asteroid";
        miningCurrency = "gem";
        background = "SaturnMining";
        break;

      case "space":
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
