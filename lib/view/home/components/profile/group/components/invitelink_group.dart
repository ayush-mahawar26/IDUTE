import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/group_controller.dart';

class InviteLinkForGroup extends StatelessWidget {
  String groupId;
  InviteLinkForGroup({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: GroupController().getGroupById(groupId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildText(
                        text: "Group - ${snapshot.data!.title}",
                        txtSize: 15,
                        color: AppColors.kFillColor),
                    buildText(
                      text: snapshot.data!.title,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(
                        stream: FirebaseConstants.store
                            .collection("Groups")
                            .doc(groupId)
                            .collection("members")
                            .snapshots(),
                        builder: (context, memberSnapshot) {
                          if (memberSnapshot.hasData) {
                            List<String> members = [];
                            for (QueryDocumentSnapshot mem
                                in memberSnapshot.data!.docs) {
                              members.add(mem.id);
                            }

                            if (members.contains(FirebaseConstants
                                .firebaseAuth.currentUser!.uid)) {
                              return buildText(
                                  text: "You are Already a member !");
                            } else {
                              return ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.kBackgroundColor),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)))),
                                  onPressed: () async {
                                    await GroupController()
                                        .createRequestForGroup(
                                            FirebaseConstants
                                                .firebaseAuth.currentUser!.uid,
                                            snapshot.data!);
                                  },
                                  child: buildText(text: "Send Request"));
                            }
                          }

                          if (memberSnapshot.hasError) {
                            return ErrorScreen(
                                error: "Group may not exist",
                                errorIcon: const Icon(Icons.error));
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        })
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return ErrorScreen(
                  error: "Group No Longer Exist",
                  errorIcon: const Icon(
                    Icons.error,
                    color: AppColors.kFillColor,
                  ));
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
