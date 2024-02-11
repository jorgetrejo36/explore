// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ExploreUser extends _ExploreUser
    with RealmEntity, RealmObjectBase, RealmObject {
  ExploreUser(
    ObjectId id,
    String name,
    String avatar,
    int rocketColor,
    int totalScore,
    int totalItems,
    int currentLevel, {
    Iterable<Planet> planets = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'avatar', avatar);
    RealmObjectBase.set(this, 'rocketColor', rocketColor);
    RealmObjectBase.set(this, 'totalScore', totalScore);
    RealmObjectBase.set(this, 'totalItems', totalItems);
    RealmObjectBase.set(this, 'currentLevel', currentLevel);
    RealmObjectBase.set<RealmList<Planet>>(
        this, 'planets', RealmList<Planet>(planets));
  }

  ExploreUser._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => throw RealmUnsupportedSetError();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get avatar => RealmObjectBase.get<String>(this, 'avatar') as String;
  @override
  set avatar(String value) => RealmObjectBase.set(this, 'avatar', value);

  @override
  int get rocketColor => RealmObjectBase.get<int>(this, 'rocketColor') as int;
  @override
  set rocketColor(int value) => RealmObjectBase.set(this, 'rocketColor', value);

  @override
  int get totalScore => RealmObjectBase.get<int>(this, 'totalScore') as int;
  @override
  set totalScore(int value) => RealmObjectBase.set(this, 'totalScore', value);

  @override
  int get totalItems => RealmObjectBase.get<int>(this, 'totalItems') as int;
  @override
  set totalItems(int value) => RealmObjectBase.set(this, 'totalItems', value);

  @override
  int get currentLevel => RealmObjectBase.get<int>(this, 'currentLevel') as int;
  @override
  set currentLevel(int value) =>
      RealmObjectBase.set(this, 'currentLevel', value);

  @override
  RealmList<Planet> get planets =>
      RealmObjectBase.get<Planet>(this, 'planets') as RealmList<Planet>;
  @override
  set planets(covariant RealmList<Planet> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<ExploreUser>> get changes =>
      RealmObjectBase.getChanges<ExploreUser>(this);

  @override
  ExploreUser freeze() => RealmObjectBase.freezeObject<ExploreUser>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ExploreUser._);
    return const SchemaObject(
        ObjectType.realmObject, ExploreUser, 'ExploreUser', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('avatar', RealmPropertyType.string),
      SchemaProperty('rocketColor', RealmPropertyType.int),
      SchemaProperty('totalScore', RealmPropertyType.int),
      SchemaProperty('totalItems', RealmPropertyType.int),
      SchemaProperty('currentLevel', RealmPropertyType.int),
      SchemaProperty('planets', RealmPropertyType.object,
          linkTarget: 'Planet', collectionType: RealmCollectionType.list),
    ]);
  }
}

class Planet extends _Planet with RealmEntity, RealmObjectBase, RealmObject {
  Planet(
    ObjectId id,
    String name,
    int status,
    int totalItems,
    int collectedItems, {
    Iterable<Level> levels = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'totalItems', totalItems);
    RealmObjectBase.set(this, 'collectedItems', collectedItems);
    RealmObjectBase.set<RealmList<Level>>(
        this, 'levels', RealmList<Level>(levels));
  }

  Planet._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => throw RealmUnsupportedSetError();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  int get status => RealmObjectBase.get<int>(this, 'status') as int;
  @override
  set status(int value) => RealmObjectBase.set(this, 'status', value);

  @override
  int get totalItems => RealmObjectBase.get<int>(this, 'totalItems') as int;
  @override
  set totalItems(int value) => RealmObjectBase.set(this, 'totalItems', value);

  @override
  int get collectedItems =>
      RealmObjectBase.get<int>(this, 'collectedItems') as int;
  @override
  set collectedItems(int value) =>
      RealmObjectBase.set(this, 'collectedItems', value);

  @override
  RealmList<Level> get levels =>
      RealmObjectBase.get<Level>(this, 'levels') as RealmList<Level>;
  @override
  set levels(covariant RealmList<Level> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Planet>> get changes =>
      RealmObjectBase.getChanges<Planet>(this);

  @override
  Planet freeze() => RealmObjectBase.freezeObject<Planet>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Planet._);
    return const SchemaObject(ObjectType.realmObject, Planet, 'Planet', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.int),
      SchemaProperty('totalItems', RealmPropertyType.int),
      SchemaProperty('collectedItems', RealmPropertyType.int),
      SchemaProperty('levels', RealmPropertyType.object,
          linkTarget: 'Level', collectionType: RealmCollectionType.list),
    ]);
  }
}

class Level extends _Level with RealmEntity, RealmObjectBase, RealmObject {
  Level(
    ObjectId id,
    int questionAmount,
    bool status,
    double timeTaken,
    int questionsCorrect,
    int highscore,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'questionAmount', questionAmount);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'timeTaken', timeTaken);
    RealmObjectBase.set(this, 'questionsCorrect', questionsCorrect);
    RealmObjectBase.set(this, 'highscore', highscore);
  }

  Level._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => throw RealmUnsupportedSetError();

  @override
  int get questionAmount =>
      RealmObjectBase.get<int>(this, 'questionAmount') as int;
  @override
  set questionAmount(int value) =>
      RealmObjectBase.set(this, 'questionAmount', value);

  @override
  bool get status => RealmObjectBase.get<bool>(this, 'status') as bool;
  @override
  set status(bool value) => RealmObjectBase.set(this, 'status', value);

  @override
  double get timeTaken =>
      RealmObjectBase.get<double>(this, 'timeTaken') as double;
  @override
  set timeTaken(double value) => RealmObjectBase.set(this, 'timeTaken', value);

  @override
  int get questionsCorrect =>
      RealmObjectBase.get<int>(this, 'questionsCorrect') as int;
  @override
  set questionsCorrect(int value) =>
      RealmObjectBase.set(this, 'questionsCorrect', value);

  @override
  int get highscore => RealmObjectBase.get<int>(this, 'highscore') as int;
  @override
  set highscore(int value) => RealmObjectBase.set(this, 'highscore', value);

  @override
  Stream<RealmObjectChanges<Level>> get changes =>
      RealmObjectBase.getChanges<Level>(this);

  @override
  Level freeze() => RealmObjectBase.freezeObject<Level>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Level._);
    return const SchemaObject(ObjectType.realmObject, Level, 'Level', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('questionAmount', RealmPropertyType.int),
      SchemaProperty('status', RealmPropertyType.bool),
      SchemaProperty('timeTaken', RealmPropertyType.double),
      SchemaProperty('questionsCorrect', RealmPropertyType.int),
      SchemaProperty('highscore', RealmPropertyType.int),
    ]);
  }
}
