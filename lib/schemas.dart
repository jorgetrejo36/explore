import 'package:realm/realm.dart';

part 'schemas.g.dart';

@RealmModel()
class _ExploreUser {
  @PrimaryKey()
  late final ObjectId id;

  late String name;
  late String avatarPath;
  late String rocketPath;
  late int totalScore;
  late int totalItems;
  late int currentLevel;
  late List<_Planet> planets;
}

@RealmModel()
class _Planet {
  @PrimaryKey()
  late final ObjectId id;
  late int identifyingEnum; // enum: GameTheme
  late String name;
  late int status; // enum: CompletionStatus
  late int totalItems;
  late int collectedItems;
  late List<_Level> levels;
}

@RealmModel()
class _Level {
  @PrimaryKey()
  late final ObjectId id;
  late int levelNumOnPlanet;
  late int questionAmount;
  late int status; // enum: CompletionStatus
  late double timeTaken;
  late int questionsCorrect;
  late int highscore;
}
