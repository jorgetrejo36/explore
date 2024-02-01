import 'package:explore/app_colors.dart';
import 'package:explore/screens/create_name_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChooseAvatarScreen extends StatefulWidget {
  final int selectedRocket;

  const ChooseAvatarScreen({Key? key, required this.selectedRocket}) : super(key: key);

  @override
  _ChooseAvatarScreenState createState() => _ChooseAvatarScreenState();
}

class _ChooseAvatarScreenState extends State<ChooseAvatarScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth * 0.25; // 25% of the screen width
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
              size: 35,
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
                  buildAvatarIconButton(
                      context, avatarSize, 'assets/images/alien.svg'),
                  SizedBox(width: spacing),
                  buildAvatarIconButton(
                      context, avatarSize, 'assets/images/alien2.svg'),
                ],
              ),
              SizedBox(height: spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildAvatarIconButton(
                      context, avatarSize, 'assets/images/alien3.svg'),
                  SizedBox(width: spacing),
                  buildAvatarIconButton(
                      context, avatarSize, 'assets/images/alien.svg'),
                ],
              ),
              SizedBox(height: spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildAvatarIconButton(
                      context, avatarSize, 'assets/images/alien2.svg'),
                  SizedBox(width: spacing),
                  buildAvatarIconButton(
                      context, avatarSize, 'assets/images/alien3.svg'),
                ],
              ),
              SizedBox(height: spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildAvatarIconButton(
                      context, avatarSize, 'assets/images/alien.svg'),
                  SizedBox(width: spacing),
                  buildAvatarIconButton(
                      context, avatarSize, 'assets/images/alien.svg'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAvatarIconButton(
      BuildContext context, double size, String svgPath) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightGrey,
      ),
      width: size,
      height: size,
      margin: const EdgeInsets.all(10.0),
      child: IconButton(
        icon: SvgPicture.asset(
          svgPath,
          width: size,
          height: size,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateNameScreen(selectedImage: svgPath, selectedRocket: widget.selectedRocket),
          ),
        ),
      ),
    );
  }
}
