import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/constants/urls.dart';
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
import 'package:idute_app/view/home/home.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  bool obsecure = true;

  void _togglePassword() {
    setState(() {
      obsecure = !obsecure;
    });
  }

  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;

  @override
  Widget build(BuildContext context) {
    GoogleAuthCubit _googleAuthCubit =
        BlocProvider.of<GoogleAuthCubit>(context);
    AuthCubit _authCubit = BlocProvider.of<AuthCubit>(context);

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
                onChanged: (value) {
                  setState(() {
                    _pass.text = value;
                  });
                },
                cursorColor: AppColors.kBackgroundColor,
                validator: (value) {},
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    // hintText: "Email",

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
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: (obsecure)
                            ? SvgPicture.asset("assets/icons/eye.svg")
                            : SvgPicture.asset("assets/icons/slash_eye.svg"),
                      ),
                    )),
              ),
            ),
            (_pass.text.trim().isEmpty ||
                    RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*(),.?":{}|<>])(?=.*[0-9]).{8,}$')
                        .hasMatch(_pass.text))
                ? SizedBox()
                : buildText(
                    text:
                        "should contain A-Z , a-z , 1-9 and special character",
                    txtSize: 12,
                    color: AppColors.errorColor.shade800),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(width: 2, color: AppColors.kHintColor)),
              child: TextFormField(
                controller: _confirmPass,
                cursorColor: AppColors.kBackgroundColor,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: AppColors.sBackgroundColor),
                obscureText: obsecure,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Confirm Password",
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.kFillColor),
                    // hintText: "Email",
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
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: (obsecure)
                            ? SvgPicture.asset("assets/icons/eye.svg")
                            : SvgPicture.asset("assets/icons/slash_eye.svg"),
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 30,
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
                    text: "Register",
                    width: SizeConfig.screenWidth,
                    onPress: () async {
                      String mail = _email.text.trim();
                      String pass = _pass.text.trim();
                      String cpass = _confirmPass.text.trim();
                      if (mail.isEmpty || pass.isEmpty || cpass.isEmpty) {
                        CustomSnackBar().showSnackBar(
                            context: context,
                            text: "Fill All the Credentials",
                            color: AppColors.errorColor,
                            duration: const Duration(milliseconds: 500));
                      } else {
                        if (pass.compareTo(cpass) == 0) {
                          if (pass.length < 8) {
                            CustomSnackBar().showSnackBar(
                                context: context,
                                text: "Password length should be more than 8",
                                color: AppColors.errorColor,
                                duration: const Duration(milliseconds: 500));
                          } else if (UrlConstants.emailRegex.hasMatch(mail)) {
                            await _authCubit.createUserWithEmailPassword(
                                mail, pass);
                          } else {
                            CustomSnackBar().showSnackBar(
                                context: context,
                                text: "Provide valid email",
                                color: AppColors.errorColor,
                                duration: const Duration(milliseconds: 500));
                          }
                        } else {
                          CustomSnackBar().showSnackBar(
                              context: context,
                              text: "Passwords not matched",
                              color: AppColors.errorColor,
                              duration: const Duration(milliseconds: 500));
                        }
                      }
                    },
                    bgColor: AppColors.kBackgroundColor);
              }
            }, listener: (context, state) async {
              if (state is DoneAuthState) {
                UserModel userModel = UserModel(
                    uid: _auth.currentUser!.uid,
                    email: _auth.currentUser!.email,
                    isEmailVerified: false,
                    about: "",
                    connects: 0,
                    iq: 0,
                    createdTime: Timestamp.now(),
                    groupId: []);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => AskingDetailsView(
                              model: userModel,
                            )),
                    (route) => false);
              } else if (state is ErrorAuthState) {
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
                  buildText(
                      text: "or register with", color: AppColors.kFillColor),
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
                      await _googleAuthCubit.signInUsingGoogle();
                    },
                    bgColor: AppColors.kSecondaryColor),
              );
            }, listener: (context, state) async {
              if (state is DoneGoogleAuthState) {
                bool exist = await _googleAuthCubit
                    .userExist(FirebaseConstants.firebaseAuth.currentUser!.uid);
                print(exist);
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
                    groupId: [],
                    profileImage: user.photoURL,
                  );
                  await _googleAuthCubit.updateIntoFirebase(userModel);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => AskingDetailsView(
                                model: userModel,
                              )),
                      (route) => false);
                }
              }

              if (state is ErrorGoogleAuthState) {
                CustomSnackBar().showSnackBar(
                    context: context,
                    text: state.err,
                    color: AppColors.errorColor,
                    duration: const Duration(milliseconds: 800));
              }
            })
          ],
        ),
      ),
    );
  }
}
