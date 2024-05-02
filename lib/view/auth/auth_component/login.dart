import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/custom.buttons.dart';
import 'package:idute_app/components/widgets/custom_textfeild.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/components/widgets/snackbar.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/auth_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/google_auth_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/state/auth_states.dart';
import 'package:idute_app/controller/BuisnessLogic/state/google_auth_state.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/view/auth/asking_info.dart';
import 'package:idute_app/view/home/components/profile/settings/components/change_pass.dart';
import 'package:idute_app/view/home/home.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _pass = TextEditingController();

  bool obsecure = true;

  void _togglePassword() {
    setState(() {
      obsecure = !obsecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    GoogleAuthCubit googleAuthCubit = BlocProvider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextFeild().customTextFeild(
                "Email Address", _email, context, "assets/icons/mail.svg"),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(width: 2, color: AppColors.kHintColor)),
              child: TextFormField(
                controller: _pass,
                cursorColor: AppColors.kBackgroundColor,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: AppColors.sBackgroundColor),
                obscureText: obsecure,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Password",
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.kFillColor),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        "assets/icons/password.svg",
                      ),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        _togglePassword();
                      },
                      child: (obsecure)
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset("assets/icons/eye.svg"),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset(
                                  "assets/icons/slash_eye.svg"),
                            ),
                    )),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangePasswordView(
                              loogedIn: false,
                            )));
                  },
                  child: buildText(
                      text: "Forget password ?",
                      color: AppColors.kBackgroundColor,
                      txtSize: 12),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            BlocConsumer<AuthCubit, AuthStates>(builder: (context, state) {
              if (state is LoadingAuthState) {
                return CustomButton().loadingButton(
                    context: context,
                    width: SizeConfig.screenWidth,
                    bgColor: AppColors.kBackgroundColor);
              } else {
                return CustomButton().customLabelButton(
                    context: context,
                    text: "Login",
                    width: SizeConfig.screenWidth,
                    onPress: () async {
                      String email = _email.text.trim();
                      String pass = _pass.text.trim();
                      if (email.isEmpty || pass.isEmpty) {
                        return CustomSnackBar().showSnackBar(
                            context: context,
                            text: "Fill all the details",
                            color: AppColors.errorColor,
                            duration: const Duration(milliseconds: 500));
                      } else {
                        AuthCubit authCubit = BlocProvider.of(context);
                        authCubit.loginWithEmailPassword(email, pass);
                      }
                    },
                    bgColor: AppColors.kBackgroundColor);
              }
            }, listener: (context, state) {
              if (state is DoneAuthState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false);
                CustomSnackBar().showSnackBar(
                    context: context,
                    text: "Successfully Login",
                    color: Colors.green,
                    duration: const Duration(milliseconds: 1000));
              } else if (state is ErrorAuthState) {
                print(state.err);
                CustomSnackBar().showSnackBar(
                    context: context,
                    text: state.err,
                    color: Colors.red,
                    duration: const Duration(milliseconds: 500));
              }
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: AppColors.kHintColor,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  buildText(text: "or login with", color: AppColors.kFillColor),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: AppColors.kHintColor,
                    ),
                  )
                ],
              ),
            ),
            BlocConsumer<GoogleAuthCubit, GoogleAuthStates>(
                builder: (context, state) {
              if (state is LoadingGoogleAuthState) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CustomButton().loadingButton(
                      context: context,
                      width: SizeConfig.screenWidth / 2,
                      bgColor: AppColors.kSecondaryColor),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: CustomButton().customIconButton(
                    context: context,
                    text: "Google",
                    icon: SvgPicture.asset("assets/icons/google.svg"),
                    width: SizeConfig.screenWidth / 2,
                    onPress: () async {
                      await googleAuthCubit.signInUsingGoogle();
                    },
                    bgColor: AppColors.kSecondaryColor),
              );
            }, listener: (context, state) async {
              if (state is DoneGoogleAuthState) {
                bool exist = await googleAuthCubit
                    .userExist(FirebaseConstants.firebaseAuth.currentUser!.uid);
                if (exist) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (route) => false);
                } else {
                  User user = FirebaseConstants.firebaseAuth.currentUser!;
                  UserModel userModel = UserModel(
                    name: user.displayName!,
                    email: user.email,
                    uid: user.uid,
                    isEmailVerified: true,
                    isPhoneVerified: false,
                    createdTime: Timestamp.now(),
                    connects: 0,
                    iq: 0,
                    groupId: const [],
                    profileImage: user.photoURL,
                  );
                  await googleAuthCubit.updateIntoFirebase(userModel);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => AskingDetailsView(
                                model: userModel,
                              )),
                      (route) => false);
                }
              }

              if (state is ErrorGoogleAuthState) {
                print("here is error");
              }
            })
          ],
        ),
      ),
    );
  }
}
