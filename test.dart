import 'package:flutter_test/flutter_test.dart';
import 'package:explore/utils/problem_generator.dart';

void main() {
  group('ProblemGenerator', () {
    test('generateProblem returns a valid problem', () {
      ProblemGenerator generator = ProblemGenerator(5, false);
      GeneratedProblem problem = generator.generateProblem();
      expect(problem, isNotNull);
      expect(problem.problem.getProblemString(), isNotNull);
      print('Sample Problem: $problem');
    });

    test('generateProblem returns a valid problem with restricted difficulty', () {
      ProblemGenerator generator = ProblemGenerator(3, true);
      GeneratedProblem problem = generator.generateProblem();
      expect(problem, isNotNull);
      expect(problem.problem.getProblemString(), isNotNull);
      print('Sample Problem: $problem');
    });

    test('generateProblem returns a valid problem with range', () {
      ProblemGenerator generator = ProblemGenerator.withRange(6, 10);
      GeneratedProblem problem = generator.generateProblem();
      expect(problem, isNotNull);
      expect(problem.problem.getProblemString(), isNotNull);
      print('Sample Problem: $problem');
    });

    test('generateProblem statistics for a large sample', () {
      ProblemGenerator generator = ProblemGenerator(5, false);
      final int sampleSize = 10000;
      int validProblemsCount = 0;

      for (int i = 0; i < sampleSize; i++) {
        GeneratedProblem problem = generator.generateProblem();
        if (problem != null && problem.problem.getProblemString() != null) {
          validProblemsCount++;
        }
      }

      double percentage = (validProblemsCount / sampleSize) * 100;
      print('Valid Problems Generated: $validProblemsCount');
      print('Total Sample Size: $sampleSize');
      print('Percentage of Valid Problems: $percentage%');
    });
  });
}
