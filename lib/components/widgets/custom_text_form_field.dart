import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import '../constants/size_config.dart';

Widget buildTextFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String hintText,
  required String errorText,
  String hint = "",
  bool isSuffixIconVisible = false,
  bool obscureText = false,
  IconData suffixIcon = Icons.abc,
  VoidCallback? onIconPressed,
  bool isFilled = false,
  bool isAuto = true,
  bool? isEnable = true,
  bool? isCollapse = false,
  ValueChanged<String>? onChanged,

  // int maxLines = 1,
}) {
  return TextFormField(
    autovalidateMode: isAuto ? AutovalidateMode.onUserInteraction : null,
    controller: controller,
    keyboardType: keyboardType,
    enabled: isEnable,
    validator: (value) {
      if (value!.isEmpty) {
        return errorText;
      } else {
        return null;
      }
    },
    style: const TextStyle(
      fontSize: (15),
      color: Colors.white,
      fontWeight: FontWeight.w400,
    ),
    // onChanged: (value) => onChanged!,
    minLines: null,
    maxLines: null,
    obscureText: obscureText,
    decoration: InputDecoration(
      isCollapsed: isCollapse,
      labelStyle: const TextStyle(
        color: AppColors.kFillColor,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      labelText: isAuto ? hintText : null,
      filled: isFilled,
      fillColor: const Color(0xFF2B2B2B),
      contentPadding: EdgeInsets.symmetric(
          vertical: !isAuto ? 20 : 10, horizontal: !isAuto ? 24 : 0),
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFFB6B6B6),
        fontWeight: FontWeight.w400,
        fontFamily: "inter",
      ),
      suffixIcon: Visibility(
        visible: isSuffixIconVisible,
        child: IconButton(
          color: Colors.white,
          onPressed: onIconPressed,
          icon: Icon(
            suffixIcon,
            size: getProportionateScreenWidth(25),
            color: Colors.white,
          ),
        ),
      ),

      // prefixIcon: Icon(
      //   icon,
      //   size: getProportionateScreenWidth(25),
      // ),
      // filled: true,
      // fillColor: AppColors.kFillColor,
      // border: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(14),
      //   borderSide: BorderSide.none,
      // ),
    ),
  );
}
