import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GeyserChoice extends StatelessWidget {
  const GeyserChoice({
    Key? key,
    required this.handleState,
    required this.choice,
    required this.answer,
    required this.correctAnswer,
    required this.answeredQuestion,
    required this.item,
    required this.top,
  }) : super(key: key);

  final Function(int) handleState;
  final int choice;
  final int answer;
  final int correctAnswer;
  final bool answeredQuestion;
  final String item;
  final String top;

  Widget _buildChoiceButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          handleState(choice);
        },
        style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontFamily: 'Fredoka', fontSize: 40)),
        child: Text("$choice"),
      ),
    );
  }

  Widget _buildAlienSvg() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SvgPicture.asset(
        'assets/images/alien.svg',
        width: double.infinity,
        height: 150,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildSmokeSvg() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SvgPicture.asset(
        top,
        width: double.infinity,
        height: 250,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildItemSvg() {
    return Align(
      alignment: Alignment.center,
      child: SvgPicture.asset(
        item,
        width: double.infinity,
        height: 75,
        fit: BoxFit.fill,
      ),
    );
  }

  List<Widget> correctWidget() {
    if (!answeredQuestion) {
      return choice == answer
          ? [_buildChoiceButton(), _buildAlienSvg()]
          : [_buildChoiceButton()];
    }

    if (correctAnswer != answer) {
      if (choice != correctAnswer) {
        return choice == answer
            ? [
                Container(
                  width: double.infinity,
                  height: 250,
                  child: Stack(
                    children: [
                      Positioned.fill(child: _buildSmokeSvg()),
                      Positioned.fill(child: _buildAlienSvg()),
                    ],
                  ),
                ),
              ]
            : [_buildSmokeSvg()];
      } else {
        return [_buildItemSvg()];
      }
    }

    return choice == answer
        ? [_buildItemSvg(), _buildAlienSvg()]
        : [_buildSmokeSvg()];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: correctWidget()),
    );
  }
}
