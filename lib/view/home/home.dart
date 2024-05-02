import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/constants/urls.dart';
import 'package:idute_app/components/widgets/bottombar.widget.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/bottombar_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/state/bottombar_states.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/iq_model.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/notification_services.dart';
import 'package:idute_app/view/home/components/profile/group/components/invitelink_group.dart';
import 'package:idute_app/view/profile/profile_screen_widget.dart';
import 'package:idute_app/view/profile/visit_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PendingDynamicLinkData? link;

  final FirebaseFirestore _store = FirebaseConstants.store;
  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;

  @override
  void initState() {
    super.initState() ;
    gettingDynamicLinkData();
    NotificationServices().requestNotificationPermissions();
    NotificationServices().firebaseNotificationInit(context);
    NotificationServices().getToken().then((devicetoken) async {
      await FirebaseConstants.store
          .collection("Users")
          .doc(FirebaseConstants.firebaseAuth.currentUser!.uid)
          .set({"fcm": devicetoken}, SetOptions(merge: true));

      print("Token Updated into firebase");
      await createIq(FirebaseConstants.firebaseAuth.currentUser!.uid);
    });
  }

  createIq(String useruid) async {
    DocumentSnapshot<Map<String, dynamic>> iq =
        await _store.collection("iq").doc(useruid).get();
    if (!iq.exists) {
      IqModel iqModel = IqModel(
          postCount: 0,
          validationCount: 0,
          commentCount: 0,
          replyCount: 0,
          likeOnCommentCount: 0,
          likeOnReplyCount: 0,
          connectionCount: 0,
          connectionWithHigherIq: 0);
      await _store
          .collection("iq")
          .doc(useruid)
          .set(iqModel.toMap(), SetOptions(merge: true));
    }
  }

  gettingDynamicLinkData() async {
    link = await FirebaseConstants.dynamicLink.getInitialLink();

    FirebaseConstants.dynamicLink.onLink.listen((dynamicLinkData) {
      link = dynamicLinkData;

      if (mounted) {
        setState(() {});
      }
    }).onError((error) {
      print(error);
    });
  }

  Future<UserModel> getUserProfile(String userId) async {
    UserModel? user = await ProfileController().fetchUserProfileByUid(userId);
    return user!;
  }

  @override
  Widget build(BuildContext context) {
    if (link != null) {
      if (link!.link.queryParameters.containsKey("user")) {
        String? userId = link?.link.queryParameters["user"];
        return FutureBuilder(
            future: getUserProfile(userId!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.uid! ==
                    FirebaseConstants.firebaseAuth.currentUser!.uid) {
                  return const ProfileScreenWidget();
                } else {
                  return VisitUserProfile(userModel: snapshot.data!);
                }
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            });
      }
      if (link!.link.queryParameters.containsKey("group")) {
        String? group = link?.link.queryParameters["group"];

        print("${group}groupID");
        return InviteLinkForGroup(groupId: group!);
      }
    }
    return Scaffold(
      backgroundColor: AppColors.sBackgroundColor,
      bottomNavigationBar: const BottomBarWidget(),
      body: BlocBuilder<LandingPageCubit, LandingPageState>(
          builder: (context, state) {
        return UrlConstants.bottombarWidgets[state.tabIndex];
      }),
    );
  }
}
