// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/components/enums/category_enums.dart';
import 'package:idute_app/components/widgets/custom_tff_outlined.dart';
import 'package:idute_app/components/widgets/post_bottomsheet.dart';
import 'package:idute_app/controller/notification_controllers.dart';
import 'package:intl/intl.dart';

import 'package:idute_app/components/enums/category_enums.dart';
import 'package:idute_app/components/widgets/custom_tff_outlined.dart';
import '../../../../../components/constants/colors.dart';

import '../../../../../components/constants/colors.dart';
import '../../../../../components/constants/size_config.dart';
import '../../../../../components/widgets/normal_text_widget.dart';
import '../../../../../controller/BuisnessLogic/posts/post_cubit.dart';
import '../../../../../domain/entity/post_entity.dart';

String buildTimePost(DateTime postTime) {
  final now = DateTime.now();
  final difference = now.difference(postTime);
  if (difference.inDays > 365) {
    return DateFormat('MMM d, y').format(postTime);
  } else if (difference.inDays > 30) {
    return DateFormat('MMM d').format(postTime);
  } else if (difference.inDays > 7) {
    return '${difference.inDays ~/ 7}w ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m ago';
  } else {
    return 'Just now';
  }
}

String buildTimeChat(DateTime postTime) {
  final now = DateTime.now();
  final difference = now.difference(postTime);
  if (difference.inDays > 365) {
    return DateFormat('MMM d, y').format(postTime);
  } else if (difference.inDays > 30) {
    return DateFormat('MMM d').format(postTime);
  } else if (difference.inDays > 7) {
    return '${difference.inDays ~/ 7} w';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} d';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} h';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} min';
  } else {
    return 'Just now';
  }
}

_showThreeDotPopUp(BuildContext context, String uid, PostEntity post) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.sBackgroundColor,
    builder: (BuildContext context) {
      return PostBottomSheet(
        uid: uid,
        post: post,
      );
    },
  );
}

Widget buildFirstRow(
    {double imgSize = 35,
    double contWidth = 61,
    double contHeight = 20,
    double iconSize = 25,
    double contDist = 10,
    double endWidth = 10,
    required BuildContext context,
    required PostEntity post}) {
  return Row(
    children: [
      post.userProfileUrl!.isNotEmpty
          ? CircleAvatar(
              backgroundImage: NetworkImage(
                post.userProfileUrl.toString(),
              ),
              radius: 20,
            )
          : const CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/grp_s_1.png",
              ),
              radius: 20,
            ),
      buildSizeWidth(width: 7),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText(
            text: post.userName ?? "",
            txtSize: 12,
          ),
          buildSizeHeight(height: 2),
          buildText(
            text: buildTimePost(post.createdTime!),
            txtSize: 10,
            color: const Color(0xFFB6B6B6),
          ),
        ],
      ),
      const Spacer(),
      Container(
        decoration: BoxDecoration(
            // color: AppColors.kcardColor,
            border: Border.all(color: AppColors.kHintColor, width: 1),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            )),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          child: buildText(
              text: post.category?.fromCategoryEnum() ?? "", txtSize: 10),
        )),
      ),
      buildSizeWidth(width: contDist),
      GestureDetector(
        onTap: () {
          _showThreeDotPopUp(
              context, post.userId.toString(), post);
        },
        child: SvgPicture.asset(
          "assets/icons/card_1.svg",
          width: iconSize,
          height: iconSize,
        ),
      ),
      buildSizeWidth(width: 5),
    ],
  );
}

Widget buildSecondRow(PostEntity post) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildText(
          text: "Market Probelem :", txtSize: 12, fontWeight: FontWeight.bold),
      buildText(
        text: post.problem ?? "",
        txtSize: 12,
      )
    ],
  );
}

class BuildThirdRow extends StatefulWidget {
  final PostEntity post;
  final double sizeWidth;
  const BuildThirdRow({super.key, required this.post, required this.sizeWidth});

  @override
  State<BuildThirdRow> createState() => _BuildThirdRowState();
}

class _BuildThirdRowState extends State<BuildThirdRow> {
  PlayerController playerController = PlayerController();

