import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/message.dart';

import '../../../../../../components/enums/message_enum.dart';
import '../../../../../../components/provider/message_reply_provider.dart';
import '../../../../../../model/chat_list_model.dart';
import '../repositories/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContactModel>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  // Stream<List<GroupModel>> chatGroups() {
  //   return chatRepository.getChatGroups();
  // }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Stream<List<Message>> groupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required bool isGroupChat,
  }) {
    final messageReply = ref.read(messageReplyProvider);
    ProfileController().fetchUserProfile().then((value) {
      print(value);
      chatRepository.sendTextMessage(
        context: context,
        text: text,
        recieverUserId: recieverUserId,
        senderUser: value!,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
      );
    });
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required MessageEnum messageEnum,
    required bool isGroupChat,
  }) {
    final messageReply = ref.read(messageReplyProvider);
    ProfileController().fetchUserProfile().then(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
    required bool isGroupChat,
  }) {
    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    ProfileController().fetchUserProfile().then(
          (value) => chatRepository.sendGIFMessage(
            context: context,
            gifUrl: newgifUrl,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }

  // void setUnreadMessage(
  //   BuildContext context,
  //   String recieverUserId,
  // ) {
  //   chatRepository.setUnreadMessage(
  //     context,
  //     recieverUserId,
  //   );
  // }

  void clearUnreadMessage(
    BuildContext context,
    String recieverUserId,
  ) {
    chatRepository.clearUnreadMessage(
      context,
      recieverUserId,
    );
  }
}
