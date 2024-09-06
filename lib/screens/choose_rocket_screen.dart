import 'package:flutter/material.dart';
import 'package:explore/app_colors.dart';
import 'package:explore/screens/choose_avatar_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:explore/widgets/sound_library.dart';

class ChooseRocketScreen extends StatefulWidget {
  const ChooseRocketScreen({Key? key}) : super(key: key);

  @override
  _ChooseRocketScreenState createState() => _ChooseRocketScreenState();
}

class _ChooseRocketScreenState extends State<ChooseRocketScreen> {
  String stringRocket = "";
  int selectedRocket = 0;

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
              onPressed: () => {
                    playClick(),
                    Navigator.pop(context),
                  }),
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
                  buildRocketAvatar('assets/images/rocket1.svg', rocketSize),
                  SizedBox(width: spacing),
                  buildRocketAvatar('assets/images/rocket2.svg', rocketSize),
                ],
              ),
              SizedBox(height: spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildRocketAvatar('assets/images/rocket3.svg', rocketSize),
                  SizedBox(width: spacing),
                  buildRocketAvatar('assets/images/rocket4.svg', rocketSize),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRocketAvatar(
    String svgPath,
    double size,
  ) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            stringRocket == svgPath ? AppColors.darkGrey : AppColors.lightGrey,
      ),
      margin: const EdgeInsets.all(10.0),
      child: IconButton(
        icon: Transform.rotate(
          angle: 30 * (3.1415926535 / 180), // Rotate 30 degrees to the right
          child: SvgPicture.asset(
            svgPath, // Replace with your SVG file path
          ),
        ),
        onPressed: () {
          playClick();
          selectRocket(svgPath);
          navigateToChooseAvatarScreen(svgPath);
        },
      ),
    );
  }

  void selectRocket(String rocket) {
    setState(() {
      stringRocket = rocket;
    });
  }

  void navigateToChooseAvatarScreen(String selectedRocketPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChooseAvatarScreen(selectedRocketPath: selectedRocketPath),
      ),
    );
  }
}
