import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/model/iq_model.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/iq_algo.dart';

Widget userTile({required UserModel userModel}) {
  return Card(
    color: AppColors.sBackgroundColor,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          (userModel.profileImage != null && userModel.profileImage!.isNotEmpty)
              ? Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userModel.profileImage!),
                      radius: 30,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 12,
                          child: StreamBuilder(
                            stream: FirebaseConstants.store
                                .collection("iq")
                                .doc(userModel.uid!)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                IqModel iq =
                                    IqModel.fromMap(snapshot.data!.data()!);
                                double useriq =
                                    UserIQCalculator.calculateIQ(iq: iq);
                                int roundediq = (useriq / 10).round() * 10;
                                return buildText(
                                    text: (roundediq + 20 > 150)
                                        ? "150+"
                                        : "${roundediq + 20}+",
                                    txtSize: 7);
                              }

                              if (snapshot.hasError) {
                                return const SizedBox();
                              }

                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Stack(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/icons/default.jpg"),
                      radius: 30,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 12,
                          child: StreamBuilder(
                            stream: FirebaseConstants.store
                                .collection("iq")
                                .doc(userModel.uid!)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                IqModel iq =
                                    IqModel.fromMap(snapshot.data!.data()!);
                                double useriq =
                                    UserIQCalculator.calculateIQ(iq: iq);
                                int roundediq = (useriq / 10).round() * 10;
                                return buildText(
                                    text: (roundediq + 20 > 150)
                                        ? "150+"
                                        : "${roundediq + 20}+",
                                    txtSize: 7);
                              }

                              if (snapshot.hasError) {
                                return const SizedBox();
                              }

                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(text: userModel.username!, txtSize: 14),
              buildText(
                  text: userModel.category!,
                  txtSize: 12,
                  color: AppColors.kHintColor)
            ],
          )
        ],
      ),
    ),
  );
}
