import 'package:flutter/material.dart';
import 'package:explore/widgets/pms_planet_page.dart';
import 'package:explore/widgets/pms_appbar.dart';

class PlanetMapScreen extends StatelessWidget {
  // Used to scroll to the planet we selected on the previous page.
  final int selectedPlanet;

  const PlanetMapScreen({Key? key, required this.selectedPlanet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // Use the custom AppBar for the Planet Map Screen.
      appBar: const PMSAppBarWidget(),
      body: Stack(
        children: [

          // Use a scroll view to store the planet pages.
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            reverse: true,
            controller: ScrollController(
              // Calculate which page height to scroll to.
              initialScrollOffset:
              (selectedPlanet) * MediaQuery.of(context).size.height,
            ),

            child: Column(
              // Generate the planet pages in reverse order so
              // they grow in indices from bottom to top.
              children: List.generate(4, (index) {
                return PlanetPage(index: index + 1);
              }).reversed.toList(),
            ),

          ),
        ],
      ),
    );
  }
}
