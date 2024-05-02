import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idute_app/components/enums/message_enum.dart';
import 'package:idute_app/view/home/components/profile/chat/components/display_chat_compnents.dart';
import 'package:idute_app/view/home/components/profile/chat/components/visible_component.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../../../components/constants/size_config.dart';
import '../../../../../../components/widgets/normal_text_widget.dart';
import '../../../../../../model/message.dart';

class ChatBubble extends ConsumerWidget {
  final Message message;
  final bool isGroup;
  final VoidCallback onMessageSwipe;
  final ScrollController messageController;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isGroup,
    required this.onMessageSwipe,
    required this.messageController,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReplying = message.repliedMessage.isNotEmpty;

    return SwipeTo(
      key: UniqueKey(),
      iconColor: Colors.white,
      onRightSwipe: (details) => onMessageSwipe(),
      child: Align(
        alignment: message.senderId == FirebaseAuth.instance.currentUser!.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: message.senderId ==
                  FirebaseAuth.instance.currentUser!.uid
              ? BoxConstraints(
                  maxWidth:
                      SizeConfig.screenWidth - getProportionateScreenWidth(109),
                )
              : BoxConstraints(
                  maxWidth:
                      SizeConfig.screenWidth - getProportionateScreenWidth(87),
                ),
          child: message.senderId == FirebaseAuth.instance.currentUser!.uid
              ? isGroup
                  ? _customSenderMessageCard(isGroup, context, isReplying)
                  : _customSenderMessageCard(isGroup, context, isReplying)
              : _customReceiverMessageCard(isGroup, context, isReplying),
        ),
      ),
    );
  }

  Widget _customSenderMessageCard(
      bool isGroup, BuildContext context, bool isReplying) {
    return isReplying
        ? _buildReplyWidget(isGroup, context)
        : messageWidget(isGroup, context);
  }

  Widget _buildReplyWidget(bool isGroup, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: Colors.white.withOpacity(0.09000000357627869),
        ),
        borderRadius:
            isGroup ? BorderRadius.circular(10) : BorderRadius.circular(5),
      ),
      color: isGroup
          ? message.senderId == FirebaseAuth.instance.currentUser!.uid
              ? const Color(0xff151515)
              : const Color(0xff2b2b2b)
          : const Color(0xff2b2b2b),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildSizeHeight(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: InkWell(
              onTap: () {
                messageController
                    .jumpTo(messageController.position.minScrollExtent);
              },
              child: IntrinsicHeight(
                child: Material(
                  color: const Color.fromARGB(255, 83, 82, 82).withOpacity(0.3),
                  child: Row(
                    // alignment: WrapAlignment.start,
                    // crossAxisAlignment: WrapCrossAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: Colors.grey,
                        width: 4,
                      ),
                      buildSizeWidth(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildText(
                              text: message.repliedTo,
                              fontWeight: FontWeight.bold,
                            ),
                            DisplayTextImageGIF(
                              message: message.repliedMessage,
                              type: message.repliedMessageType,
                              isReply: true,
                            ),
                            buildSizeHeight(height: 2),
                          ],
                        ),
                      ),
                      message.repliedMessageType == MessageEnum.image
                          ? Image.network(
                              message.repliedMessage,
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill,
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildReplyTextPreview(context),
        ],
      ),
    );
  }

  Padding _buildReplyTextPreview(BuildContext context) {
    return Padding(
      padding:
          message.type == MessageEnum.text || message.type == MessageEnum.audio
              ? const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                  right: 10,
                )
              : EdgeInsets.zero,
      child:
          message.type == MessageEnum.text || message.type == MessageEnum.audio
              ? message.text.length > 30
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      alignment: WrapAlignment.end,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            10,
                            4,
                            message.text.length > 30 ? 0 : 8,
                            2,
                          ),
                          child: DisplayTextImageGIF(
                            message: message.text,
                            type: message.type,
                          ),
                        ),
                        buildText(
                          text: DateFormat('h:mm a')
                              .format(message.timeSent)
                              .toLowerCase(),
                          txtSize: 7,
                          color: const Color(0xFF8D8C8C),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      // alignment: WrapAlignment.end,
                      // verticalDirection: VerticalDirection.down,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            10,
                            4,
                            message.text.length > 40 ? 0 : 8,
                            2,
                          ),
                          child: DisplayTextImageGIF(
                            message: message.text,
                            type: message.type,
                          ),
                        ),
                        const Spacer(),
                        buildText(
                          text: DateFormat('h:mm a')
                              .format(message.timeSent)
                              .toLowerCase(),
                          txtSize: 7,
                          color: const Color(0xFF8D8C8C),
                        ),
                      ],
                    )
              : _buildImgPreview(context),
    );
  }

  Card messageWidget(bool isGroup, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: isGroup
          ? message.senderId == FirebaseAuth.instance.currentUser!.uid
              ? const Color(0xff151515)
              : const Color(0xff2b2b2b)
          : const Color(0xff2b2b2b),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: Colors.white.withOpacity(0.09000000357627869),
        ),
        borderRadius:
            isGroup ? BorderRadius.circular(10) : BorderRadius.circular(5),
      ),
      child:
          message.type == MessageEnum.text || message.type == MessageEnum.audio
              ? Padding(
                  padding: const EdgeInsets.only(
                    bottom: 4,
                    right: 10,
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    alignment: WrapAlignment.end,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          10,
                          4,
                          message.text.length > 40 ? 0 : 8,
                          2,
                        ),
                        child: DisplayTextImageGIF(
                          message: message.text,
                          type: message.type,
                        ),
                      ),
                      buildText(
                        text: DateFormat('h:mm a')
                            .format(message.timeSent)
                            .toLowerCase(),
                        txtSize: 7,
                        color: const Color(0xFF8D8C8C),
                      ),
                    ],
                  ),
                )
              : _buildImgPreview(context),
    );
  }

  GestureDetector _buildImgPreview(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (message.type == MessageEnum.image) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return VisibleImage(imageUrl: message.text);
              },
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Stack(
          children: [
            DisplayTextImageGIF(
              message: message.text,
              type: message.type,
            ),
            Positioned(
              bottom: 2,
              right: 5,
              child: buildText(
                text:
                    DateFormat('h:mm a').format(message.timeSent).toLowerCase(),
                txtSize: 7,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF8D8C8C),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row _customReceiverMessageCard(
      bool isGroup, BuildContext context, bool isReplying) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment:
          isGroup ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: isGroup ? 5.0 : 0, bottom: 12),
          child: CircleAvatar(
            radius: isGroup ? 17.5 : 13.5,
            backgroundImage: const AssetImage("assets/images/grp_s_1.png"),
          ),
        ),
        buildSizeWidth(width: isGroup ? 15 : 8),
        Flexible(child: _customSenderMessageCard(isGroup, context, isReplying)),
      ],
    );
  }
}
