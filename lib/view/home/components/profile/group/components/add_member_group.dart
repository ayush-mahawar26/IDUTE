import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/group_controller.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/user_model.dart';

class AddMember extends StatefulWidget {
  GroupModel group;
  AddMember({super.key, required this.group});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  String _searchcontroller = "";
  List<String> memberList = [];

  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;
  final FirebaseFirestore _store = FirebaseConstants.store;

  _allUsersTile(UserModel user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            (user.profileImage == null || user.profileImage!.isEmpty)
                ? const CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      size: 24,
                    ),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImage!),
                    radius: 30,
                  ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                    text: user.username!,
                    txtSize: 12,
                    fontWeight: FontWeight.w500),
                buildText(
                    text: user.category!,
                    color: AppColors.kFillColor,
                    txtSize: 12,
                    fontWeight: FontWeight.w500)
              ],
            ),
          ],
        ),
        StreamBuilder(
            stream: _store
                .collection("Groups")
                .doc(widget.group.groupId)
                .collection("requested")
                .where("uid", isEqualTo: user.uid!)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                    snapshot.data!.docs;
                if (data.isEmpty) {
                  return SizedBox(
                    height: 30,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                AppColors.kBackgroundColor),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)))),
                        onPressed: () async {
                          await GroupController().sendInviteToUser(
                              FirebaseConstants.firebaseAuth.currentUser!.uid,
                              user,
                              widget.group);
                        },
                        child: buildText(text: "Invite")),
                  );
                } else {
                  return ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.kcardColor),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)))),
                      onPressed: () async {},
                      child: buildText(text: "Invited"));
                }
              }

              if (snapshot.hasError) {}

              return const Center(
                child: CircularProgressIndicator(),
              );
            })
      ]),
    );
  }

  void getAllCurrentMembersList() async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseConstants.store
        .collection("Groups")
        .doc(widget.group.groupId)
        .collection("members")
        .get();
    for (int i = 0; i < data.docs.length; i++) {
      memberList.add(data.docs[i].id);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllCurrentMembersList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _searchcontroller = value;
                });
              },
              cursorColor: AppColors.kFillColor,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: "Search People",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/icons/search.svg",
                      height: 20,
                      width: 20,
                    ),
                  ),
                  hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(),
                  filled: true,
                  fillColor: AppColors.kPrimaryColor2,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
            Expanded(
              child: (_searchcontroller.isEmpty)
                  ? const SizedBox()
                  : StreamBuilder(
                      stream: FirebaseConstants.store
                          .collection("Users")
                          .orderBy("username")
                          .startAt([_searchcontroller.toLowerCase()]).endAt([
                        "${_searchcontroller.toLowerCase()}\uf8ff"
                      ]).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              snap = snapshot.data!.docs;
                          return ListView.builder(
                              itemCount: snap.length,
                              itemBuilder: (context, index) {
                                if (memberList.contains(snap[index].id)) {
                                  return const SizedBox();
                                } else {
                                  UserModel user =
                                      UserModel.fromMap(snap[index].data());
                                  return _allUsersTile(user);
                                }
                              });
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: buildText(text: "Connection issue"),
                          );
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
            )
          ],
        ),
      )),
    );
  }
}
