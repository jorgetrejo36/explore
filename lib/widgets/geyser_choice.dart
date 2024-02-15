import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GeyserChoice extends StatelessWidget {
  const GeyserChoice({
    Key? key,
    required this.handleState(dynamic),
    required this.choice,
    required this.answer,
    required this.correctAnswer,
    required this.answeredQuestion,
  }) : super(key: key);

  final Function(int) handleState;
  final int choice;
  final int answer;
  final int correctAnswer;
  final bool answeredQuestion;

  List<Widget> correctWidget() {
    if (!answeredQuestion) {
      if (choice == answer) {
        return ([
          Center(
            child: TextButton(
              onPressed: () {
                handleState(choice);
              },
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontFamily: 'Fredoka', fontSize: 40)),
              child: Text("$choice"),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: SvgPicture.asset(
              'assets/images/alien.svg',
              width: double.infinity,
              height: 150,
              fit: BoxFit.fill,
            ),
          ),
        ]);
      } else {
        return [
          Center(
            child: TextButton(
              onPressed: () {
                handleState(choice);
              },
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontFamily: 'Fredoka', fontSize: 40)),
              child: Text("$choice"),
            ),
          ),
        ];
      }
    } else {
      // User picked wrong answer
      if (correctAnswer != answer) {
        // User doesn't match correct answer
        if (choice != correctAnswer) {
          return ([
            // User is on the one they chose, alien svg pops up
            // Smoke is default
            if (choice == answer)
              Align(
                alignment: Alignment.bottomLeft,
                child: SvgPicture.asset(
                  'assets/images/alien.svg',
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(
                'assets/images/smoke.svg',
                width: double.infinity,
                height: 250,
                fit: BoxFit.fill,
              ),
            ),
          ]);
        } else {
          return ([
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/ruby.svg',
                width: double.infinity,
                height: 75,
                fit: BoxFit.fill,
              ),
            ),
          ]);
        }
        // User picks correctly
      } else {
        // If alien is on the correct answer, add alien svg
        if (choice == answer) {
          return ([
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/ruby.svg',
                width: double.infinity,
                height: 75,
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(
                'assets/images/alien.svg',
                width: double.infinity,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
          ]);
        }
        // If alien is not on correct answer, fill space with smoke
        else {
          return ([
            Align(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(
                'assets/images/smoke.svg',
                width: double.infinity,
                height: 250,
                fit: BoxFit.fill,
              ),
            ),
          ]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: correctWidget()),
    );
  }
}