  ap.AudioPlayer audioPlayer = ap.AudioPlayer();
  bool isStopped = false;

  @override
  void initState() {
    super.initState();
  }

  loadAudio() async {
    print("hello${Uri.parse(widget.post.audio ?? "").path}");
    await playerController.preparePlayer(
      path: Uri.parse(widget.post.audio ?? "").path,
    );
  }

  void playandPause() async {
    // if (playerController.playerState == PlayerState.playing)

    if (!isStopped) {
      await audioPlayer.play(ap.UrlSource(widget.post.audio ?? ""));
      // await playerController.pausePlayer();
    } else {
      await audioPlayer.pause();

      playerController.stopAllPlayers();
      // loadAudio();
      // await playerController.startPlayer(finishMode: FinishMode.loop);
    }
    isStopped = !isStopped;
    setState(() {});
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildSizeWidth(width: 4),
        GestureDetector(
          onTap: playandPause,
          child: Container(
            width: 30,
            height: 30,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: isStopped
                ? const Icon(
                    Icons.pause_outlined,
                    size: 25,
                    color: Colors.black,
                  )
                : const Icon(
                    Icons.play_arrow,
                    size: 25,
                    color: Colors.black,
                  ),
          ),
        ),
        buildSizeWidth(width: 8),
        Expanded(
          child: AudioFileWaveforms(
            size: Size(
              double.infinity,
              getProportionateScreenHeight(20),
            ),
            playerController: playerController,
            enableSeekGesture: true,
            waveformType: WaveformType.fitWidth,
            continuousWaveform: true,
            playerWaveStyle: const PlayerWaveStyle(
              scaleFactor: 100,
              fixedWaveColor: Color(0xffa1a1a1),
              liveWaveColor: Colors.white,
              waveCap: StrokeCap.round,
            ),
          ),
        ),
        buildSizeWidth(width: widget.sizeWidth),
      ],
    );
  }
}

Widget buildThirdRow(PlayerController playerController, VoidCallback onTap,
    bool isStopped, double sizeWidth, PostEntity post) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      buildSizeWidth(width: 4),
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: isStopped
              ? const Icon(
                  Icons.pause_outlined,
                  size: 25,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.play_arrow,
                  size: 25,
                  color: Colors.black,
                ),
        ),
      ),
      buildSizeWidth(width: 8),
      Expanded(
        child: AudioFileWaveforms(
          size: Size(
            double.infinity,
            getProportionateScreenHeight(20),
          ),
          playerController: playerController,
          enableSeekGesture: true,
          waveformType: WaveformType.fitWidth,
          continuousWaveform: true,
          playerWaveStyle: const PlayerWaveStyle(
            scaleFactor: 100,
            fixedWaveColor: Color(0xffa1a1a1),
            liveWaveColor: Colors.white,
            waveCap: StrokeCap.round,
          ),
        ),
      ),
      buildSizeWidth(width: sizeWidth),
    ],
  );
}

Widget buildFourthRow() {
  return Padding(
    padding: const EdgeInsets.only(left: 2, right: 20),
    child: buildNewTextFormField(
      controller: TextEditingController(),
      height: 35,
      bgColor: AppColors.kcardColor,
      width: double.infinity,
      keyboardType: TextInputType.multiline,
      hintText: "Write your comments",
      errorText: "",
      isSuffixIconVisible: true,
      suffixIcon: Icons.send_rounded,
      onIconPressed: () => () {},
    ),
  );
}

class BuildFifthRow extends StatefulWidget {
  double contWidth = 50;
  double contHeight = 21;
  double iconSize = 24;
  double sizeWidth = 15;
  String uid;
  final PostEntity post;

  BuildFifthRow({
    Key? key,
    this.contWidth = 75,
    this.contHeight = 25,
    this.iconSize = 24,
    this.sizeWidth = 15,
    required this.uid,
    required this.post,
  }) : super(key: key);

  @override
  State<BuildFifthRow> createState() => _BuildFifthRowState();
}

class _BuildFifthRowState extends State<BuildFifthRow> {
  bool isValidate = false;

