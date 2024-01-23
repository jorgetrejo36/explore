import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemCounterStateful extends StatefulWidget {
  const ItemCounterStateful({
    Key? key,
    required this.counter,
  }) : super(key: key);

  final int counter;

  @override
  State<ItemCounterStateful> createState() => _ItemCounterStatefulState();
}

class _ItemCounterStatefulState extends State<ItemCounterStateful> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        children: [
          Text(
            '${widget.counter}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SvgPicture.asset(
            'assets/images/compass.svg',
            semanticsLabel: 'My SVG Image',
            height: 50,
            width: 50,
          )
        ],
      ),
    );
  }
}
