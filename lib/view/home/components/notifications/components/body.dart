import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/error_screen.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/notification_controllers.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/notification_model.dart';

import 'custom_notify_list.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<GroupModel> _getGroupModel(String groupId) async {
    DocumentSnapshot<Map<String, dynamic>> groupMap =
        await FirebaseConstants.store.collection("Groups").doc(groupId).get();

    return GroupModel.fromMap(groupMap.data()!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(
          getProportionateScreenWidth(10),
          getProportionateScreenHeight(10),
          getProportionateScreenWidth(10),
          getProportionateScreenHeight(30),
        ),
        child: StreamBuilder(
            stream: NotificationControllers().getAllNotifications(
                FirebaseConstants.firebaseAuth.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                    snapshot.data!.docs;

                List<NotificationModel> today = [];
                List<NotificationModel> yesterday = [];
                List<NotificationModel> older = [];

                for (QueryDocumentSnapshot<Map<String, dynamic>> noti in data) {
                  NotificationModel notificationModel =
                      NotificationModel.fromMap(noti.data());

                  if (isSameDay(
                      notificationModel.createdAt.toDate(), DateTime.now())) {
                    today.add(notificationModel);
                  } else if (isSameDay(notificationModel.createdAt.toDate(),
                      DateTime.now().subtract(const Duration(days: 1)))) {
                    yesterday.add(notificationModel);
                  } else {
                    older.add(notificationModel);
                  }
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (today.isEmpty)
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildText(text: "Today"),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: today.length,
                                    itemBuilder: (context, index) {
                                      return (today[index].type ==
                                              "onSendRequest")
                                          ? buildTileForRequest(
                                              today[index], context)
                                          : (today[index].type ==
                                                  "onSendRequestGroup")
                                              ? buildTileForRequestGroup(
                                                  today[index], context)
                                              : buildCustomNotifyList(
                                                  today[index], context);
                                    })
                              ],
                            ),
                      (yesterday.isEmpty)
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                buildText(text: "Yesterday"),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: yesterday.length,
                                    itemBuilder: (context, index) {
                                      return (yesterday[index].type ==
                                              "onSendRequest")
                                          ? buildTileForRequest(
                                              yesterday[index], context)
                                          : (yesterday[index].type ==
                                                  "onSendRequestGroup")
                                              ? buildTileForRequestGroup(
                                                  yesterday[index], context)
                                              : buildCustomNotifyList(
                                                  yesterday[index], context);
                                    })
                              ],
                            ),
                      (older.isEmpty)
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                buildText(text: "Older"),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: older.length,
                                    itemBuilder: (context, index) {
                                      return (older[index].type ==
                                              "onSendRequest")
                                          ? buildTileForRequest(
                                              older[index], context)
                                          : (older[index].type ==
                                                  "onSendRequestGroup")
                                              ? buildTileForRequestGroup(
                                                  older[index], context)
                                              : buildCustomNotifyList(
                                                  older[index], context);
                                    })
                              ],
                            ),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return ErrorScreen(
                    error: "Some Connection probelem occured",
                    errorIcon: const Icon(
                      Icons.error,
                      size: 40,
                    ));
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
