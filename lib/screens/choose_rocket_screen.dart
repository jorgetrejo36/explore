import 'package:explore/screens/choose_avatar_screen.dart';
import 'package:flutter/material.dart';

class ChooseRocketScreen extends StatelessWidget {
  const ChooseRocketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool rocketSelected = false;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Navigate back when the back button is pressed
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
            onTap: () {
              rocketSelected = true;
      },
            child: Container(
              height:100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: rocketSelected ? Colors.grey: Colors.blue,
              ),
              margin: const EdgeInsets.all(10.0),
              child: Image.asset('assets/rocketImage1.jpg'
              ),
            ),
            ),
            Container(
              height:100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              margin: const EdgeInsets.all(10.0),
              child: Image.asset('assets/rocketImage2.jpg'
              ), // Image.asset
            ),
            Container(
              height:100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              margin: const EdgeInsets.all(10.0),
              child: Image.asset('assets/rocketImage3.jpg'
              ), // Image.asset
            ),
            Container(
              height:100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              margin: const EdgeInsets.all(10.0),
              child: Image.asset('assets/rocketImage4.jpg'
              ), // Image.asset
            ),

            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChooseAvatarScreen(),
                ),
              ),

            ),
      ],

        ),
      ),
    );
  }
}
