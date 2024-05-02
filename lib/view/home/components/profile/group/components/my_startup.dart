import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/bottomsheet_group.dart';
import 'package:idute_app/components/widgets/custom_group_card.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/group_bottomsheet.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/group_controller.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/view/home/components/profile/group/components/create_group.dart';
import 'package:idute_app/view/home/components/profile/group/group_screen.dart';
import 'package:idute_app/view/home/components/profile/group/mystartup_groupinfo.dart';

class MyStartUp extends StatefulWidget {
  const MyStartUp({super.key});

  @override
  State<MyStartUp> createState() => _MyStartUpState();
}

class _MyStartUpState extends State<MyStartUp> {
  bool suggested = true;

  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;

  final FirebaseFirestore _store = FirebaseConstants.store;

  _showCreateGroup(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColors.sBackgroundColor,
      builder: (BuildContext context) {
        return BottomSheetForGroup();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
            stream: FirebaseConstants.store
                .collection("Users")
                .doc(FirebaseConstants.firebaseAuth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserModel user = UserModel.fromMap(snapshot.data!.data()!);
                return (!user.createdOwnGroup!)
                    ? InkWell(
                        onTap: () {
                          _showCreateGroup(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.kHintColor,
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: AppColors.sBackgroundColor,
                                  child: Icon(
                                    Icons.add_circle_outline_outlined,
                                    color: AppColors.kHintColor,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildText(
                                        text: "Research on your Startup Idea",
                                        txtSize: 14,
                                        fontWeight: FontWeight.bold),
                                    buildText(
                                        text:
                                            "Get Co-founder  & core team and research with that team on your startup idea",
                                        txtSize: 12)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : StreamBuilder(
                        stream: _store
                            .collection("Users")
                            .doc(_auth.currentUser!.uid)
                            .collection("Groups")
                            .where("createdBy",
                                isEqualTo: _auth.currentUser!.uid)
                            .snapshots(),
                        builder: (context, userGroupData) {
                          if (userGroupData.hasData) {
                            if (userGroupData.data!.docs.isNotEmpty) {
                              GroupModel groupModel = GroupModel.fromMap(
                                  userGroupData.data!.docs[0].data());
                              return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyStartUpGroupInfo(
                                                      groupInfo: groupModel)));
                                    },
                                    child: ListTile(
                                      leading: Image.asset(
                                          "assets/images/grp_card.png"),
                                      // const CircleAvatar(
                                      //   backgroundImage:
                                      //       AssetImage("assets/images/grp_card.png"),
                                      //   radius: 35,
                                      // ),
                                      title: buildText(
                                        text: groupModel.title,
                                        txtSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      subtitle: buildText(
                                        text: groupModel.description,
                                        txtSize: 10,
                                        fontWeight: FontWeight.w400,
                                        maxLine: 3,
                                      ),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          _showBottonSheet(context, groupModel);
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icons/card_1.svg",
                                          width: 25,
                                          height: 25,
                                        ),
                                      ),
                                    ),

                                    //  CustomGroupCard(
                                    //   group: state.groups[index],
                                    //   isjoinStartUp: true,
                                    // ),
                                  ));
                            } else {
                              return const SizedBox();
                            }
                          }

                          if (userGroupData.hasError) {
                            return Center(
                              child: buildText(
                                  text: "Error", color: AppColors.kFillColor),
                            );
                          }

                          return const Center(
                              child: CircularProgressIndicator());
                        });
              }

              if (snapshot.hasError) {
                return Center(
                  child: buildText(text: "Error occured", txtSize: 12),
                );
              }

              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }),
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: buildText(
              text: "Ally Startups", txtSize: 15, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: StreamBuilder(
              stream: _store
                  .collection("Users")
                  .doc(_auth.currentUser!.uid)
                  .collection("Groups")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> groups =
                      snapshot.data!.docs;
                  if (groups.isEmpty) {
                    return Center(
                      child: ErrorScreen(
                          error: "No Groups by you",
                          errorIcon: const Icon(
                            Icons.error,
                            color: AppColors.kFillColor,
                            size: 20,
                          )),
                    );
                  }
                  return ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        GroupModel groupModel =
                            GroupModel.fromMap(groups[index].data());
                        return (groupModel.createdBy == _auth.currentUser!.uid)
                            ? const SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyStartUpGroupInfo(
                                                    groupInfo: groupModel)));
                                  },
                                  child: ListTile(
                                    leading: Image.asset(
                                        "assets/images/grp_card.png"),
                                    // const CircleAvatar(
                                    //   backgroundImage:
                                    //       AssetImage("assets/images/grp_card.png"),
                                    //   radius: 35,
                                    // ),
                                    title: buildText(
                                      text: groupModel.title,
                                      txtSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    subtitle: buildText(
                                      text: groupModel.description,
                                      txtSize: 10,
                                      fontWeight: FontWeight.w400,
                                      maxLine: 3,
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        _showBottonSheet(context, groupModel);
                                      },
                                      child: SvgPicture.asset(
                                        "assets/icons/card_1.svg",
                                        width: 25,
                                        height: 25,
                                      ),
                                    ),
                                  ),

                                  //  CustomGroupCard(
                                  //   group: state.groups[index],
                                  //   isjoinStartUp: true,
                                  // ),
                                ));
                      });
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [
                        const Icon(Icons.error),
                        buildText(text: "Some Error Occured")
                      ],
                    ),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        )
      ],
    );
  }

  _showBottonSheet(BuildContext context, GroupModel model) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.sBackgroundColor,
      builder: (BuildContext context) {
        return GroupInfoBottomSheet(
          model: model,
        );
      },
    );
  }
}
