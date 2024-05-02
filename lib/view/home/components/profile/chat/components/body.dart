// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:idute_app/view/home/components/profile/chat/components/bottom_chat_field.dart';
import 'package:idute_app/view/home/components/profile/chat/components/chat_list.dart';

class Body extends StatelessWidget {
  final String recieverUserId;
  final String receiverUserName;
  const Body({
    Key? key,
    required this.recieverUserId,
    required this.receiverUserName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChatList(recieverUserId: recieverUserId),
        BottomChatField(
          recieverUserId: recieverUserId,
          isGroupChat: false,
          receiverUserName: receiverUserName,
        ),
      ],
    );
  }
}
