import 'package:flutter/material.dart';
import 'package:idute_app/components/widgets/app_bar.dart';

import '../../../../../../components/widgets/custom_list_tile.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "About Idute",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTile(
            onTap: () {},
            imageURL: "assets/icons/about_1.svg",
            text: "Privacy Policy",
          ),
          buildTile(
            onTap: () {},
            imageURL: "assets/icons/about_2.svg",
            text: "Terms of use",
          ),
          buildTile(
            onTap: () {},
            imageURL: "assets/icons/about_3.svg",
            text: "Third Party Notice",
          ),
        ],
      ),
    );
  }
}
