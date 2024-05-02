import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';

class CustomChip {
  Widget customChip(
      {required Widget text,
      required double horizontalPadding,
      required double borderRadius,
      required double verticalPadding}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.kcardColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(width: 1, color: AppColors.kHintColor)),
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: text),
    );
  }

  Widget progressStatusChip(
      {required String levelName,
      required int currentLevel,
      required int realLevel,
      required double borderRadius}) {
    // current level -> Index Value
    // real level -> level of group that fetch from firebase

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      decoration: BoxDecoration(
        color: (currentLevel <= realLevel)
            ? AppColors.kBackgroundColor
            : Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildText(
                  text: levelName,
                  txtSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              const SizedBox(
                width: 5,
              ),
              (currentLevel < realLevel)
                  ? const Icon(
                      Icons.check,
                      size: 15,
                      color: Colors.black,
                    )
                  : ((currentLevel == realLevel)
                      ? const Icon(
                          Icons.repeat_rounded,
                          size: 15,
                          color: Colors.black,
                        )
                      : const SizedBox()),
            ],
          )),
    );
  }
}
