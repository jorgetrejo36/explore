import 'package:explore/schemas.dart';
import 'package:explore/screens/planet_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:explore/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateNameScreen extends StatelessWidget {
  final String selectedImage;
  final int selectedRocket;



  const CreateNameScreen({
    Key? key,
    required this.selectedImage,
    required this.selectedRocket,
  }) : super(key: key);

  void createNewUser({required BuildContext context, required String userName}) async {
    // create the new avatar in the DB
    // open local realm instance
    ObjectId userId = ObjectId();

    final realm = Realm(
      Configuration.local([ExploreUser.schema, Planet.schema, Level.schema]),
    );

    final user = ExploreUser(userId, userName, selectedImage, selectedRocket, 0, 0, 1);
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
        builder: (context) => PlanetHomeScreen(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imageSize = screenWidth * 0.4; // 40% of the screen width
    double textFieldWidth = screenWidth * 0.8; // 80% of the screen width

    TextEditingController _nameController = TextEditingController();

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
            // Navigate back when the back button is pressed
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
              Container(
                width: imageSize + 20, // Adjust as needed
                height: imageSize + 20, // Adjust as needed
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightGrey, // Change the color as needed
                ),
                child: Center(
                  child: SvgPicture.asset(
                    selectedImage,
                    width: imageSize,
                    height: imageSize,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03), // 3% of the screen height spacing
              Container(
                width: textFieldWidth,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey, // Light gray background color
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white, // White border color
                    width: 3.0, // Set the border width
                  ),
                ),
                child: TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.black), // Text color
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightGrey, // Light gray background color
                      border: InputBorder.none
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03), // 3% of the screen height spacing
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkPurple,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.check),
                  color: AppColors.white,
                  onPressed: () => createNewUser(context: context, userName: _nameController.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}