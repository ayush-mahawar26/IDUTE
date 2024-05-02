// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../components/constants/size_config.dart';
import '../../../../../components/widgets/app_bar_icon.dart';
import '../../../../../components/widgets/normal_text_widget.dart';
import 'components/body.dart';

class ChatScreen extends ConsumerWidget {
  final String name;
  final String profileUrl;
  final String uid;

  const ChatScreen({
    Key? key,
    required this.name,
    required this.profileUrl,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            buildAppBarIcon(
              onTap: () {
                Navigator.pop(context);
              },
            ),
            buildSizeWidth(width: 17),
            profileUrl == ""
                ? const CircleAvatar(
                    // radius: 13,
                    backgroundImage: AssetImage("assets/images/grp_s_1.png"))
                : CircleAvatar(
                    // radius: 13,
                    backgroundImage: NetworkImage(profileUrl),
                  ),
            buildSizeWidth(width: 13),
            buildText(
              text: name,
              txtSize: 20,
            ),
          ],
        ),
      ),
      body: Body(
        recieverUserId: uid,
        receiverUserName: name,
      ),
    );
  }
}
