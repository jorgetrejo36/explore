import 'package:flutter/material.dart';
import 'package:explore/app_colors.dart';
import 'package:explore/screens/choose_avatar_screen.dart';

class ChooseRocketScreen extends StatefulWidget {
  const ChooseRocketScreen({Key? key}) : super(key: key);

  @override
  _ChooseRocketScreenState createState() => _ChooseRocketScreenState();
}

class _ChooseRocketScreenState extends State<ChooseRocketScreen> {
  String selectedRocket = "";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double rocketSize = screenWidth * 0.3; // 30% of the screen width
    double spacing = screenWidth * 0.03; // 3% of the screen width

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            color: AppColors.darkPurple,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/StarsBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildRocketAvatar(Icons.rocket_launch_outlined, rocketSize),
                  SizedBox(width: spacing),

                  buildRocketAvatar(Icons.rocket_outlined, rocketSize),
                ],
              ),
              SizedBox(height: spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildRocketAvatar(Icons.rocket_launch, rocketSize),
                  SizedBox(width: spacing),
                  buildRocketAvatar(Icons.rocket, rocketSize),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRocketAvatar(IconData icon, double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selectedRocket == icon.toString() ? AppColors.lightGrey : AppColors.darkBlue,
      ),
      margin: const EdgeInsets.all(10.0),
      child: IconButton(
        icon: Icon(icon),
        onPressed: () {
          selectRocket(icon.toString());
          navigateToChooseAvatarScreen();
        },
      ),
    );
  }

  void selectRocket(String rocket) {
    setState(() {
      selectedRocket = rocket;
    });
  }

  void navigateToChooseAvatarScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChooseAvatarScreen(),
      ),
    );
  }
}
