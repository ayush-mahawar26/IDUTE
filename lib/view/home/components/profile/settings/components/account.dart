import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/custom_text_form_field.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/components/widgets/snackbar.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/profileupdate_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/state/profile_update_state.dart';
import 'package:idute_app/model/user_model.dart';
import "package:google_places_flutter/google_places_flutter.dart";
import 'package:idute_app/utils/firebase_utils.dart';
import 'package:idute_app/utils/pick_file.dart';
import 'package:idute_app/view/home/components/profile/settings/components/change_pass.dart';

class AccountScreen extends StatefulWidget {
  UserModel userModel;
  AccountScreen({super.key, required this.userModel});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController startUpController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController eduNameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  // TextEditingController categoryController = TextEditingController();
  String finalCategory = "Technology";
  List<String> categoryList = <String>[
    'Technology',
    'Accounting',
    'Business',
    'Arts',
  ];

  List<String> position = ["Entrepreneur", "Founder"];
  String pos = "Entrepreneur";
  String profileImg = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.userModel.name!;
    phoneNumberController.text = widget.userModel.phone!;
    profileImg = widget.userModel.profileImage ?? "";
    emailController.text = widget.userModel.email!;
    userNameController.text = widget.userModel.username!;
    eduNameController.text = widget.userModel.qualification!;
    aboutController.text = widget.userModel.about!;
    locationController.text = widget.userModel.location!;
    if (widget.userModel.isFounder!) {
      position = ["Founder", "Entrepreneur"];
      pos = "Founder";
      startUpController.text = widget.userModel.startupname ?? '';
    }
  }

  DropdownButtonFormField<String> _customDropDown(List<String> categoryList,
      {bool? isPos = false}) {
    return DropdownButtonFormField(
      value: categoryList[0],
      elevation: 100,
      menuMaxHeight: getProportionateScreenHeight(189),
      decoration: const InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0),
      ),
      dropdownColor: Colors.grey[900],
      iconDisabledColor: Colors.white,
      iconEnabledColor: Colors.white,
      focusColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      onChanged: (value) {
        if (!isPos!) {
          finalCategory = value!;
          print(finalCategory);
        } else {
          pos = value!;
          startUpController.text = "";
          setState(() {});
          print(value);
        }
      },
      items: categoryList.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: buildText(
              text: value,
              txtSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          );
        },
      ).toList(),
    );
  }

  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;
  final FirebaseFirestore _store = FirebaseConstants.store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              "assets/icons/back.svg",
              width: 15,
              height: 15,
            ),
          ),
        ),
        title: buildText(text: "My Account", txtSize: 20),
        actions: [
          BlocConsumer<ProfileUpdateCubit, ProfileUpdateStates>(
            listener: (context, state) {
              if (state is ProfileUpdationErrorState) {
                CustomSnackBar().showSnackBar(
                    context: context,
                    text: state.err,
                    color: AppColors.errorColor,
                    duration: const Duration(milliseconds: 800));
              }
              if (state is ProfileUpdatedState) {
                Navigator.pop(context);
                CustomSnackBar().showSnackBar(
                    context: context,
                    text: "Profile Updated",
                    color: Colors.green,
                    duration: const Duration(milliseconds: 800));
              }
            },
            builder: (context, state) {
              if (state is ProfileUpdatingState) {
                return const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: CircularProgressIndicator(
                      color: AppColors.kFillColor,
                    ));
              }
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.kcardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      ProfileUpdateCubit profileCubit =
                          BlocProvider.of<ProfileUpdateCubit>(context);
                      UserModel user = UserModel(
                          uid: widget.userModel.uid,
                          username: userNameController.text,
                          name: nameController.text,
                          email: emailController.text,
                          phone: widget.userModel.phone,
                          connects: widget.userModel.connects,
                          iq: widget.userModel.iq,
                          isFounder: (pos == "Founder") ? true : false,
                          profileImage: profileImg,
                          createdOwnGroup: widget.userModel.createdOwnGroup,
                          isEmailVerified: widget.userModel.isEmailVerified,
                          isPhoneVerified: widget.userModel.isPhoneVerified,
                          category: finalCategory,
                          startupname: startUpController.text,
                          qualification: eduNameController.text,
                          location: locationController.text,
                          about: aboutController.text,
                          createdTime: widget.userModel.createdTime,
                          groupId: widget.userModel.groupId,
                          isProfileCompleted:
                              widget.userModel.isProfileCompleted);
                      await profileCubit.updateProfile(user);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: buildText(
                        text: "Save",
                        txtSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSizeHeight(height: 10),
            // CustomProfileAdd(),
            Center(
              child: InkWell(
                onTap: () async {
                  String? path = await PickFilesFromLocal().pickImage();
                  if (path != null) {
                    String imgUrl =
                        await FirebaseUtils().addProfileImageToStorage(path);
                    await _store
                        .collection("Users")
                        .doc(_auth.currentUser!.uid)
                        .set({"profileImage": imgUrl}, SetOptions(merge: true));
                    setState(() {
                      profileImg = imgUrl;
                      print("changes");
                    });
                  }
                },
                child: Stack(
                  children: [
                    (profileImg.isNotEmpty)
                        ? CircleAvatar(
                            radius: 47,
                            backgroundImage: NetworkImage(profileImg),
                          )
                        : const CircleAvatar(
                            backgroundColor: AppColors.kFillColor,
                            radius: 47,
                            child: Icon(
                              Icons.person,
                              size: 50,
                            ),
                          ),
                    Positioned(
                      bottom: 5,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // buildText(
            //   text: "Name",
            //   color: const Color(0xFFD6D6D6),
            //   txtSize: 14,
            // ),
            buildTextFormField(
              controller: nameController,
              keyboardType: TextInputType.name,
              hintText: "Name",
              errorText: "Please enter name",
            ),
            buildSizeHeight(height: 14),
            // buildText(
            //   text: "Username",
            //   color: const Color(0xFFD6D6D6),
            //   txtSize: 14,
            // ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: userNameController,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Fill your username";
                } else if (value.contains(" ")) {
                  return "Username can't contain space";
                } else {
                  return null;
                }
              },
              style: const TextStyle(
                fontSize: (15),
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration(
                labelStyle: TextStyle(
                  color: AppColors.kFillColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                labelText: "Username",
                fillColor: Color(0xFF2B2B2B),
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB6B6B6),
                  fontWeight: FontWeight.w400,
                  fontFamily: "inter",
                ),
              ),
            ),
            buildSizeHeight(height: 14),
            // buildText(
            //   text: "Email Id",
            //   color: const Color(0xFFD6D6D6),
            //   txtSize: 14,
            // ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: true,
              readOnly: (widget.userModel.isEmailVerified!) ? true : false,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter Email";
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
              decoration: InputDecoration(
                labelStyle: const TextStyle(
                  color: AppColors.kFillColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                suffix: (widget.userModel.isEmailVerified!)
                    ? buildText(
                        text: "Verified",
                        color: AppColors.kBackgroundColor,
                        txtSize: 12)
                    : buildText(text: ""),
                fillColor: const Color(0xFF2B2B2B),
                labelText: "Email address",

                hintText: "Email address",
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB6B6B6),
                  fontWeight: FontWeight.w400,
                  fontFamily: "inter",
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
            ),

            buildSizeHeight(height: 14),
            buildTextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              hintText: "Phone Number",
              errorText: "Please enter phone number",
            ),
            buildSizeHeight(height: 14),

            // buildText(
            //   text: "College/School",
            //   color: const Color(0xFFD6D6D6),
            //   txtSize: 14,
            // ),
            buildTextFormField(
              controller: eduNameController,
              keyboardType: TextInputType.name,
              hintText: "College/School",
              errorText: "Please enter school name",
            ),
            buildSizeHeight(height: 14),

            buildText(
              text: "Category",
              color: AppColors.kFillColor,
              txtSize: 12,
            ),
            _customDropDown(categoryList),
            buildSizeHeight(height: 14),
            // buildText(
            //   text: "About",
            //   color: const Color(0xFFD6D6D6),
            //   txtSize: 14,
            // ),

            // buildText(
            //   text: "Location",
            //   color: const Color(0xFFD6D6D6),
            //   txtSize: 14,
            // ),
            buildText(
              text: "You are a",
              color: AppColors.kFillColor,
              txtSize: 12,
            ),
            _customDropDown(position, isPos: true),
            buildSizeHeight(height: 14),

            (pos == "Founder")
                ? buildTextFormField(
                    controller: startUpController,
                    keyboardType: TextInputType.streetAddress,
                    hintText: "Startup Name",
                    errorText: "Please Enter start up",
                  )
                : buildTextFormField(
                    controller: startUpController,
                    keyboardType: TextInputType.streetAddress,
                    hintText: "Startup Name",
                    errorText: "Please Enter start up",
                    isEnable: false),

            buildSizeHeight(height: 14),

            buildTextFormField(
              controller: locationController,
              keyboardType: TextInputType.streetAddress,
              hintText: "Location",
              errorText: "Please enter location",
            ),
            buildSizeHeight(height: 14),
            Center(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.kBackgroundColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)))),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangePasswordView(
                              loogedIn: true,
                            )));
                  },
                  child: buildText(text: "Change Password", txtSize: 12)),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        )),
      ),
    );
  }
}
