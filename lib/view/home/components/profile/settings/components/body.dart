import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/custom_cont_text.dart';
import 'package:idute_app/components/widgets/custom_tff_outlined.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/push_notification_controller.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/firebase_utils.dart';
import 'package:idute_app/view/auth/auth_screen.dart';
import 'package:idute_app/view/home/components/profile/settings/components/about.dart';
import 'package:idute_app/view/home/components/profile/settings/components/account.dart';
import 'package:idute_app/view/home/components/profile/settings/components/invite.dart';
import 'package:idute_app/view/splash/splash_screen.dart';

import '../../../../../../components/widgets/custom_dialog.dart';
import '../../../../../../components/widgets/custom_list_tile.dart';

class Body extends StatefulWidget {
  UserModel userModel;
  Body({super.key, required this.userModel});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController _suggestionController = TextEditingController();
  TextEditingController _helpController = TextEditingController();

  Future<dynamic> customDialog(
      {required BuildContext context,
      required TextEditingController controller,
      required String headerText,
      required String writeText,
      required textboxText,
      required bool isSuggestion}) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) => Dialog(
        elevation: 0,
        backgroundColor: const Color(0xff242424),
        surfaceTintColor: null,
        shadowColor: null,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(width: 1, color: Color(0xff3a3a3a))),
        child: SizedBox(
          height: getProportionateScreenHeight(323),
          width: getProportionateScreenWidth(319),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildSizeHeight(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  Center(
                    child: buildText(
                      text: headerText,
                      txtSize: 20,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),
                  buildSizeWidth(width: 4),
                ],
              ),
              buildSizeHeight(height: 17),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildText(
                      text: writeText,
                      txtSize: 13,
                    ),
                    buildSizeHeight(height: 9),
                    buildNewTextFormField(
                      controller: TextEditingController(),
                      height: 109,
                      width: 251,
                      keyboardType: TextInputType.multiline,
                      hintText: "$textboxText",
                      errorText: "",
                      bgColor: const Color(0xff3a3a3a),
                      brColor: const Color(0xff4e4e4e),
                      htColor: const Color(0xFFA5A5A5),
                    ),
                    buildSizeHeight(height: 16),
                    InkWell(
                      onTap: () async {
                        FirebaseAuth _auth = FirebaseConstants.firebaseAuth;
                        FirebaseFirestore _store = FirebaseConstants.store;
                        UserModel? user =
                            await ProfileController().fetchUserProfile();
                        if (isSuggestion) {
                          await _store.collection("suggestions").doc().set({
                            "username": user!.username,
                            "useruid": user.uid,
                            "suggestion": controller.text
                          });
                        } else {}
                      },
                      customBorder: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xff585858),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: buildContainerText(
                        text: "Submit",
                        width: 100,
                        height: 26,
                        radSize: 30,
                        contColor: const Color(0xff454545),
                        borderColor: const Color(0xff585858),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTile(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const AccountScreen(),
            //   ),
            // );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountScreen(
                  userModel: widget.userModel,
                ),
              ),
            );
          },
          imageURL: "assets/icons/setting_3.svg",
          text: "Edit Profile",
        ),
        buildTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InviteScreen(),
              ),
            );
          },
          imageURL: "assets/icons/setting_1.svg",
          text: "Invite Friends",
        ),
        buildTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutScreen(),
              ),
            );
          },
          imageURL: "assets/icons/setting_2.svg",
          text: "About",
        ),
        buildTile(
          onTap: () {
            customDialog(
                controller: _helpController,
                context: context,
                headerText: "Help",
                writeText: "What help do you need from us ?",
                textboxText: "Write Text",
                isSuggestion: true);
          },
          imageURL: "assets/icons/setting_4.svg",
          text: "Help",
        ),
        buildTile(
          onTap: () async {
            await FirebaseConstants.store
                .collection("Users")
                .doc(FirebaseConstants.firebaseAuth.currentUser!.uid)
                .set({"fcm": ""}, SetOptions(merge: true));
            await FirebaseUtils().signOut(context);
          },
          imageURL: "assets/icons/setting_7.svg",
          text: "Logout",
          color: const Color(0xFF686868),
        ),
        const Spacer(),
        buildTile(
          onTap: () async {},
          imageURL: "assets/icons/setting_5.svg",
          text: "Rate the app",
        ),
        buildTile(
          onTap: () {
            customDialog(
                context: context,
                headerText: "App Suggestions",
                writeText: "Write here",
                textboxText: "Suggestions are welcome....",
                controller: _suggestionController,
                isSuggestion: true);
          },
          imageURL: "assets/icons/setting_6.svg",
          text: "Give Suggestions",
        ),
        buildSizeHeight(height: 10),
      ],
    );
  }
}
