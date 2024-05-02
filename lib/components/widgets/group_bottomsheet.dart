import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/nda_form.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/components/widgets/share_bottomsheet.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/dynamiclink_util.dart';
import 'package:idute_app/view/profile/visit_profile.dart';
import 'package:share_plus/share_plus.dart';

class GroupInfoBottomSheet extends StatelessWidget {
  GroupModel? model;
  GroupInfoBottomSheet({super.key, this.model});

  _showShareBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColors.sBackgroundColor,
      builder: (BuildContext context) {
        return const ShareBottomSheet();
      },
    );
  }

  _showReportBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColors.sBackgroundColor,
      builder: (BuildContext context) {
        return RequestSentBottomSheet(
          icon: const Icon(
            Icons.check_circle,
            size: 50,
            color: Colors.green,
          ),
          title: "Report",
          text: "Thank you for reporting this this post.",
          text2:
              "\nYour feedback is important in helping us keep the Idute community safe.",
        );
      },
    );
  }

  _setReason(String label, BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          _showReportBottomSheet(context);
        },
        child: buildText(text: label));
  }

  _showConfirmReportBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColors.sBackgroundColor,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              width: SizeConfig.screenWidth,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                            color: AppColors.kFillColor,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Center(
                        child: buildText(
                            text: "Report",
                            txtSize: 20,
                            fontWeight: FontWeight.bold)),
                    const Divider(
                      thickness: 0,
                      color: AppColors.kFillColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          buildText(
                              text: "Why are you reporting this post?",
                              fontWeight: FontWeight.w500),
                          const SizedBox(
                            height: 15,
                          ),
                          buildText(
                              text:
                                  "Your report is anonymous, exept if you are reporting an intellectual property infringement. If someone is in immediate danger call the local emergency services.",
                              color: AppColors.kFillColor,
                              txtSize: 12),
                          const SizedBox(
                            height: 15,
                          ),
                          _setReason("I just don't like it", context),
                          const SizedBox(
                            height: 15,
                          ),
                          _setReason("It's a spam", context),
                          const SizedBox(
                            height: 15,
                          ),
                          _setReason("Nudity or sexual activity", context),
                          const SizedBox(
                            height: 15,
                          ),
                          _setReason("Hate speech or symbols", context),
                          const SizedBox(
                            height: 15,
                          ),
                          _setReason("Bullying or harassment", context),
                          const SizedBox(
                            height: 15,
                          ),
                          _setReason("Scam or fraud", context),
                          const SizedBox(
                            height: 15,
                          ),
                          _setReason(
                              "Violence or dangerous organisations", context),
                          const SizedBox(
                            height: 15,
                          ),
                          _setReason(
                              "Intellectual property violation", context),
                          const SizedBox(
                            height: 15,
                          ),
                          _setReason(
                              "Sale of illegal or regulated goods", context),
                          const SizedBox(
                            height: 15,
                          ),
                          _setReason("Sucide or self injury", context),
                          const SizedBox(
                            height: 15,
                          ),
                          _setReason("others", context),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          width: SizeConfig.screenWidth,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          color: AppColors.kFillColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                (model!.createdBy !=
                        FirebaseConstants.firebaseAuth.currentUser!.uid)
                    ? InkWell(
                        onTap: () async {
                          print("heello");
                          if (model != null) {
                            UserModel? user = await ProfileController()
                                .fetchUserProfileByUid(model!.createdBy);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    VisitUserProfile(userModel: user!)));
                          }
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            const Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            buildText(
                                text: "Visit Founder's Profile", txtSize: 15),
                          ],
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 12,
                ),
                (model!.createdBy !=
                        FirebaseConstants.firebaseAuth.currentUser!.uid)
                    ? Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.person_add_alt_1,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          buildText(text: "Connect Request", txtSize: 15),
                        ],
                      )
                    : const SizedBox(),
                (model!.createdBy !=
                        FirebaseConstants.firebaseAuth.currentUser!.uid)
                    ? const SizedBox(
                        height: 12,
                      )
                    : const SizedBox(),
                (model!.createdBy !=
                        FirebaseConstants.firebaseAuth.currentUser!.uid)
                    ? const Divider(
                        thickness: 0,
                      )
                    : const SizedBox(),
                (model!.createdBy !=
                        FirebaseConstants.firebaseAuth.currentUser!.uid)
                    ? const SizedBox(
                        height: 12,
                      )
                    : const SizedBox(),
                InkWell(
                  onTap: () {
                    // Share.share("www.google.com");
                    Navigator.pop(context);
                    _showShareBottomSheet(context);
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const Icon(
                        Icons.send,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      buildText(text: "Send to", txtSize: 15),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    Uri groupLink = await DynamicLinkService()
                        .createDynamicLinkForGroup(model!.groupId!);

                    Share.share(groupLink.toString());
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const Icon(
                        Icons.share,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      buildText(text: "Share", txtSize: 15),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.copy,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    buildText(text: "Copy Link", txtSize: 15),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // _showReportBottomSheet(context);
                    _showConfirmReportBottomSheet(context);
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.report,
                        size: 20,
                        color: Colors.red.shade900,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      buildText(
                          text: "Report",
                          txtSize: 15,
                          color: Colors.red.shade900),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
