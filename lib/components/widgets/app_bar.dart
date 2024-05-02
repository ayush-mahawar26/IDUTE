import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';

AppBar buildAppBar({required String title, required VoidCallback onTap}) {
  return AppBar(
    surfaceTintColor: AppColors.sBackgroundColor,
    automaticallyImplyLeading: false,
    leadingWidth: 0,
    titleSpacing: 0,
    title: Row(
      children: [
        // buildAppBarIcon(onTap: onTap),
        buildSizeWidth(width: 12),
        buildText(
          text: title,
          txtSize: 20,
          letterSpacing: 1.3,
        ),
      ],
    ),
  );
}
