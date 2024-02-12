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
  late final ObjectId id;
  late int identifyingEnum; // enum
  late String name;
  late int status; // enum
  late int totalItems;
  late int collectedItems;
  late List<_Level> levels;
}

@RealmModel()
class _Level {
  @PrimaryKey()
  late final ObjectId id;
  late int questionAmount;
  late bool status;
  late double timeTaken;
  late int questionsCorrect;
  late int highscore;
}
