import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/controller/BuisnessLogic/posts/post_cubit.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/view/home/components/main/components/build_card_rows.dart';
import 'package:idute_app/view/home/components/main/components/card_details.dart';
import 'package:uuid/uuid.dart';
import '../../../../../components/constants/size_config.dart';
import '../../../../../components/helpers/dependencies.dart';
import '../../../../../components/widgets/custom_tff_outlined.dart';
import '../../../../../controller/BuisnessLogic/posts/comment_cubit.dart';
import '../../../../../controller/user_profile_controller.dart';
import '../../../../../domain/entity/comment_entity.dart';
import '../../../../../domain/entity/post_entity.dart';
import '../../../../../domain/usecases/upload_image_to_storage.dart';

class BuildCardList extends StatefulWidget {
  const BuildCardList({
    super.key,
    required this.posts,
  });
  final List<PostEntity> posts;

  @override
  State<BuildCardList> createState() => _BuildCardListState();
}

class _BuildCardListState extends State<BuildCardList> {
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

  _createComment(String postId, int index) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
      comment: CommentEntity(
        commentId: const Uuid().v1(),
        likes: const [],
        comment: textEditingControllers[index]!.text,
        userId: _currentUid,
        userName: user!.username,
        userProfileUrl: user!.profileImage,
        postId: postId,
        createdTime: DateTime.now(),
        totalReply: 0,
      ),
    )
        .then((value) {
      setState(() {
        textEditingControllers[index]!.clear();
        isCmtEmpty = true;
      });
    });
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
        left: getProportionateScreenWidth(10),
        right: getProportionateScreenWidth(10),
        bottom: getProportionateScreenHeight(4),
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
            side: const BorderSide(width: 2.5, color: Color(0x19C7FFDB)),
            borderRadius: BorderRadius.circular(15),
          ),
          color: AppColors.sBackgroundColor,
          elevation: 10,
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(15),
              bottom: getProportionateScreenHeight(15),
              top: getProportionateScreenHeight(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildFirstRow(
                  post: post,
                  context: context,
                ),
                buildSizeHeight(height: 20),
                buildSecondRow(post),
                buildSizeHeight(height: 20),
                post.audio!.isNotEmpty
                    ? BuildThirdRow(
                        post: post, sizeWidth: 23) // TODO audio fn pending
                    : buildSizeHeight(height: 0),
                post.audio!.isNotEmpty
                    ? buildSizeHeight(height: 26)
                    : buildSizeHeight(height: 0),
                _buildCmtField(post, index),
                buildSizeHeight(height: 20),
                BuildFifthRow(uid: uid, post: post),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildCmtField(PostEntity post, int index) {
    if (!textEditingControllers.containsKey(index)) {
      textEditingControllers[index] = TextEditingController();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 20),
      child: buildNewTextFormField(
        controller: textEditingControllers[index]!,
        height: 35,
        width: double.infinity,
        keyboardType: TextInputType.multiline,
        hintText: "What's your view",
        errorText: "",
        onChanged: (value) {
          if (textEditingControllers[index]!.text.isEmpty) {
            setState(() {
              isCmtEmpty = true;
            });
          } else {
            setState(() {
              isCmtEmpty = false;
            });
          }
        },
        isSuffixIconVisible: isCmtEmpty ? false : true,
        suffixIcon: Icons.send_rounded,
        onIconPressed: () {
          _createComment(
            post.postId.toString(),
            index,
          );
        },
      ),
    );
  }
}
