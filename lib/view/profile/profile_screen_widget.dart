import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/view/profile/components/posts/profile_posts.dart';
import 'package:idute_app/view/profile/components/posts/user_reaction.dart';
import 'package:idute_app/view/profile/firstContainer.dart';
import 'package:idute_app/view/profile/usergroups.dart';

import 'components/dp/dp.dart';

class ProfileScreenWidget extends StatefulWidget {
  const ProfileScreenWidget({Key? key}) : super(key: key);

  @override
  State<ProfileScreenWidget> createState() => _ProfileScreenWidgetState();
}

class _ProfileScreenWidgetState extends State<ProfileScreenWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final borderShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50),
    side: const BorderSide(color: Colors.white, width: 1),
  );

  @override
  void initState() {
    super.initState();
    setState(() {});
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Tab _buildTabBar(String text) {
    return Tab(
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0), // Adjust spacing as needed
        child: Align(
          alignment: Alignment.center,
          child:
              buildText(text: text, txtSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder(
            stream: FirebaseConstants.store
                .collection("Users")
                .doc(FirebaseConstants.firebaseAuth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserModel userModel = UserModel.fromMap(snapshot.data!.data()!);
                return Scaffold(
                  // backgroundColor: Colors.black,
                  appBar: AppBar(
                    surfaceTintColor: AppColors.sBackgroundColor,
                    // backgroundColor: Colors.black,
                    toolbarHeight: 155,
                    flexibleSpace: Container(
                      // height: 500,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth * 0.023,
                          vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // SvgPicture.asset("assets/icons/back.svg"),
                              const SizedBox(width: 10),
                              buildText(text: userModel.username!)
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.screenWidth * 0.02),
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
                            horizontal: SizeConfig.screenWidth * 0.020,
                          ),
                          child: FirstContainer(
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
                                TabBar(
                                  controller: _tabController,
                                  padding: EdgeInsets.zero,
                                  labelPadding: const EdgeInsets.only(
                                    left: 0,
                                    right: 15,
                                  ),
                                  // dividerHeight: 2,
                                  overlayColor: const MaterialStatePropertyAll(
                                      Color(0x00000000)),
                                  labelStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  indicatorColor: Colors.white,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: const [
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
                                    controller: _tabController,
                                    children: [
                                      ProfilePosts(
                                        useruid: FirebaseConstants
                                            .firebaseAuth.currentUser!.uid,
                                      ),
                                      UserGroups(
                                        userUid: FirebaseConstants
                                            .firebaseAuth.currentUser!.uid,
                                      ),
                                      UserReactedPostView(
                                        useruid: FirebaseConstants
                                            .firebaseAuth.currentUser!.uid,
                                      )
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
                );
              }

              if (snapshot.connectionState == ConnectionState.none) {
                return Scaffold(
                  body: ErrorScreen(
                      error: "Error in Fetching Profile",
                      errorIcon: const Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 20,
                      )),
                );
              }

              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            }));
  }

  Widget custombutton(
          {required final firstContainerwidth,
          required final icon,
          required final title,
          final Color color = const Color(0xFF2b2b2b)}) =>
      SizedBox(
        height: 25,
        child: ElevatedButton(
          style: ButtonStyle(
              padding: const MaterialStatePropertyAll(
                  EdgeInsets.only(left: 15.0, right: 15.0)),
              shape: MaterialStateProperty.all(borderShape),
              backgroundColor: MaterialStateProperty.all(color)),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                icon,
                color: const Color(0xFFf2f2f2),
                size: 14,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFf2f2f2),
                ),
              ),
            ],
          ),
        ),
      );
}


////////////////////////////////////////////////////////////////

