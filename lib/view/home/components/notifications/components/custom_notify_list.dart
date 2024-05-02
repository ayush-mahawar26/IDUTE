import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/controller/group_controller.dart';
import 'package:idute_app/controller/notification_controllers.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/notification_model.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/timeago_util.dart';
import 'package:idute_app/view/profile/visit_profile.dart';
import '../../../../../components/constants/size_config.dart';
import '../../../../../components/widgets/normal_text_widget.dart';

Widget buildTileForRequest(NotificationModel model, BuildContext context) {
  return InkWell(
    onTap: () async {
      UserModel? user = await ProfileController()
          .fetchUserProfileByUid(model.anyUserConnected!);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VisitUserProfile(userModel: user!)));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                (model.profileUrl != "")
                    ? CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          model.profileUrl,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 22,
                        child: Icon(
                          Icons.person,
                          size: 25,
                        ),
                      ),
                buildSizeWidth(width: 8),
                SizedBox(
                    width: 200,
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(text: "${model.notificationTitle}. "),
                      TextSpan(
                          text: TimeAgo().timeAgo(model.createdAt),
                          style: TextStyle(
                              fontSize: 12, color: AppColors.kFillColor)),
                    ]))),
                const SizedBox(
                  width: 3,
                ),
              ],
            ),

            // buildText(
            //     text: TimeAgo().timeAgo(model.createdAt),
            //     txtSize: 10,
            //     color: AppColors.kFillColor,
            //     overflow: TextOverflow.fade,
            //     maxLine: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    UserModel? byUser = await ProfileController()
                        .fetchUserProfileByUid(
                            FirebaseConstants.firebaseAuth.currentUser!.uid);
                    UserModel? toUser = await ProfileController()
                        .fetchUserProfileByUid(model.anyUserConnected!);
                    await NotificationControllers().acceptRequest(
                        byUser!, toUser!,
                        notificationId: model.notificationId);
                  },
                  child: Container(
                    width: 85,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 20),
                      child: Center(
                          child: buildText(
                              text: "Accept",
                              txtSize: 12,
                              color: Colors.black)),
                    ),
                  ),
                ),
              ],
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     buildSizeHeight(height: 4),
            //     buildText(
            //       text: "Priyanshu Gupta requested to join your group.",
            //       txtSize: 12,
            //     ),
            //     buildSizeHeight(height: 5),
            //     Row(
            //       children: [
            //         const Spacer(),
            //         buildText(
            //           text: "25 mins ago",
            //           txtSize: 10,
            //           color: const Color(0xFFA5A5A5),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // buildSizeHeight(height: 1),
          ],
        ),
      ),
    ),
  );
}

Widget buildTileForRequestGroup(NotificationModel model, BuildContext context) {
  return InkWell(
    onTap: () async {},
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                (model.profileUrl != "")
                    ? CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          model.profileUrl,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 22,
                        child: Icon(
                          Icons.person,
                          size: 25,
                        ),
                      ),
                buildSizeWidth(width: 8),
                SizedBox(
                    width: 200,
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(text: "${model.notificationTitle}.  "),
                      TextSpan(
                          text: TimeAgo().timeAgo(model.createdAt),
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.kFillColor)),
                    ]))),
              ],
            ),

            // buildText(
            //     text: TimeAgo().timeAgo(model.createdAt),
            //     txtSize: 10,
            //     color: AppColors.kFillColor,
            //     overflow: TextOverflow.fade,
            //     maxLine: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    print(model.anyUserConnected);
                    GroupModel group = await GroupController()
                        .getGroupById(model.anyUserConnected!);
                    UserModel? user =
                        await ProfileController().fetchUserProfile();
                    await GroupController()
                        .acceptInviteForGroup(user!, group, model);
                  },
                  child: Container(
                    width: 85,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 20),
                      child: Center(
                          child: buildText(
                              text: "Accept",
                              txtSize: 12,
                              color: Colors.black)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildCustomNotifyList(NotificationModel model, BuildContext context) {
  return InkWell(
    onTap: () async {
      if (model.type == "onAcceptRequest") {
        UserModel? user = await ProfileController()
            .fetchUserProfileByUid(model.anyUserConnected!);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VisitUserProfile(userModel: user!)));
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                (model.profileUrl != "")
                    ? CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          model.profileUrl,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 22,
                        child: Icon(
                          Icons.person,
                          size: 25,
                        ),
                      ),
                buildSizeWidth(width: 8),
                SizedBox(
                    width: 280,
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(text: "${model.notificationTitle}.  "),
                      TextSpan(
                          text: TimeAgo().timeAgo(model.createdAt),
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.kFillColor)),
                    ]))),
              ],
            ),

            // buildText(
            //     text: TimeAgo().timeAgo(model.createdAt),
            //     txtSize: 10,
            //     color: AppColors.kFillColor,
            //     overflow: TextOverflow.fade,
            //     maxLine: 3),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     buildSizeHeight(height: 4),
            //     buildText(
            //       text: "Priyanshu Gupta requested to join your group.",
            //       txtSize: 12,
            //     ),
            //     buildSizeHeight(height: 5),
            //     Row(
            //       children: [
            //         const Spacer(),
            //         buildText(
            //           text: "25 mins ago",
            //           txtSize: 10,
            //           color: const Color(0xFFA5A5A5),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // buildSizeHeight(height: 1),
          ],
        ),
      ),
    ),
  );
}
