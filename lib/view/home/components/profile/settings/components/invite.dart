import 'package:flutter/material.dart';
import 'package:idute_app/components/widgets/app_bar.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';

import '../../../../../../components/widgets/custom_list_tile.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "Invite friends",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 5,
            ),
            child: buildText(
              text: "Invite Via",
              txtSize: 14,
            ),
          ),
          buildTile(
            onTap: () {},
            imageURL: "assets/icons/invite_1.svg",
            text: "Whatsapp",
          ),
          buildTile(
            onTap: () {},
            imageURL: "assets/icons/invite_2.svg",
            text: "Instagram",
          ),
          buildTile(
            onTap: () {},
            imageURL: "assets/icons/invite_3.svg",
            text: "Email",
          ),
          buildTile(
            onTap: () {},
            imageURL: "assets/icons/invite_4.svg",
            text: "SMS",
          ),
          buildTile(
            onTap: () {},
            imageURL: "assets/icons/invite_5.svg",
            text: "Share by...",
          ),
          buildTile(
            onTap: () {},
            imageURL: "assets/icons/invite_6.svg",
            text: "Copy link to Clipboard",
          ),
        ],
      ),
    );
  }
}
