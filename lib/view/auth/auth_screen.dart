import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/view/auth/auth_component/login.dart';
import 'package:idute_app/view/auth/auth_component/register.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sBackgroundColor,
      bottomNavigationBar: null,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Row(
                      children: [SvgPicture.asset("assets/icons/back.svg")],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: buildText(
                      text: "Go ahead and set up your account",
                      txtSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: buildText(
                        text:
                            "Sign in-up to enjoy the best managing experience",
                        txtSize: 12,
                        color: AppColors.kFillColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: AppColors.kSecondaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(31),
                          topRight: Radius.circular(31))),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: SizeConfig.screenWidth * 0.13),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.screenWidth)),
                          // height: 50,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: TabBar(
                              indicator: BoxDecoration(
                                color: AppColors.kSecondaryColor,
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.screenWidth),
                              ),
                              dividerColor: Colors.grey[400],
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabs: [
                                Tab(
                                    icon: buildText(
                                        text: "Login",
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.sBackgroundColor)),
                                Tab(
                                    icon: buildText(
                                        text: "Register",
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.sBackgroundColor)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                          child: TabBarView(
                        children: [LoginWidget(), RegisterWidget()],
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
