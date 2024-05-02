import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/widgets/normal_text_widget.dart';
import 'package:idute_app/controller/BuisnessLogic/posts/post_cubit.dart';
import 'package:idute_app/model/post/post_comments_model.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/timeago_util.dart';
import 'package:idute_app/view/home/components/main/components/build_card_rows.dart';
import 'package:idute_app/view/home/components/main/components/card_details.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../../components/constants/size_config.dart';
import '../../../../../components/helpers/dependencies.dart';
import '../../../../../components/widgets/custom_tff_outlined.dart';
import '../../../../../controller/BuisnessLogic/posts/comment_cubit.dart';
import '../../../../../controller/user_profile_controller.dart';
import '../../../../../domain/entity/comment_entity.dart';
import '../../../../../domain/entity/post_entity.dart';
import '../../../../../domain/usecases/upload_image_to_storage.dart';

class ReactedWidget extends StatefulWidget {
  ReactedWidget({
    super.key,
    required this.posts,
    required this.useruid,
  });
  final List<PostEntity> posts;
  String useruid;

  @override
  State<ReactedWidget> createState() => _ReactedWidgetState();
}

class _ReactedWidgetState extends State<ReactedWidget> {
  List<String> audioUrls = [];
  void loadUrl() {
    for (var i in widget.posts) {
      if (i.audio != "") {
        audioUrls.add(i.audio.toString());
      }
    }
  }

  PlayerController playerController = PlayerController();
  bool isStopped = false;
  String _currentUid = "";

  final Map<int, TextEditingController> textEditingControllers = {};
  FocusNode focusNode = FocusNode();
  bool isCmtEmpty = true;
  UserModel? user = UserModel();

  @override
  void initState() {
    sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
      fetchUserData();
    });
    // loadAudio();
    super.initState();
  }

  fetchUserData() async {
    user = await ProfileController().fetchUserProfileByUid(_currentUid);
  }

  loadAudio() async {
    final player = ap.AudioCache();
    final url = await player.load(audioUrls[0]);
    await playerController.preparePlayer(path: url.path);
  }

  void playandPause() async {
    playerController.playerState == PlayerState.playing
        ? await playerController.pausePlayer()
        : await playerController.startPlayer(finishMode: FinishMode.loop);
    isStopped = !isStopped;
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in textEditingControllers.values) {
      controller.dispose();
    }
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.posts.length,
          itemBuilder: (context, index) {
            return BlocProvider(
              create: (context) => sl<PostCubit>(),
              child: _buildCard(
                context,
                playerController,
                widget.posts[index],
                _currentUid,
                index,
              ),
            );
          }),
    );
  }

  Widget _buildCard(BuildContext context, PlayerController playerController,
      PostEntity post, String uid, int index) {
    return Padding(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(0),
        right: getProportionateScreenWidth(0),
        bottom: getProportionateScreenHeight(0),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardDetails(
                post: post,
                currentUid: uid,
                index: index,
              ),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          color: AppColors.sBackgroundColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(0),
              bottom: getProportionateScreenHeight(0),
              top: getProportionateScreenHeight(0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: buildFirstRow(
                    post: post,
                    context: context,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  padding: const EdgeInsets.only(left: 25),
                  decoration: const BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              width: 2, color: AppColors.kFillColor))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildText(
                            text: "Market Probelem :",
                            txtSize: 12,
                            fontWeight: FontWeight.bold),
                        buildText(
                          text: post.problem ?? "",
                          txtSize: 12,
                        ),
                        buildSizeHeight(height: 20),
                        post.audio!.isNotEmpty
                            ? BuildThirdRow(post: post, sizeWidth: 23)
                            : buildSizeHeight(height: 0),
                        post.audio!.isNotEmpty
                            ? buildSizeHeight(height: 26)
                            : buildSizeHeight(height: 0),
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                    future: FirebaseConstants.store
                        .collection("posts")
                        .doc(post.postId)
                        .collection("comment")
                        .where("userId", isEqualTo: widget.useruid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            commentData = snapshot.data!.docs;
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: commentData.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> cmtData =
                                  commentData[index].data();

                              PostCommentsModel comment =
                                  PostCommentsModel.fromMap(cmtData);
                              print(comment.createdTime);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: commentTile(comment),
                                    ),
                                    (index != commentData.length - 1)
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(left: 30),
                                            height: 20,
                                            width: 2,
                                            color: AppColors.kFillColor,
                                          )
                                        : Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            color: AppColors.kFillColor,
                                            width: SizeConfig.screenWidth,
                                            height: 2,
                                          ),
                                  ],
                                ),
                              );
                            });
                      }

                      if (snapshot.connectionState == ConnectionState.none) {
                        return buildText(
                            text: "Error in fetching comment", txtSize: 12);
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget commentTile(CommentEntity comment) {
    return Row(
      children: [
        (comment.userProfileUrl == null || comment.userProfileUrl == "")
            ? const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/icons/default.jpg"),
              )
            : CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(comment.userProfileUrl!),
              ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText(text: comment.userName!, txtSize: 12),
            // buildText(
            //     text:
            //         TimeAgo().timeAgo(Timestamp.fromDate(comment.createdTime!))),
            buildText(
                text: buildTimePost(comment.createdTime!),
                txtSize: 10,
                color: AppColors.kFillColor),
            buildText(text: comment.comment!, txtSize: 12)
          ],
        )
      ],
    );
  }
}
