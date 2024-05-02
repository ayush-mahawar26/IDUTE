import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/widgets/custom_group_card.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/components/widgets/user_tile.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/user_model.dart';

class GroupSearch extends StatefulWidget {
  const GroupSearch({super.key});

  @override
  State<GroupSearch> createState() => _GroupSearchState();
}

class _GroupSearchState extends State<GroupSearch> {
  TextEditingController searchText = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseConstants.store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    searchText.text = value;
                  });
                },
                cursorColor: AppColors.kFillColor,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(),
                decoration: InputDecoration(
                    hintText: "Search People",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/icons/search.svg",
                        height: 20,
                        width: 20,
                      ),
                    ),
                    hintStyle:
                        Theme.of(context).textTheme.bodySmall!.copyWith(),
                    filled: true,
                    fillColor: AppColors.kPrimaryColor2,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 1, color: AppColors.kFillColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 1, color: AppColors.kFillColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 1, color: AppColors.kFillColor))),
              ),
              (searchText.text.trim().isNotEmpty)
                  ? Expanded(
                      child: StreamBuilder(
                          stream: FirebaseConstants.store
                              .collection("Groups")
                              .orderBy("title")
                              .startAt([searchText.text]).endAt(
                                  ["${searchText.text}\uf8ff"]).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.none ||
                                snapshot.hasError) {
                              return ErrorScreen(
                                  error: "Some Network Issue",
                                  errorIcon: const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 20,
                                  ));
                            }

                            if (snapshot.hasData) {
                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  lst = snapshot.data!.docs;

                              if (lst.isEmpty) {
                                return Center(
                                  child: buildText(text: "No Group found"),
                                );
                              }

                              return ListView.builder(
                                  itemCount: lst.length,
                                  itemBuilder: (context, index) {
                                    GroupModel group =
                                        GroupModel.fromMap(lst[index].data());
                                    return CustomGroupCard(group: group);
                                  });
                            }

                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.kFillColor,
                              ),
                            );
                          }))
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
