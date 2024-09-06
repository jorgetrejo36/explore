// difficulty levels start at 1 and go up to (and including) 12
import 'dart:math';

const int maxDifficulty = 12;

class ProblemGenerator {
  late int _difficultyLevel = -1;
  late int _minDifficultyLevel = -1;
  late int _maxDifficultyLevel = -1;
  bool _restricted = false;

  // this map is used in case 2 and 3 below for getting max values in the ranges
  final Map<int, Function> levelMaxValues = {
    1: Level1().getMaxValue,
    2: Level2().getMaxValue,
    3: Level3().getMaxValue,
    4: Level4().getMaxValue,
    5: Level5().getMaxValue,
    6: Level6().getMaxValue,
    8: Level8().getMaxValue,
    9: Level9().getMaxValue,
    10: Level10().getMaxValue,
  };

  // this map is used in case 3 for getting min values in the ranges
  final Map<int, Function> levelMinValues = {
    1: Level1().getMinValue,
    2: Level2().getMinValue,
    3: Level3().getMinValue,
    4: Level4().getMinValue,
    5: Level5().getMinValue,
    6: Level6().getMinValue,
    8: Level8().getMinValue,
    9: Level9().getMinValue,
    10: Level10().getMinValue,
  };

  ProblemGenerator(this._difficultyLevel, this._restricted)
      : assert(
          _difficultyLevel >= 1 && _difficultyLevel <= maxDifficulty,
          'Value must be between 1 and $maxDifficulty, inclusive.',
        );

  ProblemGenerator.withRange(
    this._minDifficultyLevel,
    this._maxDifficultyLevel,
  ) : assert(
          _maxDifficultyLevel - _minDifficultyLevel >= 1,
          'Max must be greater than min and be seperated by a difference of at least 1',
        );

