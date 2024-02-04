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
