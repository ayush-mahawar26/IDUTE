import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/dynamiclink_util.dart';
import 'package:idute_app/view/home/components/profile/settings/settings_screen.dart';
import 'package:share_plus/share_plus.dart';

class FirstContainer extends StatefulWidget {
  UserModel userModel;
  FirstContainer({super.key, required this.userModel});
  static final borderShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50),
    side: const BorderSide(color: Colors.white, width: 1),
  );

  @override
  State<FirstContainer> createState() => _FirstContainerState();
}

class _FirstContainerState extends State<FirstContainer> {
  bool isEditable = false;

  Widget _customProfileButtons(
      String text, Icon icon, Color color, Function onTap) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(
                  width: 5,
                ),
                buildText(text: text, txtSize: 12)
              ],
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController _aboutController = TextEditingController();

  bool showmore = false;
  final maxCharacter = 150;

  @override
  Widget build(BuildContext context) {
    String aboutUser = (showmore)
        ? widget.userModel.about!
        : (widget.userModel.about!.length > maxCharacter)
            ? "${widget.userModel.about!.substring(0, maxCharacter)}...."
            : widget.userModel.about!;
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.018),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    (!widget.userModel.isFounder!)
                        ? buildText(
                            text: "Enterpreneaur",
                            txtSize: 12,
                            color: AppColors.kHintColor)
                        : buildText(
                            text: "Founder",
                            txtSize: 12,
                            color: AppColors.kHintColor),
                    (!widget.userModel.isFounder!)
                        ? buildText(
                            text: "", txtSize: 12, color: AppColors.kHintColor)
                        : buildText(
                            text: "- ${widget.userModel.startupname}",
                            txtSize: 12,
                            color: AppColors.kHintColor)
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      FluentIcons.hat_graduation_12_regular,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                        width: SizeConfig.screenWidth * 0.83,
                        child: buildText(
                            text: widget.userModel.qualification!,
                            txtSize: 12)),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    buildText(text: widget.userModel.location!, txtSize: 12),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: _customProfileButtons(
                              "Share Profile",
                              const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              AppColors.kcardColor, () async {
                        Uri uri = await DynamicLinkService()
                            .createDynamicLinkForUserProfile(
                                widget.userModel.uid!);
                        await Share.share(uri.toString());
                      })),
                      SizedBox(
                        width: (SizeConfig.screenWidth * 0.023 +
                                SizeConfig.screenWidth * 0.02) /
                            2,
                      ),
                      // Expanded(
                      //     child: _customProfileButtons(
                      //         "Chat",
                      //         const Icon(
                      //           Icons.message,
                      //           color: Colors.white,
                      //         ),
                      //         AppColors.kcardColor, () {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => const ChatScreen()));
                      // })),
                      // const SizedBox(
                      //   width: 20,
                      // ),
                      Expanded(
                          child: _customProfileButtons(
                              "Settings",
                              const Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                              AppColors.kcardColor, () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => SettingScreen(
                                      userModel: widget.userModel,
                                    )));
                      })),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        buildText(
                            text: "About",
                            txtSize: 12,
                            fontWeight: FontWeight.w600),
                        const SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isEditable = !isEditable;
                              _aboutController.text = widget.userModel.about!;
                            });
                          },
                          child: const Image(
                            image: AssetImage('assets/icons/pencil.png'),
                            height: 15,
                            width: 15,
                          ),
                        ),
                      ],
                    ),
                    // (userModel.about!="" && userModel.about !=null) ?
                    const SizedBox(
                      height: 5,
                    ),
                    (isEditable)
                        ? TextFormField(
                            controller: _aboutController,
                            maxLines: null,
                            // maxLength: 300,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 14),
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () async {
                                  await ProfileController().updateAboutForUser(
                                      widget.userModel.uid!,
                                      _aboutController.text.trim());
                                  setState(() {
                                    isEditable = !isEditable;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      top: 100, bottom: 30, left: 0, right: 0),
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              fillColor: AppColors.kcardColor,
                              filled: true,
                              isCollapsed: true,
                              contentPadding:
                                  const EdgeInsets.only(top: 10, left: 15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                            ),
                          )
                        : (widget.userModel.about!.length > maxCharacter)
                            ? RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: getProportionateScreenWidth(12),
                                      letterSpacing: 0,
                                      fontFamily: "Inter",
                                    ),
                                    children: [
                                    TextSpan(text: aboutUser),
                                    TextSpan(
                                        style: TextStyle(
                                          color: AppColors.kFillColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              getProportionateScreenWidth(12),
                                          letterSpacing: 0,
                                          fontFamily: "Inter",
                                        ),
                                        text: (showmore)
                                            ? "  Show Less"
                                            : "Show More",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(() {
                                              showmore = !showmore;
                                            });
                                          })
                                  ]))
                            : buildText(
                                text: widget.userModel.about!, txtSize: 12)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
