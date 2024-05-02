import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/constants/urls.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/components/widgets/suggestion.widget.dart';
import 'package:idute_app/components/widgets/user_tile.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/bottombar_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/state/bottombar_states.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/view/home/components/main/components/search_user.dart';
import 'package:idute_app/view/home/home.dart';
import 'package:idute_app/view/profile/visit_profile.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  List<UserModel> usersFromContacts = [];

  bool changed = false;
  bool havePermission = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkHaveContacts();
  }

  checkHaveContacts() async {
    havePermission = await ProfileController().didGavePermissionOfContact();

    List<UserModel>? user = await ProfileController().getUserFromContact();

    if (user == null || user.isEmpty) {
      haveContacts = false;
    }
    setState(() {});
  }

  bool haveContacts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: const BottomBarWidget(),
      backgroundColor: AppColors.sBackgroundColor,
      body: BlocBuilder<LandingPageCubit, LandingPageState>(
        builder: (context, state) {
          return (!changed)
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigator.of(context).pop();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                    (route) => false);
                              },
                              child: SvgPicture.asset("assets/icons/back.svg"),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            buildText(text: "Search", txtSize: 20)
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SearchUserView()));
                          },
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _searchController.text = value;
                              });
                            },
                            enabled: false,
                            cursorColor: AppColors.kFillColor,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(),
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
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (havePermission)
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: buildText(
                                            text: "Suggestion from contacts",
                                            txtSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            buildText(
                                                text: "Sync Contacts",
                                                txtSize: 12),
                                            InkWell(
                                              onTap: () async {
                                                await ProfileController()
                                                    .getUserFromContact();
                                              },
                                              child: buildText(
                                                  text: "Sync",
                                                  txtSize: 12,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder(
                                    future: ProfileController()
                                        .getUserFromContact(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return SuggestionCardWidget(
                                            secText: "No Contacts Available",
                                            list: snapshot.data!,
                                            aboveText: "Suggestion");
                                      }

                                      if (snapshot.hasError) {
                                        return buildText(
                                            text: "Error", txtSize: 12);
                                      }

                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: buildText(
                                      text: "More Suggestions",
                                      txtSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder(
                                    future: ProfileController().getAllUsers(),
                                    builder: (context, snapshot) {
                                      print(snapshot.data);
                                      if (snapshot.hasData) {
                                        return SuggestionCardWidget(
                                            secText: "No users left",
                                            list: snapshot.data!,
                                            aboveText: "Suggestion");
                                      }

                                      if (snapshot.hasError) {
                                        print(snapshot.error);
                                        return buildText(text: "Error");
                                      }

                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : UrlConstants.bottombarWidgets[state.tabIndex];
        },
      ),
    );
  }
}
