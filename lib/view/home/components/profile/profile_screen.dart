import 'package:flutter/material.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/utils/firebase_utils.dart';
import 'package:idute_app/view/auth/auth_screen.dart';
import 'package:idute_app/view/profile/profile_screen_widget.dart';
import 'package:idute_app/view/splash/splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProfileScreenWidget(),
      // body: Center(
      //   child: InkWell(
      //     onTap: () {
      //       FirebaseUtils().signOut();
      //       Navigator.of(context).pushAndRemoveUntil(
      //           MaterialPageRoute(builder: (context) => SplashScreen()),
      //           (route) => false);
      //     },
      //     child: buildText(text: "signout"),
      //   ),
      // ),
    );
  }
}
