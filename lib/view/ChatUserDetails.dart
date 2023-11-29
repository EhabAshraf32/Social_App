// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/model/CreatePost.dart';
import 'package:socialapp/model/UserModel.dart';
import 'package:socialapp/styles/AuthStyles.dart';
import 'package:socialapp/styles/icon_broken.dart';
import 'package:socialapp/view/AllUsersProfileScreen.dart';

class ChatUserDetails extends StatelessWidget {
  ChatUserDetails({required this.model, super.key});
  UserModel? model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage("${model?.image}"),
              ),
              Text(
                "${model?.name}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Get.to(AllUsersProfileScreen(
                      model: CreatePostModel(
                    uid: model!.uid,
                    name: model!.name,
                    email: model!.email,
                    phone: model!.phone,
                    password: model!.password,
                    cover: model!.cover,
                    bio: model!.bio,
                    tokenDevice: model!.tokenDevice,
                    image: model!.image,
                  )));
                },
                child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: primarycolor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      IconBroken.Profile,
                      color: Colors.white,
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
