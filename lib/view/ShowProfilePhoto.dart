// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/model/CreatePost.dart';

import '../styles/AuthStyles.dart';

class ShowProfilePhoto extends StatelessWidget {
  ShowProfilePhoto({
    Key? key,
    this.image,
  }) : super(key: key);
  String? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Container(
                alignment: Alignment.center,
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.60),
                    borderRadius: BorderRadius.circular(13)),
                child: Text(
                  "X",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Hero(
                tag: "$image",
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 2,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: CircleAvatar(
                      backgroundColor: primarycolor,
                      radius: 180,
                      backgroundImage: NetworkImage(image!)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