  _validatePost() async {
    BlocProvider.of<PostCubit>(context).validatePost(post: widget.post);
    await NotificationControllers().notificationOnLike(widget.post);
  }

  _viewed(PostEntity post) async {
    await FirebaseConstants.store
        .collection("posts")
        .doc(post.postId)
        .set({"views": FieldValue.increment(1)}, SetOptions(merge: true));
  }

  @override
  void initState() {
    super.initState();
    // _viewed(widget.post);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            _validatePost();
          },
          customBorder: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFF555555),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 80,
            height: widget.contHeight,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: widget.post.validate!.isEmpty
                      ? const Color(0xFF555555)
                      : widget.post.validate!.contains(widget.uid)
                          ? const Color(0xFF67AC6E)
                          : const Color(0xFF555555),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Center(
              child: buildText(
                text: widget.post.validate!.contains(widget.uid)
                    ? "Validated"
                    : "Validate",
                txtSize: 12,
                color: widget.post.validate!.isEmpty
                    ? Colors.white
                    : widget.post.validate!.contains(widget.uid)
                        ? const Color(0xFF67AC6E)
                        : Colors.white,
              ),
            ),
          ),
        ),
        buildSizeWidth(width: 7),
        buildText(
          text: "by ${widget.post.totalValidates.toString()} entrepreneur",
          txtSize: 10,
          color: Colors.white,
        ),
        const Spacer(),
        SvgPicture.asset(
          "assets/icons/card_2.svg",
          color: Colors.white,
          width: widget.iconSize,
          height: widget.iconSize,
        ),
        buildSizeWidth(width: 3),
        buildText(
          text: "${widget.post.comments}",
          txtSize: 10,
          color: Colors.white,
        ),
        const SizedBox(
          width: 12,
        ),
        InkWell(
          onTap: () {
            _show(context);
          },
          child: SizedBox(
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.graph_square_fill,
                  color: Colors.white,
                ),
                buildSizeWidth(width: 5),
                buildText(
                    text: widget.post.views!.toString(),
                    txtSize: 10,
                    color: Colors.white),
              ],
            ),
          ),
        ),
        buildSizeWidth(width: widget.sizeWidth)
      ],
    );
  }
}

Widget buildFifthRow(
    {required BuildContext context,
    double contWidth = 50,
    double contHeight = 21,
    double iconSize = 24,
    double sizeWidth = 14}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // InkWell(
      //   child: Container(
      //     decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(12),
      //         border: Border.all(width: 1, color: AppColors.kHintColor)),
      //     child: Center(
      //         child: Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      //       child: buildText(
      //           text: "Validate",
      //           txtSize: 12,
      //           color: AppColors.kBackgroundColor),
      //     )),
      //   ),
      // ),
      const Icon(
        CupertinoIcons.check_mark_circled,
        color: Colors.white,
      ),
      buildSizeWidth(width: 5),
      buildText(
        text: "10k Validation",
        txtSize: 10,
        color: Colors.white,
      ),
      const Spacer(),
      SvgPicture.asset(
        "assets/icons/card_2.svg",
        width: iconSize,
        height: iconSize,
        color: Colors.white,
      ),
      buildSizeWidth(width: 5),
      buildText(
        text: "59k Comments",
        txtSize: 10,
        color: Colors.white,
      ),
      buildSizeWidth(width: sizeWidth),

      InkWell(
        onTap: () {
          _show(context);
        },
        child: SizedBox(
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.graph_square_fill,
                color: Colors.white,
              ),
              buildSizeWidth(width: 5),
              buildText(text: "59 views", txtSize: 12, color: Colors.white),
            ],
          ),
        ),
      ),
      buildSizeWidth(width: sizeWidth),
    ],
  );
}

_show(BuildContext ctx) {
  return showModalBottomSheet(
    context: ctx,
    backgroundColor: AppColors.sBackgroundColor,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            decoration: const BoxDecoration(
                // color: AppColors.sBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: AppColors.kFillColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: buildText(text: "Views", txtSize: 20)),
                      const Divider(
                        thickness: 0,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildText(
                                  text:
                                      "Times this post was seen. To learn more to visit , Help Center"),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
