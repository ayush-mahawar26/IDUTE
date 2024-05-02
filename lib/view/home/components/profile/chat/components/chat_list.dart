// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'package:idute_app/model/message.dart';
import 'package:idute_app/view/home/components/profile/chat/components/chat_bubble.dart';

import '../../../../../../components/enums/message_enum.dart';
import '../../../../../../components/provider/message_reply_provider.dart';
import '../../../../../../components/widgets/loader.dart';
import '../controllers/chat_controller.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatList({
    super.key,
    required this.recieverUserId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  Stream<List<Message>> _chatStream = const Stream.empty();

  @override
  void initState() {
    super.initState();

    // ref
    //     .read(chatControllerProvider)
    //     .clearUnreadMessage(context, widget.recieverUserId);
    _chatStream =
        ref.read(chatControllerProvider).chatStream(widget.recieverUserId);
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            message,
            isMe,
            messageEnum,
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Message>>(
        stream: _chatStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 9, right: 13),
            child: GroupedListView<Message, DateTime>(
              physics: const BouncingScrollPhysics(),
              controller: messageController,
              shrinkWrap: true,
              reverse: true,
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              elements: snapshot.data!,
              groupBy: (message) => DateTime(
                message.timeSent.year,
                message.timeSent.month,
                message.timeSent.day,
              ),
              groupHeaderBuilder: (message) => _buildHeader(message),
              itemBuilder: (context, Message message) {
                return ChatBubble(
                  messageController: messageController,
                  message: message,
                  isGroup: false,
                  onMessageSwipe: () => onMessageSwipe(
                    message.text,
                    message.senderId == FirebaseAuth.instance.currentUser!.uid
                        ? true
                        : false,
                    message.type,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _buildDay(Message message) {
    return message.timeSent.day == DateTime.now().day
        ? "Today"
        : message.timeSent.day == DateTime.now().day - 1
            ? "Yesterday"
            : DateFormat.yMMMMd().format(message.timeSent);
  }

  SizedBox _buildHeader(Message message) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Card(
          color: const Color(0xff2b2b2b),
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.white.withOpacity(0.09000000357627869),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _buildDay(message),
              style: const TextStyle(
                color: Color(0xFF979797),
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
