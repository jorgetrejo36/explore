import 'dart:async';
import 'dart:ui';
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
  const SGPlayerRocket({
    Key? key,
    required this.isOn,
    required this.rocketX,
    required this.rocketY,
  }) : super(key: key);

  @override
  State<SGPlayerRocket> createState() => _SGPlayerRocketState();
}

class _SGPlayerRocketState extends State<SGPlayerRocket>
    with TickerProviderStateMixin {

  // Used to animate the rocket.
  late AnimationController _controller;
  late Animation<double> _animation;

  // Used to load the player's rocket path.
  late RocketAvatar rocketAvatar;
  late String rocketPath;

  // Previous rocket position values, used for animations.
  late double _prevRocketX;
  late double _prevRocketY;

  // Angles used for tilting rocket during animations.
  late double _tiltAngle;
  late double _oldTiltAngle;

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
    // Set the current position to be the "previous" so we can keep track.
    _prevRocketX = widget.rocketX;
    _prevRocketY = widget.rocketY;

    // Initialize the animation controller and animation for the rocket.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    // Rocket always begins vertically.
    _tiltAngle = 0.0;
    _oldTiltAngle = 0.0;

    // Load the rocket path!
    _loadData();
  }

  @override
  void didUpdateWidget(SGPlayerRocket oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOn && _controller.duration == const Duration(milliseconds: 3000))
    {
      Timer(const Duration(seconds: 3), () {
        _controller.duration = const Duration(milliseconds: 750);
      });
    }
    if (oldWidget.rocketX != widget.rocketX ||
        oldWidget.rocketY != widget.rocketY) {
      // Keep track of where the rocket was so we can lerp the animation.
      _prevRocketX = oldWidget.rocketX;
      _prevRocketY = oldWidget.rocketY;

      _oldTiltAngle = _tiltAngle;

      // Update rocket tilt angle.
      if (widget.rocketX > oldWidget.rocketX)
      {
        // We are moving right.
        _tiltAngle = 20.0;
      }
      else if (widget.rocketX < oldWidget.rocketX)
      {
        // Moving left.
        _tiltAngle = -20.0;
      }
      else
      {
        // We are staying where we are.
        _tiltAngle = 0.0;
      }

      // Restart animation when rocket position changes.
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Calculate tilt angle based on animation value
        double tilt = _tiltAngle * _animation.value * 0.025;
        if (_animation.value >= 0.5) {
          // Reverse tilt halfway through animation
          tilt = _tiltAngle * (1 - _animation.value) * 0.025;
        }

        return Positioned(
          left: lerpDouble(_prevRocketX, widget.rocketX, _animation.value),
          top: lerpDouble(_prevRocketY, widget.rocketY, _animation.value),
          child: Transform.rotate(
            angle: tilt,
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
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
