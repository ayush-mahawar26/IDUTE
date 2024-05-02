// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/controller/BuisnessLogic/posts/post_cubit.dart';
import 'package:idute_app/domain/entity/post_entity.dart';
import 'package:idute_app/view/home/components/posts/post_screen.dart';
import 'package:share_plus/share_plus.dart';

import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/nda_form.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/components/widgets/share_bottomsheet.dart';

import '../../controller/user_profile_controller.dart';
import '../../model/user_model.dart';
import '../../view/profile/visit_profile.dart';

class PostBottomSheet extends StatelessWidget {
  String uid;
  PostEntity post;
  PostBottomSheet({
    Key? key,
    required this.uid,
    required this.post,
  }) : super(key: key);

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

  _setReason(String reason, BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          _showReportBottomSheet(context);
        },
        child: buildText(text: reason));
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

  @override
  Widget build(BuildContext context) {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;

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
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Icon(
                      currentUid == uid ? Icons.edit : Icons.person,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        UserModel? user = await ProfileController()
                            .fetchUserProfileByUid(uid);
                        currentUid == uid
                            ? Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PostScreen(
                                    isPostEditing: true,
                                    path: post.audio.toString(),
                                    problem: post.problem.toString(),
                                    category: post.category,
                                    postId: post.postId.toString(),
                                  ),
                                ),
                              )
                            : Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VisitUserProfile(userModel: user!),
                                ),
                              );
                      },
                      child: buildText(
                          text: currentUid == uid
                              ? "Edit Post"
                              : "Visit Founder's Profile",
                          txtSize: 15),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    BlocProvider.of<PostCubit>(context).deletePost(
                      post: PostEntity(postId: post.postId),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Icon(
                        currentUid == uid
                            ? Icons.delete
                            : Icons.person_add_alt_1,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      buildText(
                          text: currentUid == uid
                              ? "Delete Post"
                              : "Connect Request",
                          txtSize: 15),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Divider(
                  thickness: 0,
                ),
                const SizedBox(
                  height: 12,
                ),
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
                  onTap: () {
                    Share.share("www.google.com");
                    // Navigator.pop(context);
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
