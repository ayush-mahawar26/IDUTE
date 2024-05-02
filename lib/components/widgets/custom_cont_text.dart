import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/size_config.dart';
import 'normal_text_widget.dart';

Container buildContainerText({
  String text = "",
  double txtSize = 12,
  double radSize = 12,
  double width = 50,
  double height = 50,
  double borderWidth = 1,
  double padd = 0,
  Color txtColor = AppColors.kPrimaryColor,
  Color contColor = AppColors.kPrimaryColor,
  Color borderColor = AppColors.kPrimaryColor,
}) {
  return Container(
    width: getProportionateScreenWidth(width),
    height: getProportionateScreenHeight(height),
    decoration: ShapeDecoration(
      color: contColor,
      shape: RoundedRectangleBorder(
        // side: BorderSide(
        //   width: borderWidth,
        //   color: borderColor,
        // ),
        borderRadius: BorderRadius.circular(radSize),
      ),
    ),
    child: Center(
      child: Padding(
        padding: EdgeInsets.all(padd),
        child: buildText(
          text: text,
          color: txtColor,
          txtSize: txtSize,
        ),
      ),
    ),
  );
}
