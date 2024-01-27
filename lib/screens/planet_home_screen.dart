import 'package:explore/schemas.dart';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:explore/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:realm/realm.dart';

class PlanetHomeScreen extends StatefulWidget {
  const PlanetHomeScreen({super.key});

  @override
  State<PlanetHomeScreen> createState() => _PlanetHomeScreenState();
}

class _PlanetHomeScreenState extends State<PlanetHomeScreen> {
  List<ExploreUser> users = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Open a Realm instance
      final realm = Realm(
        Configuration.local([ExploreUser.schema, Planet.schema, Level.schema]),
      );

      // Read all instances of the Person model
      final exploreUsers = realm.all<ExploreUser>();

      // Store the retrieved instances in the list
      setState(() {
        users = List.from(exploreUsers);
      });

      // Close the Realm instance when done
      // Error: code not working when realm is closed
      //realm.close();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            shape: BoxShape.rectangle,
            color: const Color(0xFF9443DC),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            // Navigate back when the back button is pressed
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/StarsBackground.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: UserInfo(),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: IconGridWidget(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First Row: Circle with Image
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                color: Color(0xFF9443DC),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/TestMonster.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        // Second Row: Text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Slevin',
              style: TextStyle(
                  fontSize: 40, color: Colors.white, fontFamily: "Fredoka"),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        // Third Row: Rectangular Chip
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF9443DC),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text on the left end
                  Text(
                    '117',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Fredoka",
                      fontSize: 20,
                    ),
                  ),

                  // Icon on the right end
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class IconGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        // Define a list of indices to place icons in
        // each one will have a different image associated with it
        List<int> blueIconIndices = [1, 3, 4, 6];

        // Check if the current index is in the list of blue icon indices
        bool isBlueIconIndex = blueIconIndices.contains(index);

        return Container(
          child: isBlueIconIndex
              ? PlanetWidget(
                  completionStatus: CompletionStatus.complete,
                )
              : null, // Display null for cells without an icon
          alignment: Alignment.center,
        );
      },
    );
  }
}

enum CompletionStatus { complete, current, locked }

class PlanetWidget extends StatelessWidget {
  final CompletionStatus completionStatus;

  PlanetWidget({super.key, required this.completionStatus});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/TestMonster.png",
        ),
        // show green check mark if the planet is complete
        completionStatus == CompletionStatus.complete
            ? Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 15),
                ),
              )
            // show the rocket if this is the current level
            : completionStatus == CompletionStatus.current
                ? Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.lock, color: Colors.grey, size: 30),
                    ),
                  )
                // show a lock symbol if the level is locked
                : Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.rocket, color: Colors.white, size: 40),
                    ),
                  ),
      ],
    );
  }
}


// this is the code to move the page to the next screen
// ElevatedButton(
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const PlanetMapScreen(),
//                 ),
//               ),
//               child: const Text("Choose Planet"),
//             ),
