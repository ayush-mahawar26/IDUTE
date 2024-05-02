import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/widgets/custom_cont_text.dart';
import 'package:idute_app/components/widgets/group_bottomsheet.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/model/group_model.dart';

import '../constants/colors.dart';
import '../constants/size_config.dart';

class CustomGroupCard extends StatelessWidget {
  final GroupModel group;
  final bool? isjoinStartUp;
  const CustomGroupCard(
      {super.key, required this.group, this.isjoinStartUp = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        color: AppColors.sBackgroundColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xff2B2B2B)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildUpperCard(),
            _buildLowerCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUpperCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/grp_card.png"),
            radius: 35,
          ),
          buildSizeWidth(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: buildText(
                    text: group.title,
                    txtSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                buildSizeHeight(height: 5),
                buildText(
                  text: group.description,
                  txtSize: 10,
                  fontWeight: FontWeight.w400,
                  maxLine: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildLowerCard(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          // _buildDivider(),
          _buildBottomPart(context),
          _buildStartedRow(),
        ],
      ),
    );
  }

  Positioned _buildDivider() {
    return const Positioned(
      child: Divider(
        color: Color(0xff2b2b2b),
      ),
    );
  }

  Align _buildBottomPart(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 60,
        decoration: const ShapeDecoration(
          color: AppColors.kcardColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Color(0xff383838),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildSizeWidth(width: 10),
                const SizedBox(
                  width: 55,
                  child: Stack(
                    children: [
                      Positioned(
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/images/grp_1.png",
                          ),
                          radius: 12.5,
                        ),
                      ),
                      Positioned(
                        left: 8,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/images/grp_2.png",
                          ),
                          radius: 12.5,
                        ),
                      ),
                      Positioned(
                        left: 10 + 8,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/images/grp_3.png",
                          ),
                          radius: 12.5,
                        ),
                      ),
                      Positioned(
                        left: 12 + 10 + 8,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/images/grp_4.png",
                          ),
                          radius: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                buildSizeWidth(width: 5),
                (!isjoinStartUp!)
                    ? buildText(
                        text: "Core Team",
                        txtSize: 12,
                        fontWeight: FontWeight.w500,
                      )
                    : buildText(
                        text: "30+ Requests",
                        // color: AppColors.kBackgroundColor,
                        txtSize: 12,
                        // fontWeight: FontWeight.w500,
                      ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildText(
                      text: "Founder",
                      txtSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.kHintColor,
                    ),
                    buildText(
                      text: group.createdByName,
                      txtSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                buildSizeWidth(width: 20),
                GestureDetector(
                  onTap: () {
                    _showBottonSheet(context, group);
                  },
                  child: SvgPicture.asset(
                    "assets/icons/card_1.svg",
                    width: 25,
                    height: 25,
                  ),
                ),
                buildSizeWidth(width: 4),
              ],
            ),
            buildSizeHeight(height: 7),
          ],
        ),
      ),
    );
  }

  _showBottonSheet(BuildContext context, GroupModel model) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.sBackgroundColor,
      builder: (BuildContext context) {
        return GroupInfoBottomSheet(
          model: model,
        );
      },
    );
  }

  Positioned _buildStartedRow() {
    return Positioned(
      right: 8,
      top: 2,
      bottom: 0,
      child: Column(
        children: [
          buildContainerText(
            width: 110,
            height: 21,
            borderColor: Colors.black,
            contColor: const Color(0xffEAEAEA),
            radSize: 20,
            text:
                "Started: ${group.createdAt.toDate().day}/${group.createdAt.toDate().month}/${group.createdAt.toDate().year}",
            txtSize: 10,
            txtColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
