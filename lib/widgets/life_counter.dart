import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LifeCounterStateful extends StatefulWidget {
  const LifeCounterStateful({super.key, required this.lives});

  final int lives;
  @override
  State<LifeCounterStateful> createState() {
    State<LifeCounterStateful> stateClassAssociatedWithThisWidget =
        _LifeCounterStatefulState();
    return stateClassAssociatedWithThisWidget;
  }
}

class _LifeCounterStatefulState extends State<LifeCounterStateful> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int life = 0; life < widget.lives; life++)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: SvgPicture.asset(
                'assets/images/life.svg',
                semanticsLabel: 'heart',
                height: 50,
                width: 50,
              ),
            )
        ],
      ),
    );
  }
}
