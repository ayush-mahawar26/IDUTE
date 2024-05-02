import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/model/chat_list_model.dart';
import 'package:idute_app/view/home/components/main/components/build_card_rows.dart';

class ChatWidget extends StatelessWidget {
  final ChatContactModel chatContactData;
  const ChatWidget({super.key, required this.chatContactData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          // width: SizeConfig.screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      chatContactData.profilePic == ""
                          ? const CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  AssetImage("assets/images/grp_s_1.png"))
                          : CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  NetworkImage(chatContactData.profilePic),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildText(
                              text: chatContactData.name,
                              txtSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            buildSizeHeight(height: 2),
                            buildText(
                              text: chatContactData.lastMessage,
                              txtSize: 12,
                              color: AppColors.kHintColor,
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    buildText(
                        text: buildTimeChat(chatContactData.timeSent),

                        //  DateFormat.Hm().format(chatContactData.timeSent),
                        txtSize: 10,
                        color: AppColors.kHintColor),
                    buildSizeHeight(height: 5),
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: buildText(
                            text: "${chatContactData.unreadMessage}",
                            txtSize: 10,
                            color: Colors.black),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 3,
        ),
      ],
    );
  }
}
