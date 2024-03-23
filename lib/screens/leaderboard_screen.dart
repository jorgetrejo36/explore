import 'package:flutter/material.dart';
import 'package:explore/app_colors.dart';
import 'package:explore/utils/realm_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:explore/widgets/sound_library.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late List<PlayerData> users;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      users = RealmUtils().getLeaderboardUsers();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

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
            onPressed: () => {
                  playClick(),
                  Navigator.pop(context),
                }),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/StarsBackground.png"),
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
                  height: MediaQuery.of(context).size.height * 0.22,
                  // Start of TopPlayer widget
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (users.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.075,
                          ),
                          child: TopPlayer(
                            outlineColor: Color.fromARGB(255, 201, 201, 201),
                            name: users[0].name,
                            backgroundColor: Color(0xffa149f0),
                            imgName: users[0].imgName,
                          ),
                        ),
                      if (users.length > 1)
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: TopPlayer(
                            outlineColor: Color(0xFFECBC14),
                            name: users[1].name,
                            backgroundColor: Color(0xffa149f0),
                            imgName: users[1].imgName,
                          ),
                        ),
                      if (users.length > 2)
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.09,
                          ),
                          child: TopPlayer(
                            outlineColor: Color.fromARGB(255, 197, 98, 12),
                            name: users[2].name,
                            backgroundColor: Color(0xffa149f0),
                            imgName: users[2].imgName,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.66,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.0225,
                  ),
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final player = users[index];
                      return ScoreBar(
                        barColor: Color(0xffa149f0),
                        imgName: player.imgName,
                        name: player.name,
                        score: player.score,
                      );
                    },
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

class TopPlayer extends StatelessWidget {
  final Color outlineColor;
  final Color backgroundColor;
  final String name;
  final String imgName;
  const TopPlayer({
    Key? key,
    required this.outlineColor,
    required this.backgroundColor,
    required this.imgName,
    required this.name,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      height: 140,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: outlineColor,
                width: 4,
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 1,
                  color: Color(0x33000000),
                  offset: Offset(0, 4),
                  spreadRadius: 3,
                )
              ],
            ),
            child: Align(
              alignment: AlignmentDirectional(0, 0),
              child: SvgPicture.asset(
                imgName,
                fit: BoxFit.contain,
                height: 75,
              ),
            ),
          ),
          Container(
              width: 115,
              height: 40,
              margin: EdgeInsetsDirectional.only(top: 70),
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 2,
                    color: Color(0x33000000),
                    offset: Offset(0, 3),
                    spreadRadius: 1,
                  )
                ],
                borderRadius: BorderRadius.circular(20),
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: outlineColor,
                  width: 4,
                ),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xfff6f6f6),
                  fontSize: 23,
                  fontFamily: 'Fredoka',
                ),
              )),
        ],
      ),
    );
  }
}

class ScoreBar extends StatelessWidget {
  final String name;
  final String score;
  final String imgName;
  final Color barColor;

  const ScoreBar({
    Key? key,
    required this.barColor,
    required this.imgName,
    required this.name,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.0125),
      decoration: BoxDecoration(color: barColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.18,
            child: SvgPicture.asset(imgName),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: const TextStyle(
                  color: Color(0xfff6f6f6),
                  fontSize: 46,
                  fontFamily: 'Fredoka',
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.20,
              height: MediaQuery.of(context).size.height * 0.055,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Color.fromARGB(100, 43, 43, 43)),
                  BoxShadow(
                    color: Color.alphaBlend(
                        Color.fromARGB(69, 154, 154, 154), barColor),
                    spreadRadius: -2,
                    blurRadius: 1.5,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  score,
                  style: const TextStyle(
                    color: Color(0xfff6f6f6),
                    fontSize: 32,
                    fontFamily: 'Fredoka',
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
