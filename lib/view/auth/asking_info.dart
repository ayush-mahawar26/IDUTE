import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/custom.buttons.dart';
import 'package:idute_app/components/widgets/custom_textfeild.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/components/widgets/snackbar.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/auth_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/state/auth_states.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/firebase_utils.dart';
import 'package:idute_app/utils/pick_file.dart';
import 'package:idute_app/view/home/home.dart';

class AskingDetailsView extends StatefulWidget {
  UserModel model;
  AskingDetailsView({super.key, required this.model});

  @override
  State<AskingDetailsView> createState() => _AskingDetailsViewState();
}

class _AskingDetailsViewState extends State<AskingDetailsView> {
  final TextEditingController _name = TextEditingController();

  final TextEditingController _college = TextEditingController();

  final TextEditingController _location = TextEditingController();

  List<String> list = <String>['Art', 'Fashion', 'Technology', 'Legal'];

  String _category = 'Technology';

  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;
  final FirebaseFirestore _store = FirebaseConstants.store;

  TextEditingController phnController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser!.displayName != null) {
      _name.text = _auth.currentUser!.displayName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.sBackgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset("assets/icons/back.svg"))
                  ],
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
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: buildText(
                    text: "Sign in-up to enjoy the best managing experience",
                    txtSize: 12,
                    color: AppColors.kFillColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: _store
                          .collection("Users")
                          .doc(_auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            width: SizeConfig.screenWidth,
                            decoration: const BoxDecoration(
                                color: AppColors.kSecondaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(31),
                                    topRight: Radius.circular(31))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                AppColors.kHintColor,
                                            radius: 58,
                                            child: CircleAvatar(
                                              radius: 55,
                                              backgroundColor:
                                                  AppColors.kSecondaryColor,
                                              child: (snapshot.data!.get(
                                                          "profileImage") ==
                                                      null)
                                                  ? const Icon(
                                                      Icons.person,
                                                      size: 70,
                                                    )
                                                  : ClipOval(
                                                      child: Image.network(
                                                        snapshot.data!.get(
                                                            "profileImage"),
                                                        height: 120,
                                                        width: 120,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: GestureDetector(
                                              onTap: () async {
                                                String? path =
                                                    await PickFilesFromLocal()
                                                        .pickImage();
                                                if (path != null) {
                                                  String imgUrl =
                                                      await FirebaseUtils()
                                                          .addProfileImageToStorage(
                                                              path);
                                                  // TODO : imply function
                                                  _store
                                                      .collection("Users")
                                                      .doc(_auth
                                                          .currentUser!.uid)
                                                      .set({
                                                    "profileImage": imgUrl
                                                  }, SetOptions(merge: true));
                                                }
                                              },
                                              child: const CircleAvatar(
                                                backgroundColor:
                                                    AppColors.kHintColor,
                                                radius: 20,
                                                child: CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor:
                                                      AppColors.kSecondaryColor,
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextFeild().customTextFeild(
                                        "Your Good Name",
                                        _name,
                                        context,
                                        "assets/icons/user.svg"),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                                width: 2,
                                                color: AppColors.kHintColor)),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: SvgPicture.asset(
                                                "assets/icons/category.svg",
                                                height: 25,
                                                width: 25,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    buildText(
                                                        text: "Skill Category",
                                                        color: AppColors
                                                            .kHintColor,
                                                        txtSize: 12),
                                                    DropdownButtonFormField<
                                                        String>(
                                                      value: _category,
                                                      decoration:
                                                          InputDecoration(
                                                        isCollapsed: true,
                                                        border:
                                                            OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                      ),
                                                      icon: const Icon(
                                                        Icons
                                                            .arrow_drop_down_rounded,
                                                        color: AppColors
                                                            .kBackgroundColor,
                                                      ),
                                                      elevation: 20,
                                                      onChanged:
                                                          (String? value) {
                                                        // This is called when the user selects an item.
                                                        _category = value!;
                                                      },
                                                      items: list.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: buildText(
                                                              text: value,
                                                              color: AppColors
                                                                  .sBackgroundColor,
                                                              txtSize: 13),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextFeild().customTextFeild(
                                        "College",
                                        _college,
                                        context,
                                        "assets/icons/college.svg"),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextFeild().customTextFeild(
                                        "Location",
                                        _location,
                                        context,
                                        "assets/icons/location.svg"),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          border: Border.all(
                                              width: 2,
                                              color: AppColors.kHintColor)),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: phnController,
                                        cursorColor: AppColors.kBackgroundColor,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color:
                                                    AppColors.sBackgroundColor),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Phone Number ",
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color:
                                                        AppColors.kFillColor),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Icon(
                                                Icons.phone,
                                                color:
                                                    AppColors.kBackgroundColor,
                                              ),
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    BlocConsumer<AuthCubit, AuthStates>(
                                        builder: (context, state) {
                                      if (state is LoadingAuthState) {
                                        return CustomButton().loadingButton(
                                            context: context,
                                            width: SizeConfig.screenWidth,
                                            bgColor:
                                                AppColors.kBackgroundColor);
                                      } else {
                                        return CustomButton().customLabelButton(
                                            context: context,
                                            text: "Done",
                                            width: SizeConfig.screenWidth,
                                            onPress: () async {
                                              String name = _name.text.trim();
                                              String college =
                                                  _college.text.trim();
                                              String location =
                                                  _location.text.trim();
                                              String phn =
                                                  phnController.text.trim();
                                              if (name.isEmpty ||
                                                  college.isEmpty ||
                                                  location.isEmpty ||
                                                  phn.isEmpty) {
                                                return CustomSnackBar()
                                                    .showSnackBar(
                                                        context: context,
                                                        text:
                                                            "Fill all the details",
                                                        color: AppColors
                                                            .errorColor,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500));
                                              } else {
                                                if (phn.length != 10) {
                                                  CustomSnackBar().showSnackBar(
                                                      context: context,
                                                      text:
                                                          "Enter Valid Phone Number",
                                                      color:
                                                          AppColors.errorColor,
                                                      duration: const Duration(
                                                          milliseconds: 800));
                                                } else {
                                                  name = name.trim();
                                                  String username =
                                                      name.replaceAll(" ", "");
                                                  username =
                                                      username.toLowerCase();
                                                  UserModel userModel = UserModel(
                                                      uid: widget.model.uid,
                                                      email: widget.model.email,
                                                      username: username,
                                                      name: name,
                                                      profileImage: snapshot
                                                          .data!
                                                          .get("profileImage"),
                                                      isEmailVerified: widget
                                                          .model
                                                          .isEmailVerified,
                                                      isPhoneVerified: false,
                                                      category: _category,
                                                      location: location,
                                                      qualification: college,
                                                      isFounder: false,
                                                      phone: "+91$phn",
                                                      about:
                                                          "I am a rising Entrepreneur on IDUTE",
                                                      connects: 0,
                                                      iq: 51,
                                                      createdTime: widget
                                                          .model.createdTime,
                                                      groupId: const []);
                                                  AuthCubit authCubit =
                                                      BlocProvider.of(context);
                                                  await authCubit
                                                      .addUserInFirebase(
                                                          userModel);
                                                }
                                              }
                                            },
                                            bgColor:
                                                AppColors.kBackgroundColor);
                                      }
                                    }, listener: (context, state) {
                                      if (state is DoneAuthState) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeScreen()),
                                                (route) => false);
                                      } else if (state is ErrorAuthState) {
                                        CustomSnackBar().showSnackBar(
                                            context: context,
                                            text: state.err,
                                            color: Colors.red,
                                            duration: const Duration(
                                                milliseconds: 500));
                                      }
                                    })
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.none) {
                          return Center(
                            child: Column(
                              children: [
                                const Icon(Icons.error_outline),
                                buildText(text: "Error Occured")
                              ],
                            ),
                          );
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      })),
            ],
          ),
        ));
  }
}
