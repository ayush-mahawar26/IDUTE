import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:idute_app/components/constants/size_config.dart';
import 'package:idute_app/components/widgets/app_bar_icon.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/view/home/components/profile/chat/components/bottom_chat_field.dart';

import '../../../../../../components/constants/colors.dart';
import '../../../../../../model/message.dart';
import '../../chat/components/chat_bubble.dart';

class GroupChatScreen extends StatelessWidget {
  const GroupChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Message> messages = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 10,
        automaticallyImplyLeading: false,
        toolbarHeight: 96,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        flexibleSpace: SafeArea(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildAppBarIcon(onTap: () {}),
                buildSizeWidth(width: 12),
                SizedBox(
                  width: getProportionateScreenWidth(259),
                  child: buildText(
                    text:
                        "Individual development significant effect defining a clear plan to hope ",
                    txtSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: GroupedListView<Message, String>(
                reverse: true,
                // order: GroupedListOrder.DESC,
                elements: messages,
                groupBy: (message) => message.messageId,
                groupHeaderBuilder: (element) => Padding(
                  padding: const EdgeInsets.all(13),
                  child: Column(
                    children: [
                      const Divider(
                        color: Colors.black,
                      ),
                      buildText(
                        text: element.messageId,
                        txtSize: 10,
                        color: AppColors.kHintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context, element) {
                  return ChatBubble(
                    messageController: ScrollController(),
                    onMessageSwipe: () {},
                    message: element,
                    isGroup: true,
                  );
                },
              ),
            ),
          ),
          const BottomChatField(
              recieverUserId: "", receiverUserName: "", isGroupChat: true),
        ],
      ),
    );
  }
}
