import 'package:explore/screens/create_name_screen.dart';
import 'package:flutter/material.dart';

class ChooseAvatarScreen extends StatelessWidget {
  const ChooseAvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            Container(
              height:50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              margin: const EdgeInsets.all(10.0),
              child: Image.asset('assets/avatar.jpg'
              ),
            ),
            Container(
              height:50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              margin: const EdgeInsets.all(10.0),
              child: Image.asset('assets/avatar.jpg'
              ),
            ), Container(
              height:50,
              width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
              margin: const EdgeInsets.all(10.0),
              child: Image.asset('assets/avatar.jpg'
              ),
            ), Container(
              height:50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              margin: const EdgeInsets.all(10.0),
              child: Image.asset('assets/avatar.jpg'
              ),
            ), Container(
              height:50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              margin: const EdgeInsets.all(10.0),
              child: Image.asset('assets/avatar.jpg'
              ),
            ), Container(
              height:50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              margin: const EdgeInsets.all(10.0),
              child: Image.asset('assets/avatar.jpg'
              ),
            ), Container(
              height:50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              margin: const EdgeInsets.all(10.0),
              child: Image.asset('assets/avatar.jpg'
              ),
            ), Container(
              height:50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              margin: const EdgeInsets.all(10.0),
              child: Image.asset('assets/avatar.jpg'
              ),
            ),

            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateNameScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
