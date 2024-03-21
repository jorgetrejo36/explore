import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/realm_utils.dart';

class SGPlayerRocket extends StatefulWidget {
  // Is the rocket on (flame visible)?
  final bool isOn;
  // Where is this rocket placed on the screen?
  final double rocketX;
  final double rocketY;

  // Constructor. Initialize rocket Y for now, will change later.
  SGPlayerRocket({
    Key? key,
    required this.isOn,
    required this.rocketX,
    required this.rocketY,
  }) : super(key: key);

  @override
  State<SGPlayerRocket> createState() => _SGPlayerRocketState();
}

class _SGPlayerRocketState extends State<SGPlayerRocket> {
  // Used to load the player's rocket path.
  late RocketAvatar rocketAvatar;

  late String rocketPath;

  // Used to load the player's rocket.
  Future<void> _loadData() async {
    try {
      rocketAvatar = RealmUtils().getRocketAvatar();
      rocketPath = rocketAvatar.rocketPath; // (apply path to SvgPicture.asset())
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Load the rocket path!
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.rocketX,
      top: widget.rocketY,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [

          // Flame below rocket (only show if the rocket is on!)
          // This is separate from the rocket and does not need to be loaded.
          if (widget.isOn)
            Positioned(
              top: (MediaQuery.of(context).size.height * 0.121),
              child: SvgPicture.asset(
                'assets/images/rocketFlame.svg',
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ),

          SvgPicture.asset(
            rocketPath,
            height: MediaQuery.of(context).size.height * 0.14,
          ),
        ],
      ),
    );
  }
}
