import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String name;
  String email;
  String phone;
  String password;
  String uid;
  String image;
  String cover;
  String bio;
  String? dateTime;
  bool isEmailVarified;
  String tokenDevice;
  String? lastMessage;
  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.uid,
    required this.isEmailVarified,
    required this.image,
    required this.cover,
    required this.bio,
    this.dateTime,
    this.lastMessage,
    required this.tokenDevice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'image': image,
      'cover': cover,
      'bio': bio,
      'uid': uid,
      'dateTime': dateTime,
      'isEmailVerified': isEmailVarified,
      'lastMessage': lastMessage,
      'tokenDevice': tokenDevice
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] as String,
        email: map['email'] as String,
        phone: map['phone'] as String,
        password: map['password'] as String,
        uid: map['uid'] as String,
        bio: map['bio'] as String,
        image: map['image'] as String,
        cover: map['cover'] as String,
        dateTime: map['dateTime'] as String,
        tokenDevice: map['tokenDevice'] as String,
        lastMessage: map['lastMessage'] as String,
        isEmailVarified: map['isEmailVerified']);
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
