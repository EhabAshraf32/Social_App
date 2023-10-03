// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisplayChatImage extends StatelessWidget {
  DisplayChatImage({
    Key? key,
    this.image,
  }) : super(key: key);
  final String? image;

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
      body: Column(
        children: [
          Expanded(
            child: Hero(
              tag: "${image}",
              child: Image.network(
                image!,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container()
        ],
      ),
    );
  }
}
