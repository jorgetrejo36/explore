class GeyserRepo {
  Map<String, String> getVariant(variant) {
    Map<String, String> skins;

    switch (variant) {
      case 'mars':
        skins = {
          "background": 'assets/images/mars-bg.svg',
        };
        print("I Chose mars");

      default:
        skins = {"background": 'assets/images/mars-bg.svg'};
    }

    return skins;
  }
}
