import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/widgets/custom_group_card.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/model/group_model.dart';

class UserGroups extends StatelessWidget {
  String userUid;
  UserGroups({super.key, required this.userUid});

  final FirebaseFirestore _store = FirebaseConstants.store;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _store
            .collection("Users")
            .doc(userUid)
            .collection("Groups")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> groups =
                snapshot.data!.docs;
            if (groups.isEmpty) {
              return Center(
                child: ErrorScreen(
                    error: "No Groups by this user",
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
                  return Padding(
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                          onTap: () {},
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: InkWell(
                                onTap: () {},
                                child: ListTile(
                                  leading:
                                      Image.asset("assets/images/grp_card.png"),
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
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      "assets/icons/card_1.svg",
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                ),
                              ))));
                });
          }

          if (snapshot.hasError) {
            return Center(
              child: buildText(text: "error"),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
