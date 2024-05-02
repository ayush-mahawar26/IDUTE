import 'dart:io';

import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';

class CustomButton {
  Widget customLabelButton(
      {required BuildContext context,
      required String text,
      required double width,
      required Function onPress,
      required Color bgColor}) {
    return SizedBox(
        width: width,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(bgColor)),
            onPressed: () => onPress(),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: buildText(text: text))));
  }

  Widget loadingButton(
      {required BuildContext context,
      required double width,
      required Color bgColor}) {
    return SizedBox(
        width: width,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(bgColor)),
            onPressed: () {},
            child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: CircularProgressIndicator(
                  color: AppColors.kPrimaryColor,
                ))));
  }

  Widget squareIconButton(
      {required BuildContext context,
      required String text,
      required Widget icon,
      required double width,
      required double borderRadius,
      required Function onPress,
      required Color bgColor}) {
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        width: width,
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              width: 2,
            ),
            buildText(text: text, txtSize: 12, color: Colors.white)
          ],
        ),
      ),
    );
  }

  Widget squareTextButton(
      {required BuildContext context,
      required String text,
      required double width,
      required double borderRadius,
      required Function onPress,
      required Color bgColor}) {
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
          height: 35,
          width: width,
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(borderRadius)),
          child: Center(
              child: buildText(text: text, txtSize: 12, color: Colors.white))),
    );
  }

  Widget customIconButton(
      {required BuildContext context,
      required String text,
      required Widget icon,
      required double width,
      required Function onPress,
      required Color bgColor}) {
    return SizedBox(
        width: width,
        child: ElevatedButton.icon(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                side: MaterialStateProperty.all(
                    BorderSide(width: 1, color: AppColors.kHintColor)),
                backgroundColor: MaterialStateProperty.all(bgColor)),
            onPressed: () => onPress(),
            icon: icon,
            label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: buildText(
                    text: text,
                    color: AppColors.sBackgroundColor,
                    fontWeight: FontWeight.w500))));
  }
}
