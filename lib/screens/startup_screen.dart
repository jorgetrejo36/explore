import 'package:explore/screens/avatar_home_screen.dart';
import 'package:explore/utils/user_controller.dart';
import 'package:explore/widgets/sound_library.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(UserController());
    playTitleMusic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/StartupScreen.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.185,
                      bottom: 10,
                    ),
                    child: Image.asset(
                      "assets/images/AppIcon.png",
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: FittedBox(
                        child: Text(
                          "Explore",
                          style: TextStyle(
                            color: Color(0xfff6f6f6),
                            fontFamily: 'Fredoka',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.sizeOf(context).height * 0.16),
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff9173f4),
                        minimumSize: Size(140, 40),
                      ),
                      onPressed: () => {
                        playClick(),
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvatarHomeScreen(),
                          ),
                        ),
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Color(0xfff6f6f6),
                        size: 45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
