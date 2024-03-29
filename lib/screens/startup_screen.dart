import 'package:explore/screens/avatar_home_screen.dart';
import 'package:flutter/material.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

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
                      height: 180,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 225),
                    child: const Text(
                      "Explore",
                      style: TextStyle(
                        color: Color(0xfff6f6f6),
                        fontSize: 70,
                        fontFamily: 'Fredoka',
                      ),
                    ),
                  ),
                  IconButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff9173f4),
                      minimumSize: Size(140, 40),
                    ),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AvatarHomeScreen(),
                      ),
                    ),
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Color(0xfff6f6f6),
                      size: 45,
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
