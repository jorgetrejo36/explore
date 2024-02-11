import 'package:explore/schemas.dart';
import 'package:realm/realm.dart';

final Configuration config = Configuration.local(
  [ExploreUser.schema, Planet.schema, Level.schema],
);

class RealmUtils {
  // this function handles the creation of a new user and adding all the
  // necessary planets and levels for this user to be able to properly save
  // their data
  ExploreUser createNewUser(
      String username, String avatarImagePath, int rocketColor) {
    // the user
    final ObjectId userId = ObjectId();

    // create the 4 distinct planets

    final user = ExploreUser(
      userId,
      username,
      avatarImagePath,
      rocketColor,
      0, // this is a new user so total score is 0
      0, // this is a new user so total items is 0
      1, // all users start at level 1
    );

    return user;
  }
}
