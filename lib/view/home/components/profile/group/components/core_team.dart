import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/custom.buttons.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/group_controller.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/dynamiclink_util.dart';
import 'package:idute_app/view/home/components/profile/group/components/add_member_group.dart';
import 'package:share_plus/share_plus.dart';

class CoreTeam extends StatelessWidget {
  GroupModel group;
  CoreTeam({super.key, required this.group});

  _coreMemberWidget(
      {bool? isFounder = false,
      required BuildContext context,
      UserModel? userModel}) {
    return FutureBuilder(
        future: FirebaseConstants.store
            .collection("Users")
            .doc(userModel!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userModel = UserModel.fromMap(snapshot.data!.data()!);
            return Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      (userModel!.profileImage != null &&
                              userModel!.profileImage != "")
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userModel!.profileImage!),
                              radius: 30,
                            )
                          : const CircleAvatar(
                              radius: 30,
                              child: Icon(
                                Icons.person,
                                size: 30,
                              ),
                            ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText(text: userModel!.name!, txtSize: 12),
                          buildText(
                              text: userModel!.category!,
                              txtSize: 10,
                              color: AppColors.kFillColor)
                        ],
                      )
                    ],
                  ),
                  (isFounder!)
                      ? CustomButton().squareTextButton(
                          context: context,
                          text: "Founder",
                          width: SizeConfig.screenWidth * 0.3,
                          borderRadius: 5,
                          onPress: () {},
                          bgColor: Colors.black)
                      : const SizedBox()
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return buildText(text: "Error", color: AppColors.kFillColor);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  _coreMembers(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseConstants.store
            .collection("Groups")
            .doc(group.groupId)
            .collection("members")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> members =
                snapshot.data!.docs;
            if (members.isEmpty) {
              return buildText(text: "No members");
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: members.length,
                itemBuilder: (context, index) {
                  UserModel user = UserModel.fromMap(members[index].data());
                  return (group.createdBy == user.uid!)
                      ? _coreMemberWidget(
                          context: context, userModel: user, isFounder: true)
                      : _coreMemberWidget(context: context, userModel: user);
                });
          }

          if (snapshot.connectionState == ConnectionState.none) {
            return ErrorScreen(
                error: "Connection Issue",
                errorIcon: const Icon(
                  Icons.error_outline,
                  color: Colors.grey,
                ));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: (group.createdBy == _auth.currentUser!.uid)
                        ? SizeConfig.screenWidth * 0.7
                        : SizeConfig.screenWidth * 0.4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        (group.createdBy == _auth.currentUser!.uid)
                            ? Expanded(
                                child: CustomButton().squareIconButton(
                                    context: context,
                                    text: "Add Member",
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.white,
                                    ),
                                    width: SizeConfig.screenWidth * 0.25,
                                    borderRadius: 10,
                                    onPress: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => AddMember(
                                                    group: group,
                                                  )));
                                    },
                                    bgColor: AppColors.kcardColor),
                              )
                            : const SizedBox(),
                        (group.createdBy == _auth.currentUser!.uid)
                            ? const SizedBox(
                                width: 10,
                              )
                            : const SizedBox(),
                        Expanded(
                          child: CustomButton().squareIconButton(
                              context: context,
                              text: "Invite via link",
                              icon: const Icon(
                                Icons.link,
                                color: Colors.white,
                              ),
                              width: SizeConfig.screenWidth * 0.25,
                              borderRadius: 10,
                              onPress: () async {
                                Uri groupLink = await DynamicLinkService()
                                    .createDynamicLinkForGroup(group.groupId!);

                                Share.share(groupLink.toString());
                              },
                              bgColor: AppColors.kcardColor),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  _coreMembers(context),
                  // Padding(
                  //   padding: const EdgeInsets.all(10),
                  //   child: Text(
                  //     "see all",
                  //     style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  //         decoration: TextDecoration.underline,
                  //         decorationColor: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          (group.createdBy == _auth.currentUser!.uid)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    TextButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          await GroupController()
                              .completeGroupDiscussion(group);
                        },
                        icon: const Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        label: buildText(text: "Complete Discussion")),
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
