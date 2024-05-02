import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/view/home/components/profile/group/components/join_startup.dart';
import 'package:idute_app/view/home/components/profile/group/components/my_startup.dart';
import 'package:idute_app/view/home/components/profile/group/components/search_group.dart';

class Group1 extends StatefulWidget {
  Group1({super.key});

  @override
  State<Group1> createState() => _Group1State();
}

class _Group1State extends State<Group1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildText(text: "Startup & Teamup", txtSize: 20),
      ),
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
            child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                      icon: buildText(
                    text: "Join Startup",
                  )),
                  Tab(
                      icon: buildText(
                    text: "My Startup",
                  )),
                ]),
            const Expanded(
              child: TabBarView(children: [
                JoinStartUp(),
                MyStartUp(),
              ]),
            )
          ],
        )),
      ),
    );
  }
}
