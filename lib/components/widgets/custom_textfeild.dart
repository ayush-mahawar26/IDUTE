import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';

class CustomTextFeild {
  Widget customTextFeild(String label, TextEditingController controller,
      BuildContext context, String path) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(width: 2, color: AppColors.kHintColor)),
      child: TextFormField(
        controller: controller,
        cursorColor: AppColors.kBackgroundColor,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: AppColors.sBackgroundColor),
        decoration: InputDecoration(
            border: InputBorder.none,
            labelText: label,
            labelStyle: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: AppColors.kFillColor),
            // hintText: "Email",
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                path,
              ),
            )),
      ),
    );
  }
}
