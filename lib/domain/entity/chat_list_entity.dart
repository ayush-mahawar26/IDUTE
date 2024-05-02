import 'package:equatable/equatable.dart';

class ChatListEntity extends Equatable {
  String? userName;
  String? userProfileUrl;
  String? chatId;
  String? userId;
  DateTime? timeSent;
  String? lastMessage;
  ChatListEntity({
    this.userName,
    this.userProfileUrl,
    this.chatId,
    this.userId,
    this.timeSent,
    this.lastMessage,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        userName,
        userProfileUrl,
        chatId,
        userId,
        timeSent,
        lastMessage,
      ];
}
