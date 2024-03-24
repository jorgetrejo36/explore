import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/realm_utils.dart';

/// Displays the player's custom rocket for use over a planet or level.
class PMSRocketWidget extends StatefulWidget {
  const PMSRocketWidget({super.key});

  @override
  State<PMSRocketWidget> createState() => _PMSRocketWidgetState();
}

class _PMSRocketWidgetState extends State<PMSRocketWidget> {
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
    // The player's rocket will need to load here.
    return SizedBox(
      child: SvgPicture.asset(
        // Load the player's rocket image.
        rocketPath,
        width: MediaQuery.of(context).size.width * 0.1,
      ),
    );
  }
}