  GeneratedProblem generateProblem() {
    // there are three possible cases
    // 1. Only a single restricted difficulty level
    //    Ex: Only level 2 problems
    // 2. Max difficulty level range
    //    Ex: Problems from level [1, difficultyLevel]
    // 3. Range of levels
    //    Ex: Problems from level [minDifficultyLevel, maxDifficultyLevel]

    // case 1
    if (_difficultyLevel != -1 && _restricted) {
      switch (_difficultyLevel) {
        case 1:
          return Level1().getProblem();
        case 2:
          return Level2().getProblem();
        case 3:
          return Level3().getProblem();
        case 4:
          return Level4().getProblem();
        case 5:
          return Level5().getProblem();
        case 6:
          return Level6().getProblem();
        case 7:
          return Level7().getProblem();
        case 8:
          return Level8().getProblem();
        case 9:
          return Level9().getProblem();
        case 10:
          return Level10().getProblem();
      }
      // case 2
    } else if (_difficultyLevel != -1) {
      // to produce an equal ditribution of the level of problem given out
      // the 2nd parameter for the LevelRange() constructor will be a random
      // level between 1 and _difficulty level
      //
      // If this were not done there would be a bias towards harder levels since
      // the harder levels have a wider range of values
      //
      // NOTE: Level 7 is distinct from all other levels and is when the switch
      // is made from addition/subtraction to multiplication. Levels 8-10 are
      // then all multiplication and division so some of this is hardcoded to
      // match what the problem generator currently looks like

      // only addition/subtraction
      if (_difficultyLevel < 7) {
        int randomLevel = Random().nextInt(_difficultyLevel) + 1;
        return LevelRange(
          Level1().getMinValue(),
          levelMaxValues[randomLevel]!(),
        ).getProblem();
      } else if (_difficultyLevel == 7) {
        // When a max difficulty level  that involves multiplication/division is
        // given we want it to be an even split between addition/subtraction
        // problems and multiplication/divisions problems
        // 0 = addiiton/subtraction, 1 = multiplication/division
        int addOrMult = Random().nextInt(2);

        switch (addOrMult) {
          case 0:
            // random level btwen 1 to 6
            int randomLevel = Random().nextInt(6) + 1;
            return LevelRange(
              Level1().getMinValue(),
              levelMaxValues[randomLevel]!(),
            ).getProblem();
          case 1:
            return Level7().getProblem();
        }
        // _difficultyLevel > 7
      } else {
        // When a max difficulty level  that involves multiplication/division is
        // given we want it to be an even split between addition/subtraction
        // problems and multiplication/divisions problems
        // 0 = addiiton/subtraction, 1 = multiplication/division
        int addOrMult = Random().nextInt(2);

        switch (addOrMult) {
          case 0:
            // random level btwen 1 to 6
            int randomLevel = Random().nextInt(6) + 1;
            return LevelRange(
              Level1().getMinValue(),
              levelMaxValues[randomLevel]!(),
            ).getProblem();
          case 1:
            {
              // random number from 7 to 10
              int randomLevel = 7 + Random().nextInt(10 - 7 + 1);

              switch (randomLevel) {
                case 7:
                  return Level7().getProblem();
                default:
                  return LevelRange(
                    Level8().getMinValue(),
                    levelMaxValues[randomLevel]!(),
                  ).getMultiplicationDivisionProblem();
              }
            }
        }
      }

      // case 3
    } else {
      // to produce an equal ditribution of the level of problem given out
      // the 2nd parameter for the LevelRange() constructor will be a random
      // level between _minDifficultyLevel and _maxDifficultyLevel
      //
      // If this were not done there would be a bias towards harder levels since
      // the harder levels have a wider range of values

      if (_maxDifficultyLevel < 7) {
        int randomLevel =
            Random().nextInt(_maxDifficultyLevel - _minDifficultyLevel + 1) +
                _minDifficultyLevel;

        return LevelRange(
          levelMinValues[_minDifficultyLevel]!(),
          levelMaxValues[randomLevel]!(),
        ).getProblem();
      } else if (_maxDifficultyLevel == 7) {
        // If the maxDifficultyLevel includes multiplication problems we want
        // it to be an even split of addition/subtraction problems and
        // multiplication/division problems
        // 0 = addiiton/subtraction, 1 = multiplication/division
        int addOrMult = Random().nextInt(2);

        switch (addOrMult) {
          case 0:
            // cap the max difficulty level at the highest add/sub level
            int newMaxDifficultyLevel = 6;
            int randomLevel = Random()
                    .nextInt(newMaxDifficultyLevel - _minDifficultyLevel + 1) +
                _minDifficultyLevel;

            return LevelRange(
              levelMinValues[_minDifficultyLevel]!(),
              levelMaxValues[randomLevel]!(),
            ).getProblem();
          case 1:
            return Level7().getProblem();
        }
        // maxDifficultyLevel > 7 (it is 8 or greater)
      } else {
        if (_minDifficultyLevel <= 6) {
          // minDifficultyLevel
          // 0 = addiiton/subtraction, 1 = multiplication/division
          int addOrMult = Random().nextInt(2);

          switch (addOrMult) {
            case 0:
              // cap the max difficulty level at the highest add/sub level
              int newMaxDifficultyLevel = 6;
              int randomLevel = Random().nextInt(
                    newMaxDifficultyLevel - _minDifficultyLevel + 1,
                  ) +
                  _minDifficultyLevel;

              return LevelRange(
                levelMinValues[_minDifficultyLevel]!(),
                levelMaxValues[randomLevel]!(),
              ).getProblem();
            case 1:
              int randomNumber = Random()
                      .nextInt(_maxDifficultyLevel - _minDifficultyLevel + 1) +
                  _minDifficultyLevel;

              // only in this case will a level 7 problem be made
              if (randomNumber == 7) {
                return Level7().getProblem();
              } else {
                return LevelRange(
                  0,
                  levelMaxValues[randomNumber]!(),
                ).getMultiplicationDivisionProblem();
              }
          }
        } else if (_minDifficultyLevel == 7) {
          // Level 7 is a diff type of multiplication problem as opposed to the
          // others. This level is produced differently and needs to be taken
          // into account for that
          int randomNumber =
              Random().nextInt(_maxDifficultyLevel - _minDifficultyLevel + 1) +
                  _minDifficultyLevel;

          // only in this case will a level 7 problem be made
          if (randomNumber == 7) {
            return Level7().getProblem();
          } else {
            return LevelRange(
              0,
              levelMaxValues[randomNumber]!(),
            ).getMultiplicationDivisionProblem();
          }
          // minDifficultyLevel >= 8
        } else {
          int randomNumber =
              Random().nextInt(_maxDifficultyLevel - _minDifficultyLevel + 1) +
                  _minDifficultyLevel;

          return LevelRange(
            levelMinValues[_minDifficultyLevel]!(),
            levelMaxValues[randomNumber]!(),
          ).getMultiplicationDivisionProblem();
        }
      }
    }

    // This is returned to prevent any errors in this method
    return Level1().getProblem();
  }
}

