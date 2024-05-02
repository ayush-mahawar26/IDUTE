import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/view/home/home.dart';
import 'package:idute_app/view/profile/components/dp/dp.dart';
import 'package:idute_app/view/profile/components/posts/profile_posts.dart';
import 'package:idute_app/view/profile/components/posts/user_reaction.dart';
import 'package:idute_app/view/profile/firstcontainer_visitprofile.dart';
import 'package:idute_app/view/profile/usergroups.dart';

class VisitUserProfile extends StatelessWidget {
  UserModel userModel;
  VisitUserProfile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: AppColors.sBackgroundColor,
          // backgroundColor: Colors.black,
          toolbarHeight: 165,
          flexibleSpace: Container(
            // height: 500,
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth * 0.023, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (route) => false);
                        },
                        child: SvgPicture.asset("assets/icons/back.svg")),
                    const SizedBox(width: 15),
                    buildText(text: userModel.username!)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.screenWidth * 0.02),
                  child: DP(userModel: userModel),
                )
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // SliverAppBar(
            //   toolbarHeight: SizeConfig.screenWidth * 0.26,
            //   title: DP(userModel: userModel),
            //   // const SizedBox(height: 10),
            // ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 0.023,
                ),
                child: FirstContainerVisitProfile(
                  userModel: userModel,
                ),
              ),
            ])),
          ],
          body: Column(
            children: [
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const TabBar(
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.only(
                          left: 0,
                          right: 15,
                        ),
                        // dividerHeight: 2,
                        overlayColor:
                            MaterialStatePropertyAll(Color(0x00000000)),
                        labelStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        indicatorColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(
                            text: "Posts",
                          ),
                          Tab(
                            text: "Groups",
                          ),
                          Tab(
                            text: "Reaction",
                          )
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ProfilePosts(
                              useruid: userModel.uid!,
                            ),
                            UserGroups(userUid: userModel.uid!),
                            UserReactedPostView(useruid: userModel.uid!),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
