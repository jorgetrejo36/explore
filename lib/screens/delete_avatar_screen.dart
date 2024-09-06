import 'package:explore/utils/realm_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const int maxUsers = 8;

class DeleteAvatarScreen extends StatefulWidget {
  const DeleteAvatarScreen({Key? key}) : super(key: key);

  @override
  _DeleteAvatarScreenState createState() => _DeleteAvatarScreenState();
}

class _DeleteAvatarScreenState extends State<DeleteAvatarScreen> {
  late List<KeyUserInfo> users;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      users = RealmUtils().getAllUsers();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth * 0.25;
    double spacing = screenWidth * 0.06;

    // Image path for the circle buttons
    String rocketImage = "assets/images/rocket.png";

    // Define a map to assign colors to specific button indices
    Map<int, Color> buttonColors = {
      1: Color(0xFF9443DC),
      2: Color(0xFF2AB2D7),
      3: Color(0xFF3E7CDA),
      4: Color(0xFF6D4CF1),
      5: Color(0xFF9443DC),
      6: Color(0xFF2AB2D7),
      7: Color(0xFF3E7CDA),
      8: Color(0xFF6D4CF1),
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              size: MediaQuery.of(context).size.height / 15,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/StarsBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                rocketImage, // Rocket image
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: Container(
                width: screenWidth * .60,
                height: screenWidth * 1.15,
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.5,
                  children: List.generate(
                    maxUsers,
                    (index) => index < users.length
                        ? ElevatedButton(
                            onPressed: () {
                              // Window pops up to delete user
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: Color(0xFF647F86),
                                  actions: <Widget>[
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Stack(
                                          alignment: Alignment
                                              .center, // Ensure stack contents are centered
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/garbage-bin.svg',
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4,
                                            ),
                                            Positioned(
                                              bottom: MediaQuery.sizeOf(context)
                                                      .height /
                                                  6,
                                              // Adjust this value to position the avatar.
                                              // Adjust this value as needed to create the desired overlap
                                              child: ClipRect(
                                                child: Align(
                                                  alignment: Alignment
                                                      .topCenter, // Aligns the top part of the avatar to be visible
                                                  heightFactor:
                                                      0.8, // Adjusts this to control how much of the avatar is visible; 0.5 shows the top half
                                                  child: SvgPicture.asset(
                                                    users[index].avatar,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            9,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 30,
                                              child: Icon(
                                                Icons.question_mark,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    12,
                                                color: Colors.purple,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        users[index].name,
                                        style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () => {
                                            Navigator.pop(context),
                                            RealmUtils()
                                                .deleteUser(users[index].id),
                                            setState(() {
                                              _loadData();
                                            }),
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/images/right.svg',
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                14,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                14,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => {
                                            Navigator.pop(context),
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/images/wrong.svg',
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                14,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                14,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: buttonColors[index + 1],
                            ),
                            child: Stack(
                              children: [
                                SvgPicture.asset(
                                  users[index].avatar,
                                  width: 450,
                                  height: 450,
                                ),
                                Positioned(
                                  bottom: -1,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFAC6FE3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      users[index].name,
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size:
                                        MediaQuery.of(context).size.width / 10,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox
                            .shrink(), // this is an emtpy widget intended to show nothing
                  ),
                ),
              ),
            ),
            Positioned(
              top: spacing * 3,
              right: screenWidth * 0.15,
              left: screenWidth * 0.15,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Color(0xFF647F86),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/garbage-bin.svg',
                          height: MediaQuery.of(context).size.height / 7,
                        ),
                        Positioned(
                          bottom: 5,
                          child: Icon(
                            Icons.question_mark,
                            size: MediaQuery.of(context).size.height / 15,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
