import 'package:realm/realm.dart';

part 'schemas.g.dart';

@RealmModel()
class _ExploreUser {
  @PrimaryKey()
  late final ObjectId id;

  late String name;
  late String avatar;
  late int rocketColor; // enum
  late int totalScore;
  late int totalItems;
  late int currentLevel;
  late List<_Planet> planets;
}

@RealmModel()
class _Planet {
  @PrimaryKey()
  late final int id;

  late String image;
  late String name;
  late bool status;
  late int collectedItems;
  late int totalItems;
  late List<_Level> levels;
}

@RealmModel()
class _Level {
  @PrimaryKey()
  late final int id;

  late int difficulty;
  late int questionAmount;
  late bool status;
  late double timeTaken;
  late int questionsCorrect;
  late int highscore;
}
