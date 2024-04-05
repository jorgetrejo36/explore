import 'package:explore/schemas.dart';
import 'package:explore/screens/leaderboard_screen.dart';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:explore/utils/realm_utils.dart';
import 'package:explore/utils/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';
import 'package:explore/widgets/sound_library.dart';
import 'package:explore/widgets/pms_rocket.dart';

class PlanetHomeScreen extends StatefulWidget {
  const PlanetHomeScreen({Key? key}) : super(key: key);

  @override
  State<PlanetHomeScreen> createState() => _PlanetHomeScreenState();
}

class _PlanetHomeScreenState extends State<PlanetHomeScreen> {
  late ExploreUser currentUser;
  final UserController loggedInUser = Get.find();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final UserController loggedInUser = Get.find();
      final ObjectId currentUserId = loggedInUser.id;
      // Open a Realm instance
      final realm = Realm(config);

      // find the user with the currentUserId
      final ExploreUser user =
          realm.find<ExploreUser>(currentUserId) as ExploreUser;

      // Store this user in a seperate variable
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

  // this function is used to pass down the widget tree and reload the screen
  // when coming back from the planet map screen
  void reloadScreen() {
    setState(() {
      _loadData();
    });
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
            onPressed: () => {
              // Button Sound
              playClick(), Navigator.pop(context)
            },
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
                height: MediaQuery.of(context).size.height * 0.40,
                child: IconGridWidget(
                  planets: currentUser.planets,
                  numPlanets: 4,
                  loadData: reloadScreen,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
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
  final ExploreUser user;

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
              Container(
                width: MediaQuery.of(context).size.height * 0.1,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF9443DC),
                ),
                child: Center(
                  // db pull the svg
                  child: SvgPicture.asset(
                    user.avatarPath,
                    // width: 70,
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
                user.name,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontFamily: "Fredoka",
                ),
              ),
            ],
          ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text on the left end
                    //db pull score
                    Text(
                      '${user.totalScore}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Fredoka",
                        fontSize: 20,
                      ),
                    ),

                    // Icon on the right end
                    const Padding(
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
      return const Center(
        child: Text(
          'No user data available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }
}

const Map<GameTheme, String> planetSVGs = {
  GameTheme.earth: "assets/images/earth.svg",
  GameTheme.mars: "assets/images/mars.svg",
  GameTheme.saturn: "assets/images/saturn.svg",
  GameTheme.neptune: "assets/images/neptune.svg",
};

class PlanetInfo {
  final Planet planet;
  late String imagePath;
  late CompletionStatus completionStatus;
  late GameTheme currPlanet;

  PlanetInfo(this.planet) {
    imagePath = planetSVGs[GameTheme.values[planet.identifyingEnum]] ?? "";
    completionStatus = CompletionStatus.values[planet.status];
    currPlanet = GameTheme.values[planet.identifyingEnum];
  }
}

class IconGridWidget extends StatelessWidget {
  final int numPlanets;
  final List<Planet> planets;
  final VoidCallback loadData;

  const IconGridWidget({
    super.key,
    required this.numPlanets,
    required this.planets,
    required this.loadData,
  });

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
  List<PlanetInfo> reorganizePlanetPaths() {
    // Create a shallow copy of the original list
    final List<Planet> sortedPlanets = [...planets];
    // sort sortedPlanets (which is not yet sorted)
    sortedPlanets
        .sort((a, b) => a.identifyingEnum.compareTo(b.identifyingEnum));

    // now with sorted planets
    List<PlanetInfo> planetPaths =
        planets.map((planet) => PlanetInfo(planet)).toList();

    // FIXME: these paths will eventually be from the DB
    // List<String> planetPaths = [
    //   "assets/images/earth.svg",
    //   "assets/images/mars.svg",
    //   "assets/images/saturn.svg",
    //   "assets/images/neptune.svg",
    // ];

    List<PlanetInfo> newPlanetPaths =
        List<PlanetInfo>.filled(numPlanets, PlanetInfo(planets[0]));

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
    List<PlanetInfo> planetPaths = reorganizePlanetPaths();

    int planetPathsIndex = 0;

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: GridView.builder(
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
                    completionStatus:
                        planetPaths[planetPathsIndex].completionStatus,
                    planetPath: planetPaths[planetPathsIndex].imagePath,
                    planetSelection: planetPaths[planetPathsIndex++].currPlanet,
                    loadData: loadData,
                  )
                : null, // Display null for cells without a planet
          );
        },
      ),
    );
  }
}

enum CompletionStatus { complete, current, locked }

class PlanetWidget extends StatefulWidget {
  final CompletionStatus completionStatus;
  final String planetPath;
  final GameTheme planetSelection;
  final VoidCallback loadData;

  const PlanetWidget({
    super.key,
    required this.completionStatus,
    required this.planetPath,
    required this.planetSelection,
    required this.loadData,
  });

  @override
  State<PlanetWidget> createState() => _PlanetWidgetState();
}

class _PlanetWidgetState extends State<PlanetWidget> {
  @override
  Widget build(BuildContext context) {
    final SvgPicture svg = SvgPicture.asset(
      widget.planetPath,
      semanticsLabel: "A planet",
      width: 80,
    );

    final Stack child = Stack(
      clipBehavior: Clip.none,
      children: [
        widget.completionStatus == CompletionStatus.locked
            ? Opacity(opacity: 0.5, child: svg)
            : svg,
        // show green check mark if the planet is complete
        widget.completionStatus == CompletionStatus.complete
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
                  child: const Icon(Icons.check, color: Colors.white, size: 15),
                ),
              )
            // show the rocket if this is the current level
            : widget.completionStatus == CompletionStatus.current
                ? Positioned(
                    bottom: -16,
                    right: -16,
                    child: Transform.rotate(
                      angle: 20 * 3.14 / 180,
                      child:
                          const SizedBox(height: 60, child: PMSRocketWidget()),
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
    );

    return widget.completionStatus == CompletionStatus.locked
        ? child
        : GestureDetector(
            onTap: () => {
              // Button Sound
              playClick(),
              Navigator.push(
                context,
                MaterialPageRoute(
                  // selectedPlanet will use planetselection to scroll to correct place
                  builder: (context) => PlanetMapScreen(
                    selectedPlanet: widget.planetSelection.index,
                  ),
                ),
              ).then(
                (_) => setState(() {
                  // this will reload the data to properly show the current
                  // score, planets unlocked, etc.
                  // this only works if you finish one level, still need to be 
                  // fixed for more levels
                  widget.loadData();
                }),
              ),
            },
            child: child,
          );
  }
}

class LeaderboardIconWidget extends StatelessWidget {
  const LeaderboardIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => {
          // Button Sound
          playClick(),
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LeaderboardScreen(),
            ),
          ),
        },
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