abstract class Level {
  GeneratedProblem getProblem();

  // This is for levels 8 - 10
  GeneratedProblem getProblemForMultiplicationDivison(
    int minValue,
    int maxValue,
  ) {
    // choose a random operator between multiplication and division
    final operator = Random().nextInt(2) == 0 ? "*" : "/";
    late int operand1;
    late int operand2;
    late int answer;

    switch (operator) {
      case "*":
        // Generate a random number between min to max, two times
        operand1 = minValue + Random().nextInt(maxValue - minValue + 1);
        operand2 = minValue + Random().nextInt(maxValue - minValue + 1);
        answer = operand1 * operand2;
        break;
      case "/":
        // Generate a random number from min - max^2
        // operand1 will always need to be between this range
        operand1 = minValue + Random().nextInt(maxValue * maxValue + 1);
        // This second number MUST be a divisor of the first number and be less
        // than or equal to max
        final List<int> divisors = getDivisors(operand1, maxValue);
        // It gets a random divisor from the list
        operand2 = divisors[Random().nextInt(divisors.length)];

        // ~/ is just used to prevent errors but given the above logic the
        // answer should never have a remainder
        answer = operand1 ~/ operand2;
        break;
    }

    AnswerChoices answerChoices = AnswerChoices(answer, minValue, maxValue);
    Problem problem = Problem(operand1, operator, operand2);
    return GeneratedProblem(answerChoices: answerChoices, problem: problem);
  }

  // this is for only addition and subtraction
  GeneratedProblem getProblemForLevel(int minValue, int maxValue) {
    // choose a random operator from the const operators
    String operator = Random().nextInt(2) == 0 ? "+" : "-";

    switch (operator) {
      // addition
      case '+':
        return getAdditionProblem(minValue, maxValue);
      // subtraction
      case '-':
        return getSubtractionProblem(minValue, maxValue);
    }

    throw Exception("This will never happen");
  }

  GeneratedProblem getAdditionProblem(int minValue, int maxValue) {
    // choose value from [minValue, maxValue]
    int operand1 = minValue + Random().nextInt(maxValue - minValue + 1);
    // choose value from [0, maxValue - operand1 + 1]
    int operand2 = Random().nextInt(maxValue - operand1 + 1);
    int sum = operand1 + operand2;

    Problem problem = Problem(operand1, '+', operand2);
    AnswerChoices answerChoices = AnswerChoices(sum, minValue, maxValue);

    return GeneratedProblem(
      answerChoices: answerChoices,
      problem: problem,
    );
  }

  GeneratedProblem getSubtractionProblem(int minValue, int maxValue) {
    // choose value from [minValue, maxValue] for both
    int operand1 = minValue + Random().nextInt(maxValue - minValue + 1);
    int operand2 = minValue + Random().nextInt(maxValue - minValue + 1);

    int difference;
    Problem problem;

    // order matters with subtraction so this ensures the greater operand
    // is put first
    if (operand1 > operand2) {
      difference = operand1 - operand2;
      problem = Problem(operand1, '-', operand2);
    } else {
      // if the operands are the same the difference is always 0 and the
      // order of operands do not matter
      difference = operand2 > operand1 ? operand2 - operand1 : 0;
      problem = Problem(operand2, '-', operand1);
    }

    AnswerChoices answerChoices = AnswerChoices(difference, minValue, maxValue);

    return GeneratedProblem(
      answerChoices: answerChoices,
      problem: problem,
    );
  }

