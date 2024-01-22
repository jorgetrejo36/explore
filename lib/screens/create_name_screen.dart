import 'package:explore/schemas.dart';
import 'package:explore/screens/planet_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

class CreateNameScreen extends StatelessWidget {
  const CreateNameScreen({super.key});

  void createNewUser({required BuildContext context}) async {
    // create the new avatar in the DB
    // open local realm instance
    final realm = Realm(
      Configuration.local([ExploreUser.schema, Planet.schema, Level.schema]),
    );

    final user = ExploreUser(ObjectId(), "User1", "Avatar1", 1, 200, 3, 0);
    realm.write(() {
      realm.add(user);
    });

    realm.close();
    // finish DB operations

    // pop the last 3 screens in the create avatar sequence
    // ChooseRocketScreen, ChooseAvatarScreen, and CreateNameScreen (which is this screen)
    for (int i = 0; i < 3; i++) {
      Navigator.pop(context);
    }
    // push the planet home screen after this new avatar has been created
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlanetHomeScreen(),
      ),
    );
  }

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

            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                //labelText: 'Enter your username',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => createNewUser(context: context),

            ),
          ],
        ),
      ),
    );
  }
}
