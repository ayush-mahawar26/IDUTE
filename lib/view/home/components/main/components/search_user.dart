import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/components/widgets/user_tile.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/view/profile/visit_profile.dart';

class SearchUserView extends StatefulWidget {
  const SearchUserView({super.key});

  @override
  State<SearchUserView> createState() => _SearchUserViewState();
}

class _SearchUserViewState extends State<SearchUserView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, right: 0, left: 10),
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset("assets/icons/back.svg")),
        ),
        title: TextFormField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _searchController.text = value;
            });
          },
          cursorColor: AppColors.kFillColor,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: "Search People",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  "assets/icons/search.svg",
                  height: 20,
                  color: Colors.grey,
                  width: 20,
                ),
              ),
              enabled: true,
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: (_searchController.text.trim().isNotEmpty)
            ? StreamBuilder(
                stream: FirebaseConstants.store
                    .collection("Users")
                    .orderBy("username")
                    .startAt([_searchController.text.toLowerCase()]).endAt([
                  "${_searchController.text.toLowerCase()}\uf8ff"
                ]).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none ||
                      snapshot.hasError) {
                    return ErrorScreen(
                        error: "Some Network Issue",
                        errorIcon: const Icon(
                          Icons.error,
                          size: 20,
                        ));
                  }

                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> lst =
                        snapshot.data!.docs;

                    if (lst.isEmpty) {
                      return Center(
                        child: buildText(text: "No user found"),
                      );
                    }

                    return ListView.builder(
                        itemCount: lst.length,
                        itemBuilder: (context, index) {
                          UserModel user = UserModel.fromMap(lst[index].data());
                          return (user.uid! ==
                                  FirebaseConstants
                                      .firebaseAuth.currentUser!.uid)
                              ? const SizedBox()
                              : InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VisitUserProfile(
                                                  userModel: user,
                                                )));
                                  },
                                  child: userTile(userModel: user));
                        });
                  }

                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kFillColor,
                    ),
                  );
                })
            : const SizedBox(),
      ),
    ));
  }
}
