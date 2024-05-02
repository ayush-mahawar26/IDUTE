import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/custom.buttons.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/view/auth/auth_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.sBackgroundColor,
        body: SafeArea(
          child: SizedBox(
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: buildText(text: "IDUTE", txtSize: 22),
                  ),
                  Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/images/phn_img.png",
                          height: SizeConfig.screenHeight / 2,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenHeight / 2,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              AppColors.sBackgroundColor
                            ])),
                      )
                    ],
                  ),
                  Center(
                    child: SizedBox(
                        width: SizeConfig.screenWidth - 100,
                        child: buildText(
                            text: "An app for intellects and Entrepreneurs",
                            fontWeight: FontWeight.w700,
                            txtSize: 29)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                        width: SizeConfig.screenWidth - 30,
                        child: buildText(
                            text:
                                "The ultimate task management app designed to streamline your workflow and supercharge your productivity",
                            color: AppColors.kFillColor,
                            txtSize: 12,
                            maxLine: 10)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton().customLabelButton(
                      context: context,
                      text: "Get Started",
                      width: SizeConfig.screenWidth - 20,
                      onPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => AuthView()),
                        );
                      },
                      bgColor: AppColors.kBackgroundColor)
                ],
              ),
            ),
          ),
        ));
  }
}