  // will return divisors that are less than or equal to max
  List<int> getDivisors(int number, int max) {
    // if the number is 0 will return any number between 1 to max
    if (number == 0) {
      return [Random().nextInt(max) + 1];
    } else {
      List<int> divisors = [];

      for (int i = 1; i <= number; i++) {
        if (number % i == 0 && i <= max) {
          divisors.add(i);
        }
      }

      return divisors;
    }
  }
}

class LevelRange extends Level {
  final int _minValue;
  final int _maxValue;

  LevelRange(this._minValue, this._maxValue);

  // this is for addition and subtraction only
  @override
  GeneratedProblem getProblem() {
    return super.getProblemForLevel(_minValue, _maxValue);
  }

  GeneratedProblem getMultiplicationDivisionProblem() {
    return super.getProblemForMultiplicationDivison(_minValue, _maxValue);
  }
}

// There are classes for each level in case there is further development later
// on that wants to change more specific things between the levels

// Addition and subtraction with sums and operands, respectively, between 0 to
// 5, inclusive.
//  Ex: 0 + 3 = 3
class Level1 extends Level {
  static const int _minValue = 0;
  static const int _maxValue = 5;

  Level1();

  @override
  GeneratedProblem getProblem() {
    return super.getProblemForLevel(_minValue, _maxValue);
  }

  int getMinValue() {
    return _minValue;
  }

  int getMaxValue() {
    return _maxValue;
  }
}

// Addition and subtraction with sums and operands, respectively, between 6 to
// 10, inclusive.
//  Ex: 8 - 2 = 6
class Level2 extends Level {
  static const int _minValue = 6;
  static const int _maxValue = 10;

  Level2();

  @override
  GeneratedProblem getProblem() {
    return super.getProblemForLevel(_minValue, _maxValue);
  }

  int getMinValue() {
    return _minValue;
  }

  int getMaxValue() {
    return _maxValue;
  }
}

// Addition and subtraction with sums and operands, respectively, between 11 to
// 15, inclusive.
//  Ex: 10 + 2 = 12
class Level3 extends Level {
  static const int _minValue = 11;
  static const int _maxValue = 15;

  Level3();

  @override
  GeneratedProblem getProblem() {
    return super.getProblemForLevel(_minValue, _maxValue);
  }

  int getMinValue() {
    return _minValue;
  }

  int getMaxValue() {
    return _maxValue;
  }
}

// Addition and subtraction with sums and operands, respectively, between 16 to
// 20, inclusive.
//  Ex: 20 - 3 = 17
class Level4 extends Level {
  static const int _minValue = 16;
  static const int _maxValue = 20;

  Level4();

  @override
  GeneratedProblem getProblem() {
    return super.getProblemForLevel(_minValue, _maxValue);
  }

  int getMinValue() {
    return _minValue;
  }

  int getMaxValue() {
    return _maxValue;
  }
}

// Addition and subtraction with sums and operands, respectively, between 21 to 60, inclusive.
//  Ex: 15 + 32 = 47
class Level5 extends Level {
  static const int _minValue = 21;
  static const int _maxValue = 60;

  Level5();

  @override
  GeneratedProblem getProblem() {
    return super.getProblemForLevel(_minValue, _maxValue);
  }

  int getMinValue() {
    return _minValue;
  }

  int getMaxValue() {
    return _maxValue;
  }
}

// Addition and subtraction with sums and operands, respectively, between 61 to
// 100, inclusive.
//  Ex: 100 - 33 = 77
class Level6 extends Level {
  static const int _minValue = 61;
  static const int _maxValue = 100;

  Level6();

  @override
  GeneratedProblem getProblem() {
    return super.getProblemForLevel(_minValue, _maxValue);
  }

  int getMinValue() {
    return _minValue;
  }

  int getMaxValue() {
    return _maxValue;
  }
}

// Multiply one-digit whole numbers by multiples of 10 (up to 90) or multiples
// of 100 (up to 900).
//  Ex: 4 * 10 = 40 or 8 * 100 = 800
class Level7 extends Level {
  Level7();

