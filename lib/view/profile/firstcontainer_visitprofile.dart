import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/connection_controller.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/dynamiclink_util.dart';
import 'package:idute_app/view/home/components/profile/chat/chat_screen.dart';
import 'package:share_plus/share_plus.dart';

class FirstContainerVisitProfile extends StatefulWidget {
  UserModel userModel;
  FirstContainerVisitProfile({super.key, required this.userModel});
  static final borderShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50),
    side: const BorderSide(color: Colors.white, width: 1),
  );

  @override
  State<FirstContainerVisitProfile> createState() =>
      _FirstContainerVisitProfileState();
}

class _FirstContainerVisitProfileState
    extends State<FirstContainerVisitProfile> {
  bool isEditable = false;

  Widget _customProfileButtons(
      String text, Widget icon, Color color, Function onTap, double midGap,
      {Color textColor = Colors.white}) {
    return Container(
      height: 35,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                SizedBox(
                  width: midGap,
                ),
                buildText(text: text, txtSize: 12, color: textColor)
              ],
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController _aboutController = TextEditingController();

  bool showmore = false;

  int maxCharacter = 150;

  @override
  Widget build(BuildContext context) {
    print(widget.userModel.about!.length);
    String aboutUser = (showmore)
        ? widget.userModel.about!
        : (widget.userModel.about!.length > maxCharacter)
            ? "${widget.userModel.about!.substring(0, maxCharacter)}...."
            : widget.userModel.about!;
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.018),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (widget.userModel.isFounder! == false)
                    ? buildText(
                        text: "Entrepreneur",
                        txtSize: 12,
                        color: AppColors.kHintColor)
                    : buildText(
                        text: "Founder - ${widget.userModel.startupname}",
                        txtSize: 12,
                        color: AppColors.kHintColor),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      FluentIcons.hat_graduation_12_regular,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.83,
                      child: buildText(
                          text: widget.userModel.qualification!, txtSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    buildText(text: widget.userModel.location!, txtSize: 12),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: StreamBuilder(
                              stream: ConnectionController()
                                  .isAlreadyConnectionSent(
                                      widget.userModel.uid!,
                                      FirebaseConstants
                                          .firebaseAuth.currentUser!.uid),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.docs.isNotEmpty) {
                                    return _customProfileButtons(
                                        "Requested",
                                        const Icon(
                                          Icons.send,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        AppColors.kcardColor,
                                        () {},
                                        5);
                                  }
                                  // Check - if present in connect otherwise
                                  // if yes - show unconnect
                                  // else - show connect button
                                  return StreamBuilder(
                                      stream: ConnectionController()
                                          .isThatSentReqToMe(
                                              FirebaseConstants.firebaseAuth
                                                  .currentUser!.uid,
                                              widget.userModel.uid!),
                                      builder: (context, snapshotOfConnect) {
                                        if (snapshotOfConnect.hasData) {
                                          if (snapshotOfConnect
                                              .data!.docs.isEmpty) {
                                            return StreamBuilder(
                                                stream: FirebaseConstants.store
                                                    .collection("Users")
                                                    .doc(widget.userModel.uid!)
                                                    .collection("connects")
                                                    .where("uid",
                                                        isEqualTo:
                                                            FirebaseConstants
                                                                .firebaseAuth
                                                                .currentUser!
                                                                .uid)
                                                    .snapshots(),
                                                builder: (context,
                                                    connectedSnapshot) {
                                                  if (connectedSnapshot
                                                      .hasData) {
                                                    if (connectedSnapshot
                                                        .data!.docs.isEmpty) {
                                                      return _customProfileButtons(
                                                          "Connect",
                                                          SvgPicture.asset(
                                                            "assets/icons/thunder.svg",
                                                            color: Colors.black,
                                                          ),
                                                          Colors.white,
                                                          () async {
                                                        UserModel? mySelf =
                                                            await ProfileController()
                                                                .fetchUserProfile();
                                                        if (mySelf != null) {
                                                          ConnectionController()
                                                              .sendRequest(
                                                                  widget
                                                                      .userModel
                                                                      .uid!,
                                                                  mySelf);
                                                        } else {
                                                          print("Null User");
                                                        }
                                                      }, 0,
                                                          textColor:
                                                              Colors.black);
                                                    } else {
                                                      return _customProfileButtons(
                                                          "Connected",
                                                          SvgPicture.asset(
                                                              "assets/icons/thunder.svg"),
                                                          AppColors.kcardColor,
                                                          () async {
                                                        UserModel? mySelf =
                                                            await ProfileController()
                                                                .fetchUserProfile();
                                                        if (mySelf != null) {
                                                          ConnectionController()
                                                              .unconnect(
                                                                  widget
                                                                      .userModel
                                                                      .uid!,
                                                                  FirebaseConstants
                                                                      .firebaseAuth
                                                                      .currentUser!
                                                                      .uid);
                                                        } else {
                                                          print("Null User");
                                                        }
                                                      }, 5);
                                                    }
                                                  }

                                                  return const SizedBox();
                                                });
                                          }

                                          return _customProfileButtons(
                                              "Accept",
                                              SvgPicture.asset(
                                                  "assets/icons/thunder.svg"),
                                              AppColors.kBackgroundColor,
                                              () async {
                                            UserModel? mySelf =
                                                await ProfileController()
                                                    .fetchUserProfile();
                                            if (mySelf != null) {
                                              ConnectionController()
                                                  .acceptRequest(
                                                      widget.userModel, mySelf);
                                            } else {
                                              print("Null User");
                                            }
                                          }, 0);
                                        }

                                        if (snapshotOfConnect.hasError) {
                                          return Center(
                                            child: buildText(
                                                text: "Error",
                                                txtSize: 12,
                                                color: AppColors.kFillColor),
                                          );
                                        }

                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.kcardColor,
                                          ),
                                        );
                                      });
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                    child: buildText(
                                        text: "Error",
                                        txtSize: 12,
                                        color: AppColors.kFillColor),
                                  );
                                }

                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.kcardColor,
                                  ),
                                );
                              })),
                      SizedBox(
                        width: (SizeConfig.screenWidth * 0.023 +
                                SizeConfig.screenWidth * 0.02) /
                            2,
                      ),
                      // Expanded(
                      //     child: _customProfileButtons(
                      //         "Chat",
                      //         const Icon(
                      //           Icons.message,
                      //           color: Colors.white,
                      //         ),
                      //         AppColors.kcardColor, () {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => const ChatScreen()));
                      // })),
                      // const SizedBox(
                      //   width: 20,
                      // ),
                      Expanded(
                        child: _customProfileButtons(
                          "Share Profile",
                          const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 20,
                          ),
                          AppColors.kcardColor,
                          () async {
                            Uri uri = await DynamicLinkService()
                                .createDynamicLinkForUserProfile(
                                    widget.userModel.uid!);
                            await Share.share(uri.toString());
                          },
                          2,
                        ),
                      ),
                      SizedBox(
                        width: (SizeConfig.screenWidth * 0.023 +
                                SizeConfig.screenWidth * 0.02) /
                            2,
                      ),

                      Expanded(
                          child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                            color: AppColors.kcardColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    name: widget.userModel.name!,
                                    profileUrl: widget.userModel.profileImage!,
                                    uid: widget.userModel.uid!)));
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 10),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        "assets/icons/message.svg"),
                                    const SizedBox(
                                      width: 0,
                                    ),
                                    buildText(text: "Chat", txtSize: 12)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(
                        text: "About",
                        txtSize: 12,
                        fontWeight: FontWeight.w600),
                    // (userModel.about!="" && userModel.about !=null) ?
                    const SizedBox(
                      height: 5,
                    ),
                    (isEditable)
                        ? TextFormField(
                            controller: _aboutController,
                            maxLines: 4,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 14),
                            decoration: InputDecoration(
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(
                                    top: 80, bottom: 0, left: 0, right: 0),
                                child: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                ),
                              ),
                              fillColor: AppColors.kcardColor,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                            ),
                          )
                        : (widget.userModel.about!.length > maxCharacter)
                            ? RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: getProportionateScreenWidth(12),
                                      letterSpacing: 0,
                                      fontFamily: "Inter",
                                    ),
                                    children: [
                                    TextSpan(text: aboutUser),
                                    TextSpan(
                                        style: TextStyle(
                                          color: AppColors.kFillColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              getProportionateScreenWidth(12),
                                          letterSpacing: 0,
                                          fontFamily: "Inter",
                                        ),
                                        text: (showmore)
                                            ? "  Show Less"
                                            : "Show More",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(() {
                                              showmore = !showmore;
                                            });
                                          })
                                  ]))
                            : buildText(
                                text: widget.userModel.about!, txtSize: 12)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
