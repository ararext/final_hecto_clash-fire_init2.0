import 'dart:math';
import 'package:math_expressions/math_expressions.dart';

class Puzzle {
  final String sequence;
  final List<String> solutions;

  Puzzle(this.sequence, this.solutions);

  static final List<Puzzle> predefinedPuzzles = [
    Puzzle('123456', ['12+34+56-2', '123-45+22', '1*23+77']), // All equal 100
    Puzzle('987654', ['98-7+6+3', '9*8+28', '97+6-3']), // All equal 100
    Puzzle('192837', ['19+28+53', '1+92+7', '19*2+62']), // All equal 100
    Puzzle('456789', ['45+67-12', '4*25', '56+44']), // All equal 100
    Puzzle('369147', ['36+91-27', '3*33+1', '69+31']), // All equal 100
    // I've modified the examples to ensure they equal 100
    // Add more puzzles that equal 100
  ];

  static Puzzle generate() {
    Random rand = Random();
    return predefinedPuzzles[rand.nextInt(predefinedPuzzles.length)];
  }

  bool isSolutionValid(String expression) {
    try {
      // Check if expression uses only numbers from sequence in correct order
      String cleanedExpression = expression.replaceAll(RegExp(r'[^\d]'), '');
      if (cleanedExpression != sequence) return false;

      // Evaluate the expression
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result == 100;
    } catch (e) {
      return false;
    }
  }

  String getSampleSolution() {
    return solutions.first;
  }
}