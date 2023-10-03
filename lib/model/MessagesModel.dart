import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  String senderId;
  String receiverId;
  String messageId;
  String dateTime;
  String text;
  String? image;
  String receiverTkoenDevice;
  bool isRead; // Add this field for tracking read/unread status
  bool isSeen;
  MessageModel(
      {required this.senderId,
      required this.receiverId,
      required this.messageId,
      required this.dateTime,
      required this.text,
      required this.receiverTkoenDevice,
      this.image,
      required this.isRead,
      required this.isSeen});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'messageId': messageId,
      'dateTime': dateTime,
      'text': text,
      'receiverTkoenDevice': receiverTkoenDevice,
      'image': image,
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
      image: map['image'] as String,
      isRead: map['isRead'] as bool,
      isSeen: map['isSeen'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
