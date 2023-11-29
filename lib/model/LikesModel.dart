// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LikesModel {
  // final String commentId;
  final String postId;
  final String cover;
  final String bio;
  final String image;
  final String email;
  final String phone;
  final String password;
  final String uid; //for userid
  final String name;
  final String tokenDevice;
  final String dateTime;
  final bool like;
  LikesModel({
    required this.postId,
    required this.uid,
    required this.name,
    required this.dateTime,
    required this.like,
    required this.cover,
    required this.bio,
    required this.image,
    required this.email,
    required this.phone,
    required this.password,
    required this.tokenDevice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'uid': uid,
      'name': name,
      'dateTime': dateTime,
      'like': like,
      'cover': cover,
      'bio': bio,
      'image': image,
      'email': email,
      'phone': phone,
      'password': password,
      'tokenDevice': tokenDevice,
    };
  }

  factory LikesModel.fromMap(Map<String, dynamic> map) {
    return LikesModel(
      postId: map['postId'] as String,
      uid: map['uid'] as String,
      name: map['name'] as String,
      dateTime: map['dateTime'] as String,
      like: map['like'] as bool,
      cover: map['cover'] as String,
      bio: map['bio'] as String,
      image: map['image'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
      tokenDevice: map['tokenDevice'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LikesModel.fromJson(String source) =>
      LikesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
