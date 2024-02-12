import 'package:explore/schemas.dart';
import 'package:explore/screens/planet_home_screen.dart';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:realm/realm.dart';

final Configuration config = Configuration.local(
  [ExploreUser.schema, Planet.schema, Level.schema],
);

const Map<GameTheme, String> gameThemeToName = {
  GameTheme.earth: "Earth",
  GameTheme.mars: "Mars",
  GameTheme.saturn: "Saturn",
  GameTheme.neptune: "Neptune",
};

// these constants define the base for all users, do not change them unless it
// is purposely intended
const int totalPlanetItems = 10;
const int questionsPerLevel = 5;

class RealmUtils {
  // this function handles the creation of a new user and adding all the
  // necessary planets and levels for this user to be able to properly save
  // their data
  ExploreUser createNewUser(
      String username, String avatarImagePath, int rocketColor) {
    // the user
    final ObjectId userId = ObjectId();

    final List<Planet> planets = [];

    // create the 4 distinct planets
    for (int i = 0; i < numPlanets; i++) {
      final List<Level> levels = [];
      // create all the levels that will be within the planet
      for (int i = 0; i < levelsPerPlanet; i++) {
        final ObjectId levelId = ObjectId();
        levels.add(
          Level(levelId, questionsPerLevel, false, double.maxFinite, 0, 0),
        );
      }

      final ObjectId planetId = ObjectId();
      planets.add(
        Planet(
          planetId,
          i,
          gameThemeToName[GameTheme.values[i]] ?? "unknown",
          i == 0
              ? CompletionStatus.current.index
              : CompletionStatus.locked.index,
          totalPlanetItems,
          0,
          levels: levels,
        ),
      );
    }

    final user = ExploreUser(
      userId,
      username,
      avatarImagePath,
      rocketColor,
      0, // this is a new user so total score is 0
      0, // this is a new user so total items is 0
      1, // all users start at level 1
      planets: planets,
    );

    return user;
  }
}
