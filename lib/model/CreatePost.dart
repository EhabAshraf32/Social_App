import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CreatePostModel {
  String uid;
  String name;
  String email;
  String phone;
  String password;
  String cover;
  String bio;
  String image;
  String? text;
  String? postImage;
  String? datetime;
  String tokenDevice;
  bool? isLiked; // New property to track whether the post is liked

  CreatePostModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.phone,
      required this.password,
      required this.cover,
      required this.bio,
      required this.image,
      this.text,
      this.postImage,
      this.datetime,
      required this.tokenDevice,
      this.isLiked});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'cover': cover,
      'bio': bio,
      'image': image,
      'text': text,
      'postImage': postImage,
      'datetime': datetime,
      'tokenDevice': tokenDevice,
      'isLiked': isLiked,
    };
  }

  factory CreatePostModel.fromMap(Map<String, dynamic> map) {
    return CreatePostModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
      cover: map['cover'] as String,
      bio: map['bio'] as String,
      image: map['image'] as String,
      text: map['text'] as String,
      postImage: map['postImage'] as String,
      datetime: map['datetime'] as String,
      tokenDevice: map['tokenDevice'] as String,
      isLiked: map['isLiked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatePostModel.fromJson(String source) =>
      CreatePostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
