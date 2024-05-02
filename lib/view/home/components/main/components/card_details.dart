// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/view/home/components/main/components/search.view.dart';
import 'package:idute_app/view/home/components/profile/chat/message_view.dart';
import 'package:uuid/uuid.dart';

import 'package:idute_app/components/helpers/dependencies.dart';
import 'package:idute_app/domain/entity/post_entity.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/view/home/components/main/components/build_card_rows.dart';
import 'package:idute_app/view/home/components/main/components/home_app_bar.dart';

import '../../../../../components/constants/colors.dart';
import '../../../../../components/constants/size_config.dart';
import '../../../../../components/widgets/normal_text_widget.dart';
import '../../../../../controller/BuisnessLogic/posts/comment_cubit.dart';
import '../../../../../controller/BuisnessLogic/posts/get_single_post_cubit.dart';
import '../../../../../controller/BuisnessLogic/posts/post_cubit.dart';
import '../../../../../controller/BuisnessLogic/posts/reply_cubit.dart';
import '../../../../../controller/user_profile_controller.dart';
import '../../../../../domain/entity/comment_entity.dart';
import '../../../../../domain/entity/reply_entity.dart';

class CardDetails extends StatefulWidget {
  final int index;
  final PostEntity post;
  final String currentUid;
  const CardDetails(
      {super.key,
      required this.post,
      required this.currentUid,
      required this.index});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  PlayerController playerController = PlayerController();
  bool isStopped = false;
  bool isCmtEmpty = true;
  bool isReplying = false;
  bool isShowReplyList = false;
  String text = "Replying to xx";
  String cmtPostId = "";
  String cmtId = "";
  TextEditingController commentController = TextEditingController();
  FocusNode focusNode = FocusNode();
  UserModel? user = UserModel();

  @override
  void initState() {
    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.post.postId!);

