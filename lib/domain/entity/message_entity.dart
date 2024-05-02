import 'package:equatable/equatable.dart';

import '../../components/enums/message_enum.dart';

class MessageEntity extends Equatable {
   String? senderId;
  String? recieverid;
  String? text;
  MessageEnum? type;
  DateTime? timeSent;
  String? messageId;
  bool? isSeen;
  String? repliedMessage;
  String? repliedTo;
  MessageEnum? repliedMessageType;
  bool? isSentByMe;

  MessageEntity({
    this.senderId,
    this.recieverid,
    this.text,
    this.type,
    this.timeSent,
    this.messageId,
    this.isSeen,
    this.repliedMessage,
    this.repliedTo,
    this.repliedMessageType,
    this.isSentByMe,
  });

  @override
  List<Object?> get props => [
        senderId,
        recieverid,
        text,
        type,
        timeSent,
        messageId,
        isSeen,
        repliedMessage,
        repliedTo,
        repliedMessageType,
        isSentByMe,
      ];
}
