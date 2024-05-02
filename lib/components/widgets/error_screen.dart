import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';

class ErrorScreen extends StatelessWidget {
  String error;
  Icon errorIcon;
  ErrorScreen({super.key, required this.error, required this.errorIcon});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                errorIcon,
                SizedBox(
                  child: buildText(
                      text: error, txtSize: 12, color: AppColors.kFillColor),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
