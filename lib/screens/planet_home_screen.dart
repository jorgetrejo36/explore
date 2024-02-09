import 'package:explore/schemas.dart';
import 'package:explore/screens/leaderboard_screen.dart';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:explore/utils/realm_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:realm/realm.dart';

class PlanetHomeScreen extends StatefulWidget {
  final ObjectId userId;
  const PlanetHomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<PlanetHomeScreen> createState() => _PlanetHomeScreenState();
}

class _PlanetHomeScreenState extends State<PlanetHomeScreen> {
  ExploreUser? currentUser;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Open a Realm instance
      final realm = Realm(config);

      // Read all instances of the Person model
      // Read the user with the provided userId
      final user = realm
          .all<ExploreUser>()
          .where((user) => user.id == widget.userId)
          .firstOrNull;

      // Store the retrieved instances in the list
      setState(() {
        currentUser = user;
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
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: UserInfo(user: currentUser),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: const IconGridWidget(
                  numPlanets: 4,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.30,
                child: const LeaderboardIconWidget(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final ExploreUser? user;

  const UserInfo({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if there is at least one user in the list
    // Check if there is a user
    if (user != null) {
      return Column(
        children: [
          // First Row: Circle with Image
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF9443DC),
                    ),
                  ),
                  Center(
                    //db pull the svg
                    child: SvgPicture.asset(
                      user!.avatar,
                      width: 70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          // Third Row: Rectangular Chip
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9443DC),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text on the left end
                    //db pull score
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
                      padding: EdgeInsets.only(left: 2.0),
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
    } else {
      return Center(
        child: Text(
          'No user data available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }
}

class IconGridWidget extends StatelessWidget {
  final int numPlanets;
  const IconGridWidget({super.key, required this.numPlanets});

  // calculate the indices that need to have a planet in them
  // the calculation is based off if the numPlanets is odd or even
  // it will always place the planets in two rows. The planets will start in
  // the bottom left corner and then zig zag up/down to the right until all of
  // them are iterated through
  List<int> calculatePlanetIndices() {
    List<int> planetIndices = [];

    // even numbers
    if (numPlanets % 2 == 0) {
      for (int i = 1; i < numPlanets; i += 2) {
        planetIndices.add(i);
      }
      for (int i = numPlanets; i < numPlanets * 2; i += 2) {
        planetIndices.add(i);
      }
      // odd numbers
    } else {
      for (int i = 1; i < numPlanets * 2; i += 2) {
        planetIndices.add(i);
      }
    }

    return planetIndices;
  }

  // organize the planets from the DB (which should be stored in proper order)
  // into the order which the grid will read
  List<String> reorganizePlanetPaths() {
    // FIXME: these paths will eventually be from the DB
    List<String> planetPaths = [
      "assets/images/earth.svg",
      "assets/images/mars.svg",
      "assets/images/saturn.svg",
      "assets/images/neptune.svg",
    ];
    List<String> newPlanetPaths = List<String>.filled(numPlanets, "");

    int indexForEvenIndices = numPlanets ~/ 2;
    int indexForOddIndices = 0;

    for (int i = 0; i < planetPaths.length; i++) {
      if (i % 2 == 0) {
        newPlanetPaths[indexForEvenIndices++] = planetPaths[i];
      } else {
        newPlanetPaths[indexForOddIndices++] = planetPaths[i];
      }
    }

    return newPlanetPaths;
  }

  @override
  Widget build(BuildContext context) {
    List<int> planetIndices = calculatePlanetIndices();
    List<String> planetPaths = reorganizePlanetPaths();
    int planetPathsIndex = 0;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // disable scrolling
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: numPlanets,
      ),
      itemCount: numPlanets * 2,
      itemBuilder: (context, index) {
        // Check if the current index is in the list of planet indices
        bool isPlanetIndex = planetIndices.contains(index);

        return Container(
          alignment: Alignment.center,
          child: isPlanetIndex
              ? PlanetWidget(
                  completionStatus: CompletionStatus.complete,
                  planetPath: planetPaths[planetPathsIndex++],
                )
              : null, // Display null for cells without a planet
        );
      },
    );
  }
}

enum CompletionStatus { complete, current, locked }

class PlanetWidget extends StatelessWidget {
  final CompletionStatus completionStatus;
  final String planetPath;

  const PlanetWidget({
    super.key,
    required this.completionStatus,
    required this.planetPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          // FIXME Pass in 0-3 when clicking Earth-Neptune to scroll to that planet.
          // Currently, this line makes all planets scroll to 0 (Earth).
          // Scroll is implemented but needs a dynamic parameter here.
          builder: (context) => const PlanetMapScreen(selectedPlanet: 0),
        ),
      ),
      child: Stack(
        children: [
          SvgPicture.asset(
            planetPath,
            semanticsLabel: "A planet",
            width: 80,
          ),
          // show green check mark if the planet is complete
          completionStatus == CompletionStatus.complete
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.check, color: Colors.white, size: 15),
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
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.rocket,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    )
                  // show a lock symbol if the level is locked
                  : Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}

class LeaderboardIconWidget extends StatelessWidget {
  const LeaderboardIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LeaderboardScreen(),
          ),
        ),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: const Color.fromARGB(144, 135, 135, 135), // Box color
            borderRadius: BorderRadius.circular(20.0), // Rounded edges
          ),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.emoji_events, // Trophy icon
                size: 100,
                color: Colors.yellow, // Trophy color
              ),
              // You can add more widgets on top of the trophy if needed
            ],
          ),
        ),
      ),
    );
  }
}
