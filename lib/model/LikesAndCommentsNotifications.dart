// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LikesAndCommentsNotifications {
  // final String commentId;
  final String postId;
  final String recevUserId;
  String? notificatoinId;

  final String cover;
  final String bio;
  final String image;
  final String email;
  final String phone;
  final String password;
  final String uid; //for userid
  final String name;
  final String dateTime;
  final bool like;
  final String type;
  String? commetText;
  String text;
  String postImage;
  LikesAndCommentsNotifications(
      {required this.postId,
      required this.uid,
      this.notificatoinId,
      required this.name,
      required this.dateTime,
      required this.like,
      required this.cover,
      required this.bio,
      required this.image,
      required this.email,
      required this.phone,
      required this.password,
      required this.type,
      this.commetText,
      required this.text,
      required this.postImage,
      required this.recevUserId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'uid': uid,
      'notificatoinId': notificatoinId,
      'name': name,
      'dateTime': dateTime,
      'like': like,
      'cover': cover,
      'bio': bio,
      'image': image,
      'email': email,
      'phone': phone,
      'password': password,
      'type': type,
      'commetText': commetText,
      'text': text,
      'postImage': postImage,
      'recevUserId': recevUserId,
    };
  }

  factory LikesAndCommentsNotifications.fromMap(Map<String, dynamic> map) {
    return LikesAndCommentsNotifications(
      postId: map['postId'] as String,
      uid: map['uid'] as String,
      notificatoinId: map['notificatoinId'] as String,
      name: map['name'] as String,
      dateTime: map['dateTime'] as String,
      like: map['like'] as bool,
      cover: map['cover'] as String,
      bio: map['bio'] as String,
      image: map['image'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
      type: map['type'] as String,
      commetText: map['commetText'] as String,
      postImage: map['postImage'] as String,
      text: map['text'] as String,
      recevUserId: map['recevUserId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LikesAndCommentsNotifications.fromJson(String source) =>
      LikesAndCommentsNotifications.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
