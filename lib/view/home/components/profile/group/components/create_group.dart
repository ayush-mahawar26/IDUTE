import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/group_controller.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/user_model.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  List<String> categoryList = [];

  final TextEditingController _title = TextEditingController();

  final TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(hintText: "Group Title"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(hintText: "Group Description"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  GroupModel model = GroupModel(
                      groupImg: "",
                      title: _title.text.trim(),
                      description: _description.text.trim(),
                      createdAt: Timestamp.now(),
                      category: "Technology",
                      level: 0,
                      createdByName: FirebaseConstants
                          .firebaseAuth.currentUser!.displayName!,
                      createdBy:
                          FirebaseConstants.firebaseAuth.currentUser!.uid);
                  UserModel? user = await ProfileController()
                      .fetchUserProfileByUid(
                          FirebaseConstants.firebaseAuth.currentUser!.uid);
                  GroupController().addNewGroup(model, user!);
                },
                child: buildText(text: "Create"))
          ],
        ),
      ),
    );
  }
}
