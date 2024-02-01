import 'dart:math';

import 'package:explore/widgets/mining_themes.dart';
import 'package:flutter/material.dart';
import 'package:explore/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:explore/widgets/mining_themes.dart';

class MiningGame extends StatefulWidget {
  final String planet;
  const MiningGame({super.key, required this.planet});

  @override
  State<MiningGame> createState() => _MiningGameState();
}

class _MiningGameState extends State<MiningGame> {
  // Theme Variables
  late MiningTheme theme = MiningTheme(widget.planet);

  // Problem Variables
  int term1 = 0;
  int term2 = 0;
  String operator = "";
  int solution = 0;

  // Player variables
  int score = 0;
  bool correct = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xfff6f6f6),
            size: 35,
          ),
          // Navigate back when the back button is pressed
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/${theme.background}.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.055,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Text(
                    "5 + 5",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Fredoka',
                        fontSize: 102),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.635,
                  //decoration: BoxDecoration(color: Colors.blue),
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.155,
                  ),
                  child: Column(
                    children: [
                      MiningRow(theme: this.theme),
                      MiningRow(theme: this.theme),
                      MiningRow(theme: this.theme),
                      MiningRow(theme: this.theme),
                      MiningRow(theme: this.theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MiningRow extends StatefulWidget {
  final MiningTheme theme;
  const MiningRow({super.key, required this.theme});

  @override
  State<MiningRow> createState() => _MiningRowState();
}

class _MiningRowState extends State<MiningRow> {
  late RowData row = RowData(widget.theme, ["1", "2", "3"], "3");

  void selectAnswer(int rowNumber) {
    setState(() {
      row.rowImages[rowNumber] = row.currentTheme.miningCurrency;
      row.rowRotation[rowNumber] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              selectAnswer(0);
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Transform.rotate(
                angle: row.rowRotation[0],
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: SvgPicture.asset(
                    'assets/images/${row.rowImages[0]}.svg',
                    height: 80,
                    width: 25,
                    semanticsLabel: "bubble",
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              selectAnswer(1);
            },
            child: Container(
              child: Transform.rotate(
                angle: row.rowRotation[1],
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: SvgPicture.asset(
                    'assets/images/${row.rowImages[1]}.svg',
                    height: 80,
                    width: 25,
                    semanticsLabel: "bubble",
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              selectAnswer(2);
            },
            child: Container(
              margin: EdgeInsets.only(top: 25),
              child: Transform.rotate(
                angle: row.rowRotation[2],
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: SvgPicture.asset(
                    'assets/images/${row.rowImages[2]}.svg',
                    height: 80,
                    width: 25,
                    semanticsLabel: "bubble",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Manages image and answer choices of row
class RowData {
  static double randomSeed = Random().nextDouble() * 360;
  List<double> rowRotation = [
    0 + randomSeed,
    90 + randomSeed,
    180 + randomSeed
  ];
  late String reward;
  late String solution;
  late List<String> rowImages;
  late List<String> rowChoices;
  late MiningTheme currentTheme;

  RowData(theme, choices, answer) {
    currentTheme = theme;
    rowImages = [
      "${currentTheme.miningSurface}",
      "${currentTheme.miningSurface}",
      "${currentTheme.miningSurface}"
    ];
    rowChoices = choices;
    reward = "${currentTheme.miningCurrency}";
    solution = answer;
  }
}