import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/view/home/components/main/main_screen.dart';
import 'package:idute_app/view/home/components/notifications/notification_screen.dart';
import 'package:idute_app/view/home/components/profile/group/components/group.dart';
import 'package:idute_app/view/home/components/posts/post_screen.dart';
import 'package:idute_app/view/home/components/profile/group/components/group.dart';
import 'package:idute_app/view/profile/profile_screen_widget.dart';

class UrlConstants {
  // Base URL

  //END-POINTS

  //TOKEN

  // Variables
  static final RegExp emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
  );

  List<Color?> profileColor = [
    Colors.red[200],
    Colors.green[200],
    Colors.blue[200],
    Colors.amber[200]
  ];

  static List<Widget> bottombarWidgets = [
    const MainScreen(),
    Group1(),
    PostScreen(),
    const NotificationScreen(),
    const ProfileScreenWidget(),
  ];

  FirebaseAuth _auth = FirebaseConstants.firebaseAuth;

  static List<BottomNavigationBarItem> bottomNavBarItems = [
    BottomNavigationBarItem(
      backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
      icon: SvgPicture.asset(
        "assets/icons/home_filled.svg",
        width: 25,
        height: 25,
        // color: Colors.white,
      ),
      activeIcon: SvgPicture.asset(
        "assets/icons/home.svg",
        width: 25,
        height: 25,
        // color: Colors.white,
      ),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      backgroundColor: AppColors.sBackgroundColor,
      icon: Icon(
        Icons.rocket_outlined,
        size: 30,
      ),
      activeIcon: Icon(
        Icons.rocket,
        size: 30,
      ),
      label: 'Group',
    ),
    const BottomNavigationBarItem(
      backgroundColor: AppColors.sBackgroundColor,
      icon: Icon(
        Icons.ios_share_rounded,
        size: 30,
      ),
      activeIcon: Icon(
        Icons.ios_share_rounded,
        size: 30,
      ),
      label: 'Post',
    ),
    BottomNavigationBarItem(
      backgroundColor: AppColors.sBackgroundColor,
      icon: StreamBuilder(
          stream: FirebaseConstants.store
              .collection("Users")
              .doc(FirebaseConstants.firebaseAuth.currentUser!.uid)
              .collection("Notifications")
              .where("read", isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  (snapshot.data!.docs.isNotEmpty)
                      ? const Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            Icons.circle,
                            size: 12,
                            color: Colors.red,
                          ),
                        )
                      : const SizedBox(),
                  const Icon(
                    Icons.notifications_none_rounded,
                    size: 30,
                  ),
                ],
              );
            }

            return const Stack(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: 30,
                ),
              ],
            );
          }),
      activeIcon: Icon(
        Icons.notifications_active_rounded,
        size: 30,
      ),
      label: 'Notification',
    ),
    BottomNavigationBarItem(
      backgroundColor: AppColors.sBackgroundColor,
      icon: StreamBuilder(
          stream: FirebaseConstants.store
              .collection("Users")
              .doc(FirebaseConstants.firebaseAuth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.data()!["profileImage"] != null &&
                  snapshot.data!.data()!["profileImage"] != "") {
                return CircleAvatar(
                  radius: 15,
                  backgroundImage:
                      NetworkImage(snapshot.data!.data()!["profileImage"]),
                );
              }
              return const CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage("assets/icons/default.jpg"),
              );
            }

            if (snapshot.hasError) {
              return const CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage("assets/icons/default.jpg"),
              );
            }

            return const CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage("assets/icons/default.jpg"),
            );
          }),
      label: 'Profile',
    ),
  ];
}
