import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';

import '../constants/size_config.dart';

ListTile buildTile({
  required VoidCallback onTap,
  required String imageURL,
  required String text,
  Color color = Colors.white,
}) {
  return ListTile(
    onTap: onTap,
    dense: true,
    visualDensity: VisualDensity(vertical: -3),
    leading: SizedBox(
      width: getProportionateScreenWidth(24),
      child: SvgPicture.asset(
        imageURL,
        // width: 24,
        // height: 24,
      ),
    ),
    minLeadingWidth: 13,
    title: buildText(
      text: text,
      txtSize: 15,
      color: color,
    ),
  );
}
