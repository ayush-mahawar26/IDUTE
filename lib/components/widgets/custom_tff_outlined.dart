import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';

import '../constants/size_config.dart';

Widget buildNewTextFormField({
  required TextEditingController controller,
  required double height,
  required double width,
  required TextInputType keyboardType,
  required String hintText,
  required String errorText,
  Color bgColor = AppColors.kcardColor,
  Color brColor = const Color(0xFF939393),
  Color htColor = const Color(0xFFB6B6B6),
  IconData icon = Icons.abc,
  bool isSuffixIconVisible = false,
  IconData suffixIcon = Icons.abc,
  VoidCallback? onIconPressed,
  ValueChanged<String>? onChanged,
}) {
  return SizedBox(
    height: getProportionateScreenHeight(height),
    width: getProportionateScreenWidth(width),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      minLines: null,
      maxLines: 10,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: bgColor,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12,
          color: htColor,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: brColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: brColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: brColor,
          ),
        ),
        focusColor: brColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: brColor,
          ),
        ),
        isCollapsed: true,
        contentPadding: EdgeInsets.only(
          top: getProportionateScreenHeight(10),
          bottom: getProportionateScreenHeight(10),
          left: getProportionateScreenWidth(10),
        ),
        suffixIcon: Visibility(
          visible: isSuffixIconVisible,
          child: IconButton(
            splashRadius: 2,
            color: Colors.white,
            onPressed: onIconPressed,
            icon: Icon(
              suffixIcon,
              size: getProportionateScreenWidth(15),
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}
