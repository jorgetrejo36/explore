// difficulty levels start at 1 and go up to (and including) 12
import 'dart:math';

const int maxDifficulty = 12;
// const Map<int, Function> methodMap = {
//   1: Level1().getMaxValue(),
//   2: method2,
//   3: method3,
// };

class ProblemGenerator {
  int _difficultyLevel = -1;
  int _minDifficultyLevel = -1;
  int _maxDifficultyLevel = -1;
  bool _restricted = false;

  ProblemGenerator(this._difficultyLevel, this._restricted)
      : assert(
          _difficultyLevel >= 1 && _difficultyLevel <= maxDifficulty,
          'Value must be between 1 and $_difficultyLevel, inclusive.',
        );

  ProblemGenerator.withRange(
    this._minDifficultyLevel,
    this._maxDifficultyLevel,
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
      }
      // case 2
    } else if (_difficultyLevel != -1) {
      //return LevelRange(Level1().getMinValue(), ).getProblem();
    } else {}

    return Level1().getProblem();
  }
}

abstract class Level {
  GeneratedProblem getProblem();

  GeneratedProblem getProblemForLevel(int minValue, int maxValue) {
    String operator = Random().nextInt(2) == 0 ? '+' : '-';

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
}

class LevelRange extends Level {
  final int _minValue;
  final int _maxValue;

  LevelRange(this._minValue, this._maxValue);

  @override
  GeneratedProblem getProblem() {
    return super.getProblemForLevel(_minValue, _maxValue);
  }
}

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
  final int _minValue;
  final int _maxValue;
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

  @override
  String toString() {
    return 'Problem: $_problemString';
  }
}
