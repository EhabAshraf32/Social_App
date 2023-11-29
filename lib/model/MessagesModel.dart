// ignore_for_file: prefer_null_aware_operators

import 'dart:convert';

class MessageModel {
  String senderId;
  String receiverId;
  String messageId;
  String dateTime;
  String text;
  String? image;
  String receiverTkoenDevice;
  bool isRead;
  bool isSeen;
  MessageModel? replayMessage;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.messageId,
    required this.dateTime,
    required this.text,
    required this.receiverTkoenDevice,
    this.image,
    this.replayMessage,
    required this.isRead,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'messageId': messageId,
      'dateTime': dateTime,
      'text': text,
      'receiverTkoenDevice': receiverTkoenDevice,
      'image': image,
      'replayMessage': replayMessage != null ? replayMessage?.toMap() : null,
      'isRead': isRead,
      'isSeen': isSeen,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      messageId: map['messageId'] as String,
      dateTime: map['dateTime'] as String,
      text: map['text'] as String,
      receiverTkoenDevice: map['receiverTkoenDevice'] as String,
      image: map['image'] as String?,
      replayMessage: map['replayMessage'] != null
          ? MessageModel.fromMap(map['replayMessage'])
          : null,
      isRead: map['isRead'] as bool,
      isSeen: map['isSeen'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
