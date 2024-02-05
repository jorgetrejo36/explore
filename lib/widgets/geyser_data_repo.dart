class GeyserRepo {
  Map<String, String> getVariant(variant) {
    Map<String, String> skins;

    switch (variant) {
      case 'mars':
        skins = {
          "background": 'assets/images/mars-bg.svg',
          "ground": 'assets/images/geyser-off.svg',
          "top": 'assets/images/smoke.svg',
          "item": 'assets/images/ruby.svg',
        };

      case 'earth':
        skins = {
          "background": 'assets/images/mars-bg.svg',
          "ground": 'assets/images/geyser-off.svg',
          "top": 'assets/images/smoke.svg',
          "item": 'assets/images/ruby.svg',
        };

      case 'saturn':
        skins = {
          "background": 'assets/images/mars-bg.svg',
          "ground": 'assets/images/geyser-off.svg',
          "top": 'assets/images/smoke.svg',
          "item": 'assets/images/ruby.svg',
        };

      case 'neptune':
        skins = {
          "background": 'assets/images/neptune-bg.svg',
          "ground": 'assets/images/neptune-geyser.svg',
          "top": 'assets/images/smoke.svg',
          "item": 'assets/images/pearl.svg',
        };

      default:
        skins = {
          "background": 'assets/images/mars-bg.svg',
          "ground": 'assets/images/geyser-off.svg',
          "top": 'assets/images/smoke.svg',
          "item": 'assets/images/ruby.svg',
        };
    }

    return skins;
  }
}
