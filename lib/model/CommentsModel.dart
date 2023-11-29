// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CommentsModel {
  // final String commentId;
  final String postId;
  final String uid; //for userid
  final String CommentsId;
  final String image;
  final String name;
  final String text;
  final String cover;
  final String bio;
  final String email;
  final String phone;
  final String password;
  final String dateTime;
  final String tokenDevice;
  CommentsModel({
    required this.postId,
    required this.uid,
    required this.CommentsId,
    required this.image,
    required this.name,
    required this.text,
    required this.dateTime,
    required this.cover,
    required this.bio,
    required this.email,
    required this.phone,
    required this.tokenDevice,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'uid': uid,
      'CommentsId': CommentsId,
      'image': image,
      'name': name,
      'text': text,
      'cover': cover,
      'dateTime': dateTime,
      'bio': bio,
      'email': email,
      'phone': phone,
      'password': password,
      'tokenDevice': tokenDevice,
    };
  }

  factory CommentsModel.fromMap(Map<String, dynamic> map) {
    return CommentsModel(
      postId: map['postId'] as String,
      uid: map['uid'] as String,
      CommentsId: map['CommentsId'] as String,
      image: map['image'] as String,
      name: map['name'] as String,
      text: map['text'] as String,
      dateTime: map['dateTime'] as String,
      cover: map['cover'] as String,
      bio: map['bio'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
      tokenDevice: map['tokenDevice'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentsModel.fromJson(String source) =>
      CommentsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
