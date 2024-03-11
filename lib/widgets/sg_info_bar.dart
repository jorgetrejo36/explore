import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SGInfoBar extends StatefulWidget {

  // Duplicates of the variables from the shooting game main screen, so we
  // can assign and update the information here visually.
  final bool gameStarted;
  final int livesLeft;
  final String problemText;

  const SGInfoBar({Key? key,
    required this.gameStarted,
    required this.livesLeft,
    required this.problemText,}) : super(key: key);

  @override
  State<SGInfoBar> createState() => _SGInfoBarState();
}

class _SGInfoBarState extends State<SGInfoBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.transparent,
      child: Visibility(
        visible: widget.gameStarted,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              widget.problemText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 96,
                fontWeight: FontWeight.bold,
                fontFamily: "Fredoka",
                shadows: [
                  // Black outline around white text.
                  // In order, the shadows display on the:
                  // bottomLeft, bottomRight, topRight, topLeft.
                  Shadow(
                    offset: Offset(-3, -3),
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(3, -3),
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(3, 3),
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(-3, 3),
                    color: Colors.black,
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(
                  width: 48,
                  height: 48,
                  child: Visibility(
                    visible: widget.livesLeft >= 1,
                    child: SvgPicture.asset('assets/images/life.svg'),
                  ),
                ),

                // Spacer between hearts.
                const SizedBox(width: 10),

                SizedBox(
                  width: 48,
                  height: 48,
                  child: Visibility(
                    visible: widget.livesLeft >= 2,
                    child: SvgPicture.asset('assets/images/life.svg'),
                  ),
                ),

                // Spacer between hearts.
                const SizedBox(width: 10),

                SizedBox(
                  width: 48,
                  height: 48,
                  child: Visibility(
                    visible: widget.livesLeft >= 3,
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
