import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/view/auth/auth_screen.dart';

class SentPasswordView extends StatelessWidget {
  bool loggedIn;
  String email;
  SentPasswordView({super.key, required this.email, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildText(
                text: "Password Link Send to", fontWeight: FontWeight.bold),
            buildText(text: email, fontWeight: FontWeight.bold),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.kBackgroundColor),
                ),
                onPressed: () async {
                  if (loggedIn) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const AuthView()),
                        (route) => false);
                  }
                },
                child: buildText(text: "Done", txtSize: 15))
          ],
        ),
      ),
    );
  }
}
