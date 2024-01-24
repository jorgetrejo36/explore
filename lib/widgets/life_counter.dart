import 'package:flutter/material.dart';

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
              child: Image.network(
                  'https://cdn-icons-png.flaticon.com/256/3599/3599696.png'),
            )
        ],
      ),
    );
  }
}
