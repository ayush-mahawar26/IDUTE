import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';

import '../../../../components/widgets/app_bar.dart';
import 'components/body.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _makeAllNotificationRead();
  }

  _makeAllNotificationRead() async {
    QuerySnapshot<Map<String, dynamic>> notification = await FirebaseConstants
        .store
        .collection("Users")
        .doc(FirebaseConstants.firebaseAuth.currentUser!.uid)
        .collection("Notifications")
        .where("read", isEqualTo: false)
        .get();
    for (int i = 0; i < notification.docs.length; i++) {
      await notification.docs[i].reference
          .set({"read": true}, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "Notifications",
        onTap: () {},
      ),
      body: const Column(
        children: [
          Divider(
            thickness: 0,
            height: 0,
          ),
          Expanded(child: Body()),
        ],
      ),
    );
  }
}
