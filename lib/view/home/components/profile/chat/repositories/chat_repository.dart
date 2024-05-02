import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../components/enums/message_enum.dart';
import '../../../../../../components/provider/message_reply_provider.dart';
import '../../../../../../model/chat_list_model.dart';
import '../../../../../../model/message.dart';
import '../../../../../../model/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContactModel>> getChatContacts() {
    return firestore
        .collection(FirebaseConstants.users)
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .orderBy("timeSent", descending: true)
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> contacts = [];
      print(event.docs.length);
      for (var document in event.docs) {
        var chatContact = ChatContactModel.fromMap(document.data());
        var userData = await firestore
            .collection(FirebaseConstants.users)
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(
          ChatContactModel(
            name: user.username.toString(),
            profilePic: user.profileImage.toString(),
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
            unreadMessage: chatContact.unreadMessage,
          ),
        );
        print(contacts);
      }
      return contacts;
    });
  }

  // TODO GROUP CHAT

  // Stream<List<GroupModel>> getChatGroups() {
  //   return firestore.collection('groups').snapshots().map((event) {
  //     List<GroupModel> groups = [];
  //     for (var document in event.docs) {
  //       var group = GroupModel.fromMap(document.data());
  //       if (group.membersUid.contains(auth.currentUser!.uid)) {
  //         groups.add(group);
  //       }
  //     }
  //     return groups;
  //   });
  // }

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection(FirebaseConstants.users)
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      print(messages);
      return messages;
    });
  }

  Stream<List<Message>> getGroupChatStream(String groudId) {
    return firestore
        .collection('groups')
        .doc(groudId)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel? recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
    bool isGroupChat,
  ) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(recieverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
// users -> reciever user id => chats -> current user id -> set data

      // var chatContactData = await firestore
      //     .collection(FirebaseConstants.users)
      //     .doc(recieverUserId)
      //     .collection('chats')
      //     .doc(auth.currentUser!.uid)
      //     .get();
      // var chat = ChatContactModel.fromMap(chatContactData.data()!);
      var recieverChatContact = ChatContactModel(
        name: senderUserData.username.toString(),
        profilePic: senderUserData.profileImage.toString(),
        contactId: senderUserData.uid.toString(),
        timeSent: timeSent,
        lastMessage: text,
        unreadMessage: 1,
      );
      await firestore
          .collection(FirebaseConstants.users)
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(
            recieverChatContact.toMap(),
          );
      // users -> current user id  => chats -> reciever user id -> set data
      // var senderChatData = await firestore
      //     .collection(FirebaseConstants.users)
      //     .doc(auth.currentUser!.uid)
      //     .collection('chats')
      //     .doc(recieverUserId)
      //     .get();
      // var senderChat = ChatContactModel.fromMap(senderChatData.data()!);
      var senderChatContact = ChatContactModel(
        name: recieverUserData!.username.toString(),
        profilePic: recieverUserData.profileImage.toString(),
        contactId: recieverUserData.uid.toString(),
        timeSent: timeSent,
        lastMessage: text,
        unreadMessage: 1,
      );
      await firestore
          .collection(FirebaseConstants.users)
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .set(
            senderChatContact.toMap(),
          );
    }
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String? recieverUserName,
    required bool isGroupChat,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : recieverUserName ?? '',
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    if (isGroupChat) {
      // groups -> group id -> chat -> message
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    } else {
      // users -> sender id -> reciever id -> messages -> message id -> store message
      await firestore
          .collection(FirebaseConstants.users)
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
      // users -> eciever id  -> sender id -> messages -> message id -> store message
      await firestore
          .collection(FirebaseConstants.users)
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDataMap = await firestore
            .collection(FirebaseConstants.users)
            .doc(recieverUserId)
            .get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
        senderUser,
        recieverUserData,
        text,
        timeSent,
        recieverUserId,
        isGroupChat,
      );

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        username: senderUser.username.toString(),
        messageReply: messageReply,
        recieverUserName: recieverUserData?.name,
        senderUsername: senderUser.username.toString(),
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
            file,
          );

      UserModel? recieverUserData;
      if (!isGroupChat) {
        var userDataMap = await firestore
            .collection(FirebaseConstants.users)
            .doc(recieverUserId)
            .get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }
      _saveDataToContactsSubcollection(
        senderUserData,
        recieverUserData,
        contactMsg,
        timeSent,
        recieverUserId,
        isGroupChat,
      );

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.username.toString(),
        messageType: messageEnum,
        messageReply: messageReply,
        recieverUserName: recieverUserData?.name,
        senderUsername: senderUserData.username.toString(),
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDataMap = await firestore
            .collection(FirebaseConstants.users)
            .doc(recieverUserId)
            .get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
        senderUser,
        recieverUserData,
        'GIF',
        timeSent,
        recieverUserId,
        isGroupChat,
      );

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageType: MessageEnum.gif,
        messageId: messageId,
        username: senderUser.username.toString(),
        messageReply: messageReply,
        recieverUserName: recieverUserData?.name,
        senderUsername: senderUser.username.toString(),
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  // void setUnreadMessage(BuildContext context, String recieverUserId) async {
  //   try {
  //     var chatContactData = await firestore
  //         .collection(FirebaseConstants.users)
  //         .doc(auth.currentUser!.uid)
  //         .collection('chats')
  //         .doc(recieverUserId)
  //         .get();
  //     var chat = ChatContactModel.fromMap(chatContactData.data()!);

  //     await firestore
  //         .collection(FirebaseConstants.users)
  //         .doc(auth.currentUser!.uid)
  //         .collection('chats')
  //         .doc(recieverUserId)
  //         .update({'unreadMessage': chat.unreadMessage + 1});
  //     print("hello");
  //     print("hello ${chat.unreadMessage}");
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());
  //   }
  // }

  void clearUnreadMessage(BuildContext context, String recieverUserId) async {
    try {
      await firestore
          .collection(FirebaseConstants.users)
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .update({'unreadMessage': 0});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection(FirebaseConstants.users)
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection(FirebaseConstants.users)
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
      ),
    ),
  );
}
