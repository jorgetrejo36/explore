import 'package:explore/widgets/geyser_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget(
      {super.key,
      required this.gameWidget,
      required this.correctAnswers,
      required this.questions,
      });

  final Widget gameWidget;
  final int correctAnswers;
  final int questions;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Center(
              child: Text(
            '$correctAnswers / $questions',
            style: TextStyle(
              fontFamily: 'Fredoka',
            ),
          )),
          actions: <Widget>[
            Center(
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/images/reload.svg',
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  semanticsLabel: "arrow pointing in circle",
                  height: 50,
                  width: 50,
                ),
                // Navigate back when the back button is pressed
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => gameWidget,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      child: const Text('Retry'),
    );
  }
}