/*import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'components/dp/dp.dart';
import 'components/profile_image.dart';
import 'components/posts/profile_posts.dart';

class ProfileScreenWidget extends StatefulWidget {
  ProfileScreenWidget({Key? key}) : super(key: key);

  @override
  State<ProfileScreenWidget> createState() => _ProfileScreenWidgetState();
}

class _ProfileScreenWidgetState extends State<ProfileScreenWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final borderShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50),
    side: BorderSide(color: Colors.white, width: 1),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final firstContainerHeight = screenHeight * 0.5 - 160;
    final firstContainerwidth = screenWidth;
    final secondContainerHeight = screenHeight * 0.50;
    final secondContainerWidth = screenWidth ;
    String? profile_image = "https://media.licdn.com/dms/image/D4D03AQGFCGoRhpT2WA/profile-displayphoto-shrink_800_800/0/1686651487410?e=1708560000&v=beta&t=BGyG4JYaup9NJny-EfMdvrm2RS7hXLKJv7YrPsV2hKI";
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(160),
            child: AppBar(
              flexibleSpace: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_circle_left_outlined,
                          size: 35, ),
                        SizedBox(width: 5,),
                        Text(
                          "thepriyanshuway",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    DP(screenWidth: screenWidth, firstContainerHeight: firstContainerHeight),
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // height: firstContainerHeight,
                // width: screenWidth,
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: screenWidth * 0.03, right: screenWidth * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: screenWidth * 0.01,
                          ),
                          Text("Founder - InGelt Board",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w300)),
                          SizedBox(
                            height: firstContainerHeight * 0.01,
                          ),
                          Row(
                            children: [
                              Icon(
                                FluentIcons.hat_graduation_12_regular,
                                size: screenWidth * 0.04,
                              ),
                              SizedBox(
                                width: firstContainerwidth * 0.01,
                              ),
                              Text("Indian Institute of Technology, Delhi",
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          SizedBox(
                            height: screenWidth * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: screenWidth * 0.04,
                              ),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              Text("Noida, India",
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          SizedBox(
                            height: firstContainerHeight * 0.04,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              custombutton(
                                  firstContainerwidth: firstContainerwidth,
                                  icon: Icons.bolt_outlined,
                                  title: 'Connect',
                              color: Color(0xFF007A5A)),
                              custombutton(
                                  firstContainerwidth: firstContainerwidth,
                                  icon: Icons.chat_outlined,
                                  title: 'Chat'),
                              custombutton(
                                  firstContainerwidth: firstContainerwidth,
                                  icon: Icons.settings,
                                  title: 'Settings'),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: screenWidth,
                              ),
                              Row(
                                children: [
                                  Text("About",
                                      style: TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w700)),
                                  SizedBox(width: screenWidth*0.02,),
                                  Image(image: AssetImage('assets/icons/pencil.png'),height: 15, width: 15,),
                                ],
                              ),
                              Text(
                                "Lorem ipsum sit amet consectetur adipiscing as eilt Ut et",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),


              // second container
              Container(
                height: secondContainerHeight,
                // width: secondContainerWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: TabBar(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        tabs: [
                          Tab(
                            text: "Fortue",
                          ),
                          Tab(
                            text: "Posts",
                          ),
                          Tab(
                            text: "Group",
                          ),
                          Tab(
                            text: "Reactions",
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Center(child: Text('Content for Fortue')),
                            // add my posts here
                            Container(
                              margin: EdgeInsets.all(10),
                            child: ProfilePosts()),
                            // Center(child: Text('Content for Posts')),
                            Center(child: Text('Content for Group')),
                            Center(child: Text('Content for Reactions')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget custombutton(
          {required final firstContainerwidth,
          required final icon,
          required final title,
          final Color color = const Color(0xFF2b2b2b)}) =>
      SizedBox(
        height: 25,
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.only(left: 15.0, right: 15.0)),
              shape: MaterialStateProperty.all(borderShape),
              backgroundColor: MaterialStateProperty.all(color)),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                icon,
                color: Color(0xFFf2f2f2),
                size: 14,
              ),
              SizedBox(
                width: 3,
              ),
              Text(title,
                  style: TextStyle(fontSize: 14, color: Color(0xFFf2f2f2),),),
            ],
          ),
        ),
      );
}

*/