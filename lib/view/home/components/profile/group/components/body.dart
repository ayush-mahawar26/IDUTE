import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/custom_group_card.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';

import '../../../../../../components/widgets/step_progress_view.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetails(),
        buildSizeHeight(height: 10),
        _buildSpotlights(),
        buildSizeHeight(height: 15),
        const Divider(
          color: Colors.black,
          thickness: 2,
          height: 0,
        ),

        buildSizeHeight(height: 14),
        // _buildAllyCard(),
      ],
    ));
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              buildText(
                text: "My Startup",
                txtSize: 12,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                iconSize: 17,
                icon: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const CircleAvatar(
                radius: 23.5,
                backgroundImage: AssetImage(
                  "assets/images/grp_startup.png",
                ),
              ),
              buildSizeWidth(width: 14),
              Expanded(
                child: buildText(
                  text:
                      "Individual development significant effect defining a clear plan to hope ",
                  txtSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              buildSizeWidth(width: 22),
            ],
          ),
          buildSizeHeight(height: 14),
          Padding(
            padding: const EdgeInsets.only(right: 21),
            child: buildText(
              text:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam congue quis quam et imperdiet. Nam vel gravida neque. Curabitur maximus est luctus nibh tempor, sodales efficitur nisl blandit. Etiam ullamcorper, ex hendrerit laoreet ",
              color: AppColors.kHintColor,
              txtSize: 11,
              maxLine: 5,
              fontWeight: FontWeight.w300,
            ),
          ),
          buildSizeHeight(height: 11),
          buildText(
            text: "Progress",
            txtSize: 12,
            fontWeight: FontWeight.w500,
          ),
          buildSizeHeight(height: 7),
          const StepProgressView(
            curStep: 3,
            titles: [
              "Concept",
              "Business Model",
              "Revenue Model",
              "Marketing Strategy",
              "Launching Strategy"
            ],
            width: 200,
            color: Color(0xFF007A5A),
          ),
          buildSizeHeight(height: 15),
          buildText(
            text: "Spotlights",
            txtSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  SizedBox _buildSpotlights() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 14),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 11),
            child: CircleAvatar(
              backgroundImage:
                  AssetImage("assets/images/grp_s_${index + 1}.png"),
              radius: 25,
            ),
          );
        },
      ),
    );
  }

//   Expanded _buildAllyCard() {
//     return Expanded(
//       child: ListView.builder(
//         padding: const EdgeInsets.only(left: 14),
//         shrinkWrap: true,
//         itemCount: 10,
  // itemBuilder: (context, index) {
//           return const Padding(
//             padding: EdgeInsets.only(right: 26, left: 6, bottom: 8),
//             child: CustomGroupCard(),
//           );
//         },
//       ),
//     );
//   }
}
