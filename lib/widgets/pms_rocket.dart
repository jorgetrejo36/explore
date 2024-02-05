import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Displays the player's custom rocket for use over a planet or level.
class PMSRocketWidget extends StatelessWidget {
  const PMSRocketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // The player's rocket will need to load here.
    return SizedBox(
      child: SvgPicture.asset(
        // Temporarily using a public domain rocket placeholder.
        // FIXME Load custom rocket from DB
        "assets/images/rocket_temp.svg",
        height: 80,
        width: 48,
      ),
    );
  }
}
