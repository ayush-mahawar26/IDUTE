import 'package:flutter/material.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';

class CustomSnackBar {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      {required BuildContext context,
      required String text,
      required Color color,
      required Duration duration}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: buildText(text: text, txtSize: 12),
      backgroundColor: color,
      duration: duration,
    ));
  }
}
