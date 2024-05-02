import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/custom.buttons.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/group_controller.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/user_model.dart';

class RequestAvailable extends StatelessWidget {
  GroupModel groupModel;
  RequestAvailable({super.key, required this.groupModel});

  Widget reqList(BuildContext context, UserModel user) {
    return ListTile(
      leading: (user.profileImage == null || user.profileImage == "")
          ? const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage("assets/images/grp_s_2.png"),
            )
          : CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.profileImage!),
            ),
      title: buildText(text: user.name!, txtSize: 12),
      subtitle: buildText(
          text: user.category!, txtSize: 10, color: AppColors.kHintColor),
      trailing: SizedBox(
        width: SizeConfig.screenWidth * 0.38,
        child: Row(
          children: [
            Expanded(
              child: CustomButton().squareTextButton(
                  context: context,
                  text: "Accept",
                  width: SizeConfig.screenWidth / 3,
                  borderRadius: 5,
                  onPress: () async {
                    await GroupController()
                        .acceptRequestForSomeone(groupModel, user.uid!);
                    // await NotificationControllers()
                    //     .notificatonOnAcceptInvitationInGroup(
                    //         user.uid!, groupModel);
                  },
                  bgColor: AppColors.kBackgroundColor),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: CustomButton().squareTextButton(
                  context: context,
                  text: "Reject",
                  width: SizeConfig.screenWidth / 3,
                  borderRadius: 5,
                  onPress: () async {
                    await GroupController().declineTheRequestForSomeOne(
                        groupModel.groupId!, user.uid!);
                  },
                  bgColor: Colors.red),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
              stream: FirebaseConstants.store
                  .collection("Groups")
                  .doc(groupModel.groupId)
                  .collection("requests")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>>
                      requestOfUsers = snapshot.data!.docs;
                  if (requestOfUsers.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: buildText(
                            text: "No Request Available",
                            txtSize: 12,
                            color: AppColors.kHintColor),
                      ),
                    );
                  }

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: requestOfUsers.length,
                      itemBuilder: (context, index) {
                        UserModel user =
                            UserModel.fromMap(requestOfUsers[index].data());
                        return reqList(context, user);
                      });
                }

                if (snapshot.hasError) {
                  return ErrorScreen(
                      error: "Connection Issue",
                      errorIcon: const Icon(Icons.error_outline));
                }

                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                );
              }),
          const Divider(
            color: Colors.black,
            thickness: 2,
          ),
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              label: buildText(text: "Complete Discussion")),
        ],
      ),
    );
  }
}
