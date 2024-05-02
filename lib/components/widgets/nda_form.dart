import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/group_controller.dart';
import 'package:idute_app/model/group_model.dart';

class NDAFormBottomSheet extends StatefulWidget {
  GroupModel group;
  NDAFormBottomSheet({super.key, required this.group});

  @override
  State<NDAFormBottomSheet> createState() => _NDAFormBottomSheetState();
}

class _NDAFormBottomSheetState extends State<NDAFormBottomSheet> {
  bool isAccepted = false;

  _showRequetSheet() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kcardColor,
      builder: (BuildContext context) {
        return RequestSentBottomSheet(
          icon: const Icon(
            Icons.check_circle_sharp,
            size: 40,
            color: AppColors.kBackgroundColor,
          ),
          text:
              "Your request has been send, we will let you know once the founder of this startup accepts your request",
          title: "Request Sent",
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
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: AppColors.kFillColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: buildText(
                      text: "Join Startup",
                      txtSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: buildText(
                      text:
                          "Joining the team/startup means you agree to the terms and conditions / NDA for the concept being discussed or executed."),
                ),
                const SizedBox(height: 10.0),
                CheckboxListTile(
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                  title: Transform.translate(
                    offset: const Offset(-15, 0),
                    child: SizedBox(
                      width: SizeConfig.screenWidth * 0.6,
                      child: Row(
                        children: [
                          buildText(
                              text: "I agree to the terms and condition / NDA"),
                          const SizedBox(
                            width: 5,
                          ),
                          buildText(text: "*", color: Colors.red.shade900)
                        ],
                      ),
                    ),
                  ),
                  value: isAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      isAccepted = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (isAccepted) {
                        Navigator.pop(context);
                        try {
                          GroupController().createRequestForGroup(
                              FirebaseConstants.firebaseAuth.currentUser!.uid,
                              widget.group);
                          _showRequetSheet();
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: buildText(
                        text: "Request to Join",
                        color: AppColors.sBackgroundColor,
                        fontWeight: FontWeight.bold)),
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
// "Your request has been send, we will let you know once the founder of this startup accepts your request"

class RequestSentBottomSheet extends StatelessWidget {
  Icon icon;
  String title;
  String text;
  String? text2;
  RequestSentBottomSheet(
      {super.key,
      required this.icon,
      required this.title,
      required this.text,
      this.text2});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          width: SizeConfig.screenWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: AppColors.kFillColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 15.0),
                buildText(
                    text: title, txtSize: 20, fontWeight: FontWeight.bold),
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    icon,
                    const SizedBox(
                      height: 10,
                    ),
                    // Text(
                    //   text,
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(fontSize: 15),
                    // ),

                    Center(
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(text: text, children: [
                            TextSpan(
                                text: text2.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: AppColors.kFillColor))
                          ])),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// "Thank you for reporting this post"
// "Your feed back is inportant in helping us keep the idute community safe."
