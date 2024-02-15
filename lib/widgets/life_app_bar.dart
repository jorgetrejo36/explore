import 'package:explore/screens/game_result_screen.dart';
import 'package:explore/screens/game_screen.dart';
import 'package:explore/widgets/item_counter.dart';
import 'package:flutter/material.dart';

class LifeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LifeAppBar({
    Key? key,
    this.title = "",
    this.leading,
    this.titleWidget,
    this.showItemCounter = true,
    required this.counter,
    required this.item,
  }) : super(key: key);

  final String title;
  final Widget? leading;
  final Widget? titleWidget;
  final bool showItemCounter;
  final int counter;
  final String item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25 / 2.5),
        child: Stack(children: [
          Positioned.fill(
              child: Center(
            child: titleWidget,
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showItemCounter)
                Transform.translate(
                  offset: const Offset(10, 0),
                  child: ItemCounterStateful(
                    counter: counter,
                    item: item,
                  ),
                )
            ],
          )
        ]),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(
        double.maxFinite,
        80,
      );
}
