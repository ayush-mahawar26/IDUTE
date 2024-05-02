import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/size_config.dart';

Widget buildAppBarIcon({required VoidCallback onTap}) {
  return Padding(
    padding: EdgeInsets.only(
      left: getProportionateScreenWidth(10),
    ),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: getProportionateScreenHeight(34),
        height: getProportionateScreenWidth(34),
        decoration: const ShapeDecoration(
          shape: OvalBorder(
            side: BorderSide(width: 1, color: Color(0xFF4E4E4E)),
          ),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.kPrimaryColor,
        ),
      ),
    ),
  );
}
