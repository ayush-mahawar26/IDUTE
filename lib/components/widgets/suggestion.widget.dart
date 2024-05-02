import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/connection_controller.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/iq_model.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/iq_algo.dart';
import 'package:idute_app/view/profile/visit_profile.dart';

class SuggestionCardWidget extends StatefulWidget {
  String aboveText;
  String secText;
  List<UserModel> list;
  SuggestionCardWidget(
      {super.key,
      required this.secText,
      required this.list,
      required this.aboveText});

  @override
  State<SuggestionCardWidget> createState() => _SuggestionCardWidgetState();
}

class _SuggestionCardWidgetState extends State<SuggestionCardWidget> {
  List<UserModel> filteredList = [];

  void filterSuggestion() async {
    List<String> userIConnectedWith =
        await ProfileController().userConnectedWithMe();
    List<String> userWhoSentRequestToMe =
        await ProfileController().usersWhoRequestedMe();
    filteredList = widget.list
        .where((user) =>
            !userIConnectedWith.contains(user.uid) &&
            !userWhoSentRequestToMe.contains(user.uid))
        .toList();
    setState(() {});
    print(widget.list.length);
  }

  @override
  void initState() {
    super.initState();
    filterSuggestion();
  }

  @override
  Widget build(BuildContext context) {
    return (filteredList.isNotEmpty)
        ? SizedBox(
            width: SizeConfig.screenWidth,
            child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 235),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => VisitUserProfile(
                                userModel: filteredList[index])));
                      },
                      child: CardWidget(
                          user: filteredList[index],
                          onTapFunction: () {
                            widget.list.removeAt(index);
                            setState(() {});
                          }));
                }),
          )
        : Center(
            child: InkWell(
              onTap: () {
                setState(() {});
              },
              child: buildText(
                text: "No Contacts",
                color: AppColors.kFillColor,
              ),
            ),
          );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.user,
    required this.onTapFunction,
  });

  final UserModel user;
  final Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: AppColors.kcardColor)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.kcardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: buildText(text: user.category!, txtSize: 10),
                ),
              ),
              InkWell(
                onTap: () {
                  onTapFunction();
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 2),
                  child: Icon(
                    CupertinoIcons.xmark,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Center(
              child: (user.profileImage == null || user.profileImage == "")
                  ? Stack(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage("assets/icons/default.jpg"),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 12,
                              child: StreamBuilder(
                                stream: FirebaseConstants.store
                                    .collection("iq")
                                    .doc(user.uid!)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    IqModel iq =
                                        IqModel.fromMap(snapshot.data!.data()!);
                                    double useriq =
                                        UserIQCalculator.calculateIQ(iq: iq);
                                    int roundediq = (useriq / 10).round() * 10;
                                    return buildText(
                                        text: (roundediq + 20 > 150)
                                            ? "150+"
                                            : "${roundediq + 20}+",
                                        txtSize: 7);
                                  }

                                  if (snapshot.hasError) {
                                    return const SizedBox();
                                  }

                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.profileImage!),
                          radius: 30,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 12,
                              child: StreamBuilder(
                                stream: FirebaseConstants.store
                                    .collection("iq")
                                    .doc(user.uid!)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    IqModel iq =
                                        IqModel.fromMap(snapshot.data!.data()!);
                                    double useriq =
                                        UserIQCalculator.calculateIQ(iq: iq);
                                    int roundediq = (useriq / 10).round() * 10;
                                    return buildText(
                                        text: (roundediq + 20 > 150)
                                            ? "150+"
                                            : "${roundediq + 20}+",
                                        txtSize: 7);
                                  }

                                  if (snapshot.hasError) {
                                    return const SizedBox();
                                  }

                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
          const SizedBox(
            height: 8,
          ),
          buildText(text: user.name!, txtSize: 12),
          (user.isFounder!)
              ? buildText(
                  text: "Founder", txtSize: 12, color: AppColors.kFillColor)
              : buildText(
                  text: "Enterpreneaur",
                  txtSize: 12,
                  color: AppColors.kFillColor),
          (user.isFounder!)
              ? buildText(
                  text: (user.startupname != null || user.startupname != "")
                      ? user.startupname!
                      : "-",
                  txtSize: 12,
                  color: AppColors.kFillColor)
              : buildText(text: "-", txtSize: 12, color: AppColors.kFillColor),
          const SizedBox(
            height: 8,
          ),
          Container(
              width: SizeConfig.screenWidth * 0.3,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: StreamBuilder(
                    stream: ConnectionController().isAlreadyConnectionSent(
                        user.uid!,
                        FirebaseConstants.firebaseAuth.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: buildText(
                                  text: "Requested",
                                  txtSize: 12,
                                  color: Colors.black));
                        }
                        // Check - if present in connect otherwise
                        // if yes - show unconnect
                        // else - show connect button
                        return StreamBuilder(
                            stream: ConnectionController().isThatSentReqToMe(
                                FirebaseConstants.firebaseAuth.currentUser!.uid,
                                user.uid!),
                            builder: (context, snapshotOfConnect) {
                              if (snapshotOfConnect.hasData) {
                                if (snapshotOfConnect.data!.docs.isEmpty) {
                                  // are we connected - if yes show unconnect else connect

                                  return StreamBuilder(
                                      stream: FirebaseConstants.store
                                          .collection("Users")
                                          .doc(user.uid!)
                                          .collection("connects")
                                          .where("uid",
                                              isEqualTo: FirebaseConstants
                                                  .firebaseAuth
                                                  .currentUser!
                                                  .uid)
                                          .snapshots(),
                                      builder: (context, connectedSnapshot) {
                                        if (connectedSnapshot.hasData) {
                                          if (connectedSnapshot
                                              .data!.docs.isEmpty) {
                                            return InkWell(
                                                onTap: () async {
                                                  UserModel? mySelf =
                                                      await ProfileController()
                                                          .fetchUserProfile();
                                                  if (mySelf != null) {
                                                    ConnectionController()
                                                        .sendRequest(
                                                            user.uid!, mySelf);
                                                  } else {
                                                    print("Null User");
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: buildText(
                                                      text: "Connect",
                                                      txtSize: 12,
                                                      color: Colors.black),
                                                ));
                                          } else {
                                            return InkWell(
                                                onTap: () async {
                                                  UserModel? mySelf =
                                                      await ProfileController()
                                                          .fetchUserProfile();
                                                  if (mySelf != null) {
                                                    ConnectionController()
                                                        .unconnect(
                                                            user.uid!,
                                                            FirebaseConstants
                                                                .firebaseAuth
                                                                .currentUser!
                                                                .uid);
                                                  } else {
                                                    print("Null User");
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: buildText(
                                                      text: "Connected",
                                                      txtSize: 12,
                                                      color: Colors.black),
                                                ));
                                          }
                                        }

                                        return const SizedBox();
                                      });
                                }

                                return InkWell(
                                    onTap: () async {
                                      UserModel? mySelf =
                                          await ProfileController()
                                              .fetchUserProfile();
                                      if (mySelf != null) {
                                        ConnectionController()
                                            .acceptRequest(user, mySelf);
                                      } else {
                                        print("Null User");
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: buildText(
                                          text: "Accept",
                                          txtSize: 12,
                                          color: Colors.black),
                                    ));
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
                    }),
              ))
        ],
      ),
    );
  }
}
