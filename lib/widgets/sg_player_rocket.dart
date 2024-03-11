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

          // Flame below rocket (only show if the rocket is on!)
          // This is separate from the rocket and does not need to be loaded.
          if (isOn)
            Positioned(
              top: (MediaQuery.of(context).size.height * 0.121),
              child: SvgPicture.asset(
                'assets/images/rocketFlame.svg',
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ),

          // TODO Player rocket image (needs to be loaded from DB).
          SvgPicture.asset(
            'assets/images/rocket1.svg',
            height: MediaQuery.of(context).size.height * 0.14,
          ),

        ],
      ),
    );
  }
}
