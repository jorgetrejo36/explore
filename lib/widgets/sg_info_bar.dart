import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SGInfoBar extends StatelessWidget {
  // Temporary; need to re-add state to this bar to send problem.
  static String problemText = "2 - 2";
  static int livesLeft = 3;
  static bool gameStarted = true;

  const SGInfoBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.transparent,
      child: Visibility(
        visible: gameStarted,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              problemText,
              style: TextStyle(
                color: Colors.black,
                fontSize: 96,
                fontWeight: FontWeight.bold,
                fontFamily: "Fredoka",
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(
                  width: 48,
                  height: 48,
                  child: Visibility(
                    visible: livesLeft >= 1,
                    child: SvgPicture.asset('assets/images/life.svg'),
                  ),
                ),

                // Spacer
                SizedBox(width: 10),

                SizedBox(
                  width: 48,
                  height: 48,
                  child: Visibility(
                    visible: livesLeft >= 2,
                    child: SvgPicture.asset('assets/images/life.svg'),
                  ),
                ),

                // Spacer
                SizedBox(width: 10),

                SizedBox(
                  width: 48,
                  height: 48,
                  child: Visibility(
                    visible: livesLeft >= 3,
                    child: SvgPicture.asset('assets/images/life.svg'),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
