import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:explore/app_colors.dart';

// Displays a custom AppBar on the PMS Screen.

class PMSAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const PMSAppBarWidget({super.key});

  // Implement & set PreferredSizeWidget so we can use this as the AppBar.
  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    // Return only a fully-constructed AppBar for the PMS screen.
    return AppBar(

      // Size the AppBar, color, and center its content.
      backgroundColor: const Color(0xB2A149F0),
      toolbarHeight: 60.0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      flexibleSpace: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: kToolbarHeight),
      ),

      // All content on the AppBar is stored in a Row left to right.
      title: Row(
        children: [

          // Back button on the left side.
          Container(
            margin: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              shape: BoxShape.rectangle,
              color: const Color(0xFF6B6B6B),
            ),

            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Immediately after is the player's inputted name.
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Slevin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontFamily: "Fredoka",
                ),
              ),
            ),
          ),

          // Finally, the rightmost side shows the player's avatar.
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.all(5),
            child: Stack(
              alignment: Alignment.center,
              children: [

                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.darkPurple,
                  ),
                ),
                Center(
                  child: SvgPicture.asset(
                    'assets/images/alien.svg',
                    width: 48,
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
