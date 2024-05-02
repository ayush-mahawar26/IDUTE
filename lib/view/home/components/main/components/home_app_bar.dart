import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/widgets/app_bar_icon.dart';

import '../../../../../components/widgets/normal_text_widget.dart';

AppBar homeAppBar({
  bool isTitle = true,
  VoidCallback? backFunc,
  VoidCallback? onTap,
  VoidCallback? searchTap,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    // leadingWidth: 0,
    scrolledUnderElevation: 0,
    titleSpacing: 0,
    title: isTitle
        ? Padding(
            padding: const EdgeInsets.only(left: 24),
            child: buildText(
              text: 'IDUTE',
              txtSize: 20,
              fontWeight: FontWeight.w400,
            ),
          )
        : buildAppBarIcon(onTap: backFunc!),
    actions: [
      IconButton(
        onPressed: searchTap,
        icon: SvgPicture.asset("assets/icons/top_1.svg"),
      ),
      IconButton(
        onPressed: onTap,
        icon: SvgPicture.asset("assets/icons/top_2.svg"),
      ),
    ],
  );
}