  @override
  GeneratedProblem getProblem() {
    // Generate a random number from 0-9
    final int operand1 = Random().nextInt(10);
    // Get a random value that is 0, 10, or 100
    List<int> numbers = [0, 10, 100];
    final int operand2 = numbers[Random().nextInt(numbers.length)];

    final int answer = operand1 * operand2;

    // list of multiples of 10 (up to 90) and multiples of 100 (up to 900) w/ 0
    final List<int> multiples = [
      0,
      ...List.generate(9, (index) => (index + 1) * 10),
      ...List.generate(9, (index) => (index + 1) * 100),
    ];

    AnswerChoices answerChoices = AnswerChoices.unique(answer, multiples);
    Problem problem = Problem(operand1, "*", operand2);
    return GeneratedProblem(answerChoices: answerChoices, problem: problem);
  }
}

// Multiply and divide whole numbers from 0 to 4, inclusive.
//  Ex: 4 * 10 = 40 or 8 * 100 = 800
class Level8 extends Level {
  static const int _min = 0;
  static const int _max = 4;

  Level8();

  @override
  GeneratedProblem getProblem() {
    return super.getProblemForMultiplicationDivison(_min, _max);
  }

  int getMinValue() {
    return _min;
  }

  int getMaxValue() {
    return _max;
  }
}

// Multiply and divide whole numbers from 5 to 8, inclusive.
//  Ex: 5 * 8 = 40 or 28 / 4 = 7
class Level9 extends Level {
  static const int _min = 5;
  static const int _max = 8;

  Level9();

  @override
  GeneratedProblem getProblem() {
    return super.getProblemForMultiplicationDivison(_min, _max);
  }

  int getMinValue() {
    return _min;
  }

  int getMaxValue() {
    return _max;
  }
}

// Multiply and divide whole numbers from 9 to 12, inclusive.
//  Ex: 10 * 11 = 110 or 90 / 9 = 10
class Level10 extends Level {
  static const int _min = 9;
  static const int _max = 12;

  Level10();

  @override
  GeneratedProblem getProblem() {
    return super.getProblemForMultiplicationDivison(_min, _max);
  }

  int getMinValue() {
    return _min;
  }

  int getMaxValue() {
    return _max;
  }
}

class GeneratedProblem {
  final AnswerChoices answerChoices;
  final Problem problem;

  GeneratedProblem({required this.answerChoices, required this.problem});

  @override
  String toString() {
    return '$answerChoices\n'
        'Problem: $problem = ${answerChoices.getAnswers()[0]}';
  }
}

class AnswerChoices {
  int _minValue = -1;
  int _maxValue = -1;
  final int _correctAnswer;
  // array order: [correct_answer, wrong_answer1, wrong_answer2]
  final List<int> _answers = [];

  // this will generate the answer choices
  AnswerChoices(
    this._correctAnswer,
    this._minValue,
    this._maxValue,
  ) {
    List<int> possibleAnswerChoices = List.generate(
      _maxValue - _minValue + 1,
      (index) => _minValue + index,
    ) // Generates numbers from minValue to maxValue
        .toList(); // Converts the iterable to a list

    possibleAnswerChoices.remove(_correctAnswer);

    possibleAnswerChoices.shuffle();

    _answers.addAll(
      [_correctAnswer, possibleAnswerChoices[0], possibleAnswerChoices[1]],
    );
  }

  // this constructor is whenever there is a unique level that is not constructed
  // in the typical way that just needs a min and max.
  // With this constructor the user will generate the list of possible answers
  // and then pass that into here and the rest of the logic is handled within
  // this method
  AnswerChoices.unique(this._correctAnswer, List<int> possibleAnswers) {
    possibleAnswers.remove(_correctAnswer);

    possibleAnswers.shuffle();

    _answers.addAll([_correctAnswer, possibleAnswers[0], possibleAnswers[1]]);
  }

  /// List order: [correct_answer, wrong_answer_1, wrong_answer_2]
  List<int> getAnswers() {
    return _answers;
  }

  @override
  String toString() {
    return 'Answer Choices: $_answers';
  }
}

class Problem {
  final int _x;
  final String _operator;
  final int _y;
  late String _problemString;

  Problem(
    this._x,
    this._operator,
    this._y,
  ) {
    _problemString = '$_x $_operator $_y';
  }

  String getProblemString() {
    return _problemString;
  }

  String getOperator() {
    return _operator;
  }

  @override
  String toString() {
    return 'Problem: $_problemString';
  }
}
