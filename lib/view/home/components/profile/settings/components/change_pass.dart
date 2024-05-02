import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/constants/urls.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/utils/firebase_utils.dart';

class ChangePasswordView extends StatefulWidget {
  bool loogedIn;
  ChangePasswordView({super.key, required this.loogedIn});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.screenWidth / 2,
              ),
              buildText(
                  text: "Enter your email to send password reset link",
                  txtSize: 12),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.bodySmall!.copyWith(),
                controller: _emailController,
                decoration: InputDecoration(
                    fillColor: AppColors.kcardColor,
                    filled: true,
                    hintText: "Enter your email",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.kFillColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none)),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.kBackgroundColor),
                  ),
                  onPressed: () async {
                    if (_emailController.text.trim().isNotEmpty &&
                        UrlConstants.emailRegex
                            .hasMatch(_emailController.text.trim())) {}
                  },
                  child: buildText(text: "Send link", txtSize: 15))
            ],
          ),
        ),
      ),
    );
  }
}
