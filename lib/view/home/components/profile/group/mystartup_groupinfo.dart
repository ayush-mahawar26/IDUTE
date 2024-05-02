import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/app_bar.dart';
import 'package:idute_app/components/widgets/custom_chip.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/group_controller.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/progress_model.dart';
import 'package:idute_app/view/home/components/profile/group/components/core_team.dart';
import 'package:idute_app/view/home/components/profile/group/components/req_member.dart';

class MyStartUpGroupInfo extends StatefulWidget {
  GroupModel groupInfo;
  MyStartUpGroupInfo({super.key, required this.groupInfo});

  @override
  State<MyStartUpGroupInfo> createState() => _MyStartUpGroupInfoState();
}

class _MyStartUpGroupInfoState extends State<MyStartUpGroupInfo> {
  List<String> progress = [
    "Concept",
    "Buisness Model",
    "Revenue Model",
    "Product",
    "Launch Strategy",
    "Marketing Strategy"
  ];

  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;

  List<GroupProgressModel> groupModel = [
    GroupProgressModel(progress: "Concept", status: "done"),
    GroupProgressModel(progress: "Buidness Model", status: "done"),
    GroupProgressModel(progress: "Revenue Model", status: "done"),
    GroupProgressModel(progress: "Product", status: "ongoing"),
    GroupProgressModel(progress: "Launch strategy"),
    GroupProgressModel(progress: "Concept"),
  ];

  Widget _description(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText(text: "Description"),
          const SizedBox(
            height: 5,
          ),
          buildText(text: text, txtSize: 12),
        ],
      ),
    );
  }

  _progressStatusChip(int index, GroupModel groupData) {
    return (groupData.createdBy == _auth.currentUser!.uid)
        ? InkWell(
            onTap: () async {
              GroupController().updateLevelOfGroup(widget.groupInfo, index);
            },
            child: CustomChip().progressStatusChip(
                levelName: progress[index],
                currentLevel: index,
                realLevel: groupData.level,
                borderRadius: 10),
          )
        : CustomChip().progressStatusChip(
            levelName: progress[index],
            currentLevel: index,
            realLevel: groupData.level,
            borderRadius: 10);
  }

  Widget _groupProgress() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText(text: "Progress"),
          const SizedBox(
            height: 5,
          ),
          StreamBuilder(
              stream: FirebaseConstants.store
                  .collection("Groups")
                  .doc(widget.groupInfo.groupId!)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  GroupModel group = GroupModel.fromMap(snapshot.data!.data()!);
                  return Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      _progressStatusChip(0, group),
                      _progressStatusChip(1, group),
                      _progressStatusChip(2, group),
                      _progressStatusChip(3, group),
                      _progressStatusChip(4, group),
                      _progressStatusChip(5, group),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: buildText(text: "Error Occured !"),
                  ));
                }

                return const Center(
                    child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(),
                ));
              }),
          const SizedBox(
            height: 10,
          ),
          notifyButton(() {}),
          const SizedBox(
            height: 5,
          ),
          buildText(text: "Notify team to active", txtSize: 12)
        ],
      ),
    );
  }

  Widget _spotLight() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText(text: "Spotlight"),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return CircleAvatar(
                  backgroundImage:
                      AssetImage("assets/images/grp_s_${index + 1}.png"),
                  radius: 35,
                );
              },
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  Widget notifyButton(Function onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40,
            decoration: const BoxDecoration(
                color: AppColors.kcardColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: buildText(text: "8:00 PM", txtSize: 15),
            )),
          ),
          const SizedBox(
            width: 2,
          ),
          Container(
            height: 40,
            decoration: const BoxDecoration(
                color: AppColors.kcardColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoAppBar(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: SizeConfig.screenWidth,
          height: 120,
          child: Stack(
            children: [
              Image.asset(
                "assets/images/group_bg.png",
                width: SizeConfig.screenWidth,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 35,
                left: 10,
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(
                        "assets/images/grp_startup.png",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        // Probelem Statement - Of start up
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.8,
                          child: buildText(text: widget.groupInfo.title),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.black,
          thickness: 3,
          height: 20,
        ),
        _description(widget.groupInfo.description),
        const Divider(
          color: Colors.black,
          thickness: 3,
          height: 18,
        ),
        _groupProgress(),
        const Divider(
          color: Colors.black,
          thickness: 3,
          height: 19,
        ),
        _spotLight(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
          title: "Group Info",
          onTap: () {
            Navigator.pop(context);
          }),
      body: SafeArea(
          child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, isScolled) {
            return [
              // SliverAppBar(
              //   backgroundColor: AppColors.sBackgroundColor,
              // ),
              SliverList(
                  delegate: SliverChildListDelegate([
                _infoAppBar(context),
                _infoHeader(context),
              ]))
            ];
          },
          body: (widget.groupInfo.createdBy == _auth.currentUser!.uid)
              ? Column(
                  children: [
                    Expanded(
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            const TabBar(
                              indicatorColor: Colors.white,
                              labelColor: Colors.white,
                              indicatorSize: TabBarIndicatorSize.tab,
                              unselectedLabelColor: AppColors.kHintColor,
                              tabs: [
                                Tab(text: "Core Team"),
                                Tab(text: "Request"),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  CoreTeam(
                                    group: widget.groupInfo,
                                  ),
                                  RequestAvailable(
                                    groupModel: widget.groupInfo,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: buildText(
                          text: "Core Members",
                          fontWeight: FontWeight.bold,
                          txtSize: 20),
                    ),
                    Expanded(child: CoreTeam(group: widget.groupInfo))
                  ],
                ),
        ),
      )),
    );
  }
}
