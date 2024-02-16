import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SGPlayerRocket extends StatelessWidget {
  // Is the rocket on (flame visible)?
  final bool isOn;
  // Where is this rocket placed on the screen?
  final double rocketX;
  final double rocketY;

  // Constructor. Initialize rocket Y for now, will change later.
  const SGPlayerRocket({
    Key? key,
    required this.isOn,
    required this.rocketX,
    required this.rocketY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: rocketX,
      top: rocketY,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Rocket image
          SvgPicture.asset(
            'assets/images/rocket1.svg',
            height: MediaQuery.of(context).size.height * 0.14,
          ),
          // Flame below rocket (only show if the rocket is on!)
          if (isOn)
            Positioned(
              top: (795 * 0.14), // Adjust this value to position the flame
              child: SvgPicture.asset(
                'assets/images/rocketFlame.svg',
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ),
        ],
      ),
    );
  }
}
