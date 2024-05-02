import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/constants/urls.dart';
import 'package:idute_app/components/helpers/dependencies.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/iq_controllers.dart';
import 'package:idute_app/model/iq_model.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/iq_algo.dart';

class DP extends StatefulWidget {
  UserModel userModel;
  DP({super.key, required this.userModel});

  @override
  State<DP> createState() => _DPState();
}

class _DPState extends State<DP> {
  int countIq = 0;

  @override
  void initState() {
    super.initState();
    IqControllers().createIqIfNotExist(widget.userModel.uid!);
    IqControllers().calculateUserIq(widget.userModel);
  }

  @override
  Widget build(BuildContext context) {
    Color? randomColor = UrlConstants().profileColor[Random().nextInt(4)];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (widget.userModel.profileImage != null &&
                widget.userModel.profileImage != "")
            ? Padding(
                padding: const EdgeInsets.only(left: 6),
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(widget.userModel.profileImage!),
                ))
            : Padding(
                padding: EdgeInsets.only(left: 6),
                child: CircleAvatar(
                    backgroundColor: randomColor,
                    radius: 50.0,
                    backgroundImage: AssetImage("assets/icons/default.jpg"))),
        const SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                buildText(
                  text: widget.userModel.name!,
                ),
                const SizedBox(
                  width: 10,
                ),
                (widget.userModel.iq! + 20 > 150)
                    ? const Icon(
                        Icons.verified_rounded,
                        size: 20,
                        color: Colors.white,
                      )
                    : const SizedBox(),
              ],
            ),
            buildText(
                text: widget.userModel.category!,
                txtSize: 12,
                color: AppColors.kHintColor),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                buildText(
                    text: widget.userModel.connects.toString(),
                    fontWeight: FontWeight.bold),
                const SizedBox(
                  width: 5,
                ),
                buildText(
                  text: "connect",
                  txtSize: 12,
                ),
                const SizedBox(
                  width: 20,
                ),
                StreamBuilder(
                  stream: FirebaseConstants.store
                      .collection("iq")
                      .doc(widget.userModel.uid!)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      IqModel iq = IqModel.fromMap(snapshot.data!.data()!);
                      double useriq = UserIQCalculator.calculateIQ(iq: iq);
                      int roundediq = (useriq / 10).round() * 10;
                      return buildText(
                          text: (roundediq + 20 > 150)
                              ? "150+"
                              : "${roundediq + 20}+",
                          fontWeight: FontWeight.bold);
                    }

                    if (snapshot.hasError) {
                      return const SizedBox();
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                const SizedBox(
                  width: 5,
                ),
                buildText(
                  text: "IQ",
                  txtSize: 12,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