    BlocProvider.of<CommentCubit>(context)
        .getComments(postId: widget.post.postId!);
    fetchUserData(widget.currentUid);
    // loadAudio();
    super.initState();
  }

  loadAudio() async {
    final player = ap.AudioCache(prefix: "assets/files/");
    final url = await player.load("peacock.mp3");
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
    playerController.dispose();
    super.dispose();
  }

  fetchUserData(String userId) async {
    user = await ProfileController().fetchUserProfileByUid(widget.currentUid);
  }

  _createComment(String currentUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
      comment: CommentEntity(
        commentId: const Uuid().v1(),
        likes: const [],
        comment: commentController.text,
        userId: currentUser,
        userName: user!.username,
        userProfileUrl: user!.profileImage ?? "",
        postId: widget.post.postId,
        createdTime: DateTime.now(),
        totalReply: 0,
      ),
    )
        .then((value) {
      setState(() {
        commentController.clear();
        isCmtEmpty = true;
      });
    });
  }

  _likeComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context).likeComment(
      comment: CommentEntity(
        postId: comment.postId,
        commentId: comment.commentId,
      ),
    );
  }

  _likeReply({required ReplyEntity reply}) {
    BlocProvider.of<ReplyCubit>(context).likeReply(
        reply: ReplyEntity(
            postId: reply.postId,
            commentId: reply.commentId,
            replyId: reply.replyId));
  }

  _createReply() {
    BlocProvider.of<ReplyCubit>(context)
        .createReply(
      reply: ReplyEntity(
        replyId: const Uuid().v1(),
        createdTime: DateTime.now(),
        likes: [],
        userName: user!.username,
        userProfileUrl: user!.profileImage ?? "",
        reply: commentController.text,
        userId: widget.currentUid,
        postId: cmtPostId,
        commentId: cmtId,
      ),
    )
        .then((value) {
      setState(() {
        commentController.clear();
        isShowReplyList = true;
        isReplying = false;
        isCmtEmpty = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(
          isTitle: false,
          backFunc: () {
            Navigator.pop(context);
          },
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MessageScreen())),
          searchTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SearchView()));
          }),
      body: BlocProvider(
        create: (context) => sl<PostCubit>()..getPosts(post: widget.post),
        child: BlocBuilder<PostCubit, PostState>(builder: (context, postState) {
          if (postState is PostLoaded) {
            return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
                builder: (context, singlePost) {
              if (singlePost is GetSinglePostLoaded) {
                return BlocBuilder<CommentCubit, CommentState>(
                  builder: (context, commentState) {
                    if (commentState is CommentLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (commentState is CommentFailure) {
                      return const Center(
                        child: Text("abs"),
                      );
                    }
                    if (commentState is CommentLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildContent(widget.post, widget.currentUid),
                          _buildComments(commentState.comments),
                          _buildReplyTextContainer(),
                          isReplying
                              ? const Divider(
                                  endIndent: 0,
                                  height: 0,
                                )
                              : const SizedBox(),
                          _buildCmtField(),
                        ],
                      );
                    }
                    return Center(
                      child: buildText(text: "Error"),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }

  Widget _buildContent(PostEntity post, String uid) {
    return BlocProvider(
      create: (context) => sl<PostCubit>(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(12),
              top: getProportionateScreenHeight(16),
              bottom: getProportionateScreenHeight(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildFirstRow(
                  imgSize: 35,
                  contWidth: 70,
                  contHeight: 23,
                  iconSize: 22,
                  contDist: 17,
                  endWidth: 18,
                  post: post,
                  context: context,
                ),
                buildSizeHeight(height: 24),
                _buildSecondRow(post),
                buildSizeHeight(height: 26),
                post.audio!.isNotEmpty
                    ? BuildThirdRow(post: post, sizeWidth: 28)
                    : buildSizeHeight(height: 0),
                post.audio!.isNotEmpty
                    ? buildSizeHeight(height: 21)
                    : buildSizeHeight(height: 0),
                BuildFifthRow(
                  contWidth: 57,
                  contHeight: 25,
                  iconSize: 28,
                  sizeWidth: 9,
                  uid: uid,
                  post: post,
                ),

                buildSizeHeight(height: 10),
                // buildText(
                //   text: "Comments : ",
                //   fontWeight: FontWeight.w700,
                //   txtSize: 10,
                // ),
              ],
            ),
          ),
          const Divider(
            thickness: 0,
            color: AppColors.kFillColor,
          ),
        ],
      ),
    );
  }

  Padding _buildSecondRow(PostEntity post) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: buildText(
        text: "Market Opportunity :\n${post.problem}",
        fontWeight: FontWeight.w700,
        txtSize: 10,
        maxLine: 3,
      ),
    );
  }

  Expanded _buildComments(List<CommentEntity> comment) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) {
          return BlocProvider(
            create: (context) => sl<ReplyCubit>(),
            child: _buildCommentLoop(comment[index]),
          );
        },
        separatorBuilder: (context, index) => const Divider(
          thickness: 1,
        ),
        itemCount: comment.length,
      ),
    );
  }

  Padding _buildCommentLoop(CommentEntity comment) {
    return Padding(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(10),
        // right: getProportionateScreenWidth(30),
        top: getProportionateScreenHeight(5),
        bottom: getProportionateScreenHeight(0),
      ),
      child: BlocProvider(
        create: (context) => sl<ReplyCubit>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildChatContent(
              profileUrl: comment.userProfileUrl ?? "",
              userName: comment.userName ?? "",
              comment: comment.comment ?? "",
              createdTime: buildTimePost(comment.createdTime!),
              totalLikes: comment.likes!.length.toString(),
              likes: comment.likes,
              commentEntity: comment,
              replyEntity: ReplyEntity(),
            ),
            buildSizeHeight(height: 10),
            Padding(
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(42),
              ),
              child: comment.totalReply! > 0
                  ? InkWell(
                      onTap: () async {
                        setState(() {
                          isShowReplyList = !isShowReplyList;
                        });
                        if (isShowReplyList) {
                          await BlocProvider.of<ReplyCubit>(context).getReplys(
                            reply: ReplyEntity(
                              postId: comment.postId,
                              commentId: comment.commentId,
                            ),
                          );
                          print(comment.postId);
                          print(comment.commentId);
                        }
                      },
                      child: buildText(
                        text: !isShowReplyList ? "Replies:" : "Hide Replies",
                        txtSize: 8,
                        color: const Color(0xFFB6B6B6),
                      ),
                    )
                  : const SizedBox(),
            ),
            buildSizeHeight(height: 7),
            isShowReplyList
                ? _buildReplies(comment)
                : const SizedBox(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplies(CommentEntity comment) {
    return Padding(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(42),
      ),
      child: BlocBuilder<ReplyCubit, ReplyState>(
        builder: (context, replyState) {
          // BlocProvider.of<ReplyCubit>(context).getReplys(
          //   reply: ReplyEntity(
          //       postId: comment.postId, commentId: comment.commentId),
          // );
          if (replyState is ReplyLoaded) {
            final replys = replyState.replys
                .where((element) => element.commentId == comment.commentId)
                .toList();
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: replys.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: buildChatContent(
                    profileUrl: replys[index].userProfileUrl ?? "",
                    userName: replys[index].userName ?? "",
                    comment: replys[index].reply ?? "",
                    createdTime: buildTimePost(replys[index].createdTime!),
                    totalLikes: replys[index].likes!.length.toString(),
                    likes: replys[index].likes,
                    commentEntity: comment,
                    replyEntity: replys[index],
                  ),
                );
              },
            );
          }
          if (replyState is ReplyFailure) {
            buildText(text: "Error");
          }
          if (replyState is ReplyLoading) {
            buildText(text: "Loading");
          }
          if (replyState is ReplyInitial) {
            buildText(text: "Initial");
          }
          print(replyState);
          return buildText(text: "Abc");
        },
      ),
    );
  }

  Widget buildChatContent({
    required String profileUrl,
    required String userName,
    required String comment,
    required String createdTime,
    required String totalLikes,
    required List<String>? likes,
    required CommentEntity commentEntity,
    required ReplyEntity replyEntity,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profileUrl.isNotEmpty
            ? CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(profileUrl.toString()),
              )
            : Image.asset(
                "assets/images/grp_s_1.png",
                height: 30,
                width: 30,
              ),
        buildSizeWidth(width: 7),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildText(
              text: userName,
              txtSize: 12,
            ),
            buildSizeHeight(height: 2),
            buildText(
              text: createdTime,
              txtSize: 8,
              color: const Color(0xFFB6B6B6),
            ),
            buildSizeHeight(height: 3),
            Card(
              color: AppColors.kcardColor,
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: buildText(
                  text: comment,
                  txtSize: 12,
                ),
              ),
            ),
            buildSizeHeight(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildSizeWidth(width: 8),

                buildSizeWidth(width: 4),
                GestureDetector(
                  onTap: () => isShowReplyList
                      ? _likeReply(reply: replyEntity)
                      : _likeComment(comment: commentEntity),
                  child: !likes!.contains(widget.currentUid)
                      ? const Icon(
                          Icons.thumb_up_off_alt_outlined,
                          color: Colors.white,
                          size: 16,
                        )
                      : const Icon(
                          Icons.thumb_up_off_alt_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                ),
                const SizedBox(
                  width: 8,
                ),
                buildText(
                  text: totalLikes,
                  txtSize: 10,
                ),

                // buildSizeWidth(width: 5),
                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       isReplying = true;
                //       isCmtEmpty = false;
                //     });
                //     text = "Replies to $userName...";
                //     cmtPostId = commentEntity.postId.toString();
                //     cmtId = commentEntity.commentId.toString();
                //     commentController.text = "@$userName ";
                //     FocusScope.of(context).requestFocus(focusNode);
                //   },
                //   child: const Icon(
                //     Icons.reply,
                //     color: Colors.white,
                //     size: 16,
                //   ),
                // ),
              ],
            ),
          ],
        ),
        buildSizeWidth(width: 67),
      ],
    );
  }

  Widget _buildReplyTextContainer() {
    return isReplying
        ? Container(
            width: double.infinity,
            height: getProportionateScreenHeight(50),
            color: const Color(0xFF2B2B2B),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildSizeWidth(width: 10),
                buildText(
                  text: text,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isReplying = false;
                      isCmtEmpty = true;
                    });
                    commentController.clear();
                  },
                  iconSize: 24,
                  color: Colors.white,
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          )
        : const SizedBox();
  }

  TextFormField _buildCmtField() {
    return TextFormField(
      controller: commentController,
      focusNode: focusNode,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(
        fontSize: (15),
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      onChanged: (value) {
        if (commentController.text.isEmpty) {
          setState(() {
            isCmtEmpty = true;
          });
        } else {
          setState(() {
            isCmtEmpty = false;
          });
        }
      },
      minLines: null,
      maxLines: null,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          color: AppColors.kFillColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: AppColors.kcardColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        hintText:
            isReplying ? "Write your replies..." : "Write your comments...",
        hintStyle: const TextStyle(
          fontSize: 12,
          color: Color(0xFFB6B6B6),
          fontWeight: FontWeight.w400,
          fontFamily: "inter",
        ),
        suffixIcon: Visibility(
          visible: !isCmtEmpty,
          child: IconButton(
            color: Colors.white,
            onPressed: () => !isReplying
                ? _createComment(widget.currentUid)
                : _createReply(), // TODO comment Entity is pending
            icon: Icon(
              Icons.send_rounded,
              size: getProportionateScreenWidth(25),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// class BuildReplies extends StatefulWidget {
//   CommentEntity comment;
//   VoidCallback widget;
//   BuildReplies({
//     Key? key,
//     required this.comment,
//     required this.widget,
//   }) : super(key: key);

//   @override
//   State<BuildReplies> createState() => _BuildRepliesState();
// }

// class _BuildRepliesState extends State<BuildReplies> {
//   CommentEntity comment = CommentEntity();
//   @override
//   void initState() {
//     comment = widget.comment;
//     BlocProvider.of<ReplyCubit>(context).getReplys(
//       reply: ReplyEntity(postId: comment.postId, commentId: comment.commentId),
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: getProportionateScreenWidth(42),
//       ),
//       child: BlocProvider(
//         create: (context) => sl<ReplyCubit>(),
//         child: BlocBuilder<ReplyCubit, ReplyState>(
//           builder: (context, replyState) {
//             if (replyState is ReplyLoaded) {
//               final replys = replyState.replys
//                   .where((element) => element.commentId == comment.commentId)
//                   .toList();
//               return ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: replys.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: buildChatContent(
//                       profileUrl: replys[index].userProfileUrl ?? "",
//                       userName: replys[index].userName ?? "",
//                       comment: replys[index].reply ?? "",
//                       createdTime: buildTimePost(replys[index].createdTime!),
//                       totalLikes: replys[index].likes!.length.toString(),
//                       likes: replys[index].likes,
//                       commentEntity: comment,
//                       replyEntity: replys[index],
//                     ),
//                   );
//                 },
//               );
//             }
//             if (replyState is ReplyFailure) {
//               buildText(text: "Error");
//             }
//             if (replyState is ReplyLoading) {
//               buildText(text: "Loading");
//             }
//             if (replyState is ReplyInitial) {
//               buildText(text: "Initial");
//             }
//             print(replyState);
//             return buildText(text: "Abc");
//           },
//         ),
//       ),
//     );
//   }
// }
