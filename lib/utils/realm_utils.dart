import 'package:explore/schemas.dart';
import 'package:explore/screens/planet_home_screen.dart';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:explore/utils/user_controller.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

final Configuration config = Configuration.local(
  [ExploreUser.schema, Planet.schema, Level.schema],
  // take this out for production
  shouldDeleteIfMigrationNeeded: true,
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

class PlanetLevelLockStatus {
  final bool planetStatus;
  final List<CompletionStatus> levelStatuses;

  PlanetLevelLockStatus({
    required this.planetStatus,
    required this.levelStatuses,
  });
}

class KeyUserInfo {
  final ObjectId id;
  final String name;
  final String avatar;

  KeyUserInfo({required this.id, required this.name, required this.avatar});
}

class PlayerData {
  final String name;
  final String score;
  final String imgName;

  PlayerData({required this.name, required this.score, required this.imgName});
}

class RocketAvatar {
  final String avatarPath;
  final String rocketPath;

  RocketAvatar({required this.avatarPath, required this.rocketPath});
}

class RealmUtils {
  String getRocketPath() {
    // get current logged in user
    final UserController loggedInUser = Get.find();

    // open local realm instance
    final realm = Realm(config);

    final ExploreUser user =
        realm.find<ExploreUser>(loggedInUser.id) as ExploreUser;

    final String rocketPath = user.rocketPath;

    // close realm instance
    realm.close();

    return rocketPath;
  }

  String getAvatarPath() {
    // get current logged in user
    final UserController loggedInUser = Get.find();

    // open local realm instance
    final realm = Realm(config);

    final ExploreUser user =
        realm.find<ExploreUser>(loggedInUser.id) as ExploreUser;

    final String avatarPath = user.avatarPath;

    // close realm instance
    realm.close();

    return avatarPath;
  }

  RocketAvatar getRocketAvatar() {
    // get current logged in user
    final UserController loggedInUser = Get.find();

    // open local realm instance
    final realm = Realm(config);

    final ExploreUser user =
        realm.find<ExploreUser>(loggedInUser.id) as ExploreUser;

    final RocketAvatar rocketAvatar =
        RocketAvatar(avatarPath: user.avatarPath, rocketPath: user.rocketPath);

    // close realm instance
    realm.close();

    return rocketAvatar;
  }

  KeyUserInfo getUser(ObjectId id) {
    // open local realm instance
    final realm = Realm(config);

    final ExploreUser user = realm.find<ExploreUser>(id) as ExploreUser;

    final KeyUserInfo userInfo =
        KeyUserInfo(id: id, name: user.name, avatar: user.avatarPath);

    // close realm instance
    realm.close();

    return userInfo;
  }

  List<KeyUserInfo> getAllUsers() {
    // open local realm instance
    final realm = Realm(config);

    final users = realm
        .all<ExploreUser>()
        .map(
          (user) => KeyUserInfo(
            id: user.id,
            name: user.name,
            avatar: user.avatarPath,
          ),
        )
        .toList();

    // close realm instance
    realm.close();

    return users;
  }

  List<PlanetLevelLockStatus> getPlanetLevelLockStatuses() {
    // open local realm instance
    final realm = Realm(config);

    // get the user controller
    final UserController loggedInUser = Get.find();

    // Get current user
    final ExploreUser user =
        realm.find<ExploreUser>(loggedInUser.id) as ExploreUser;

    // Create a shallow copy of the original list
    final List<Planet> sortedPlanets = [...user.planets];
    // sort sortedPlanets (which is not yet sorted)
    sortedPlanets
        .sort((a, b) => a.identifyingEnum.compareTo(b.identifyingEnum));

    final List<bool> planetStatuses = sortedPlanets
        .map(
          (planet) =>
              CompletionStatus.values[planet.status] == CompletionStatus.locked
                  ? false
                  : true,
        )
        .toList();

    // make a list of lists for the lock status of the individual levels
    final List<List<CompletionStatus>> levelStatuses =
        List.generate(planetStatuses.length, (_) => []);

    for (int i = 0; i < planetStatuses.length; i++) {
      if (planetStatuses[i] == true) {
        // sort the levels into the correct order after retrieving from DB
        final List<Level> sortedLevels = [...sortedPlanets[i].levels];
        sortedLevels
            .sort((a, b) => a.levelNumOnPlanet.compareTo(b.levelNumOnPlanet));

        // add the completion statuses to the levelStatuses list
        levelStatuses[i] = sortedLevels
            .map((level) => CompletionStatus.values[level.status])
            .toList();
      }
    }

    // add this to the proper object
    final List<PlanetLevelLockStatus> planetLevelLockStatuses = [];

    for (int i = 0; i < planetStatuses.length; i++) {
      planetLevelLockStatuses.add(
        PlanetLevelLockStatus(
          planetStatus: planetStatuses[i],
          levelStatuses: levelStatuses[i],
        ),
      );
    }

    realm.close();

    return planetLevelLockStatuses;
  }

  // this function handles the creation of a new user and adding all the
  // necessary planets and levels for this user to be able to properly save
  // their data
  ExploreUser createNewUser(
    String username,
    String avatarImagePath,
    String rocketImagePath,
  ) {
    // open local realm instance
    final realm = Realm(config);

    // the user
    final ObjectId userId = ObjectId();

    final List<Planet> planets = [];

    // create the 4 distinct planets
    for (int i = 0; i < numPlanets; i++) {
      final List<Level> levels = [];
      // create all the levels that will be within the planet
      for (int j = 0; j < levelsPerPlanet; j++) {
        final ObjectId levelId = ObjectId();

        // this is the final version that needs to be implemented
        levels.add(
          Level(
            levelId,
            j + 1,
            questionsPerLevel,
            i == 0 && j == 0
                ? CompletionStatus.current.index
                : CompletionStatus.locked.index,
            double.maxFinite,
            0,
            0,
          ),
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
      rocketImagePath,
      0, // this is a new user so total score is 0
      0, // this is a new user so total items is 0
      1, // all users start at level 1
      planets: planets,
    );

    // get the user controller
    final UserController loggedInUser = Get.find();

    // take the id of the user that was just created and assign it to the user
    // controller
    loggedInUser.updateId(user.id);

    realm.write(() {
      realm.add(user);
    });

    realm.close();

    return user;
  }

  List<PlayerData> getLeaderboardUsers() {
    // open local realm instance
    final realm = Realm(config);

    // Get all users
    final users = realm.all<ExploreUser>().toList();

    // Sort users by total score in descending order
    users.sort((a, b) => b.totalScore.compareTo(a.totalScore));

    // Map ExploreUser instances to PlayerData instances for leaderboard
    final List<PlayerData> leaderboardUsers = users
        .map(
          (user) => PlayerData(
            name: user.name,
            score: user.totalScore.toString(),
            imgName: user.avatarPath, // You may want to modify this
          ),
        )
        .toList();

    // close realm instance
    realm.close();

    return leaderboardUsers;
  }
}
