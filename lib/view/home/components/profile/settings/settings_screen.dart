import 'package:flutter/material.dart';
import 'package:idute_app/components/widgets/app_bar.dart';
import 'package:idute_app/model/user_model.dart';

import 'components/body.dart';

class SettingScreen extends StatelessWidget {
  UserModel userModel;
  SettingScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "Settings",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Body(
        userModel: userModel,
      ),
    );
  }
}
