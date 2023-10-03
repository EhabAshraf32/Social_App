// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/UserModel.dart';
import '../styles/AuthStyles.dart';
import '../styles/icon_broken.dart';

class ChatProfile extends StatelessWidget {
  ChatProfile({required this.model, super.key});
  UserModel model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: primarycolor,
            )),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage("${model.image}"),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "${model.name}",
                style: TextStyle(fontSize: 20),
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: primarycolor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Profile,
                          color: Colors.white,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
