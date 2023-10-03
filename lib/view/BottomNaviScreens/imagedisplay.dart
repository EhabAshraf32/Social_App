// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../controller/socialCubit/cubit/social_cubit.dart';
import '../../model/UserModel.dart';
import '../../styles/AuthStyles.dart';
import '../../styles/icon_broken.dart';
import '../ChatsDetails.dart';

class ImageDisplayScreen extends StatelessWidget {
  final File? image;
  final Function() onSendPressed;
  var formstate = GlobalKey<FormState>();
  var controller = TextEditingController();
  UserModel model;

  ImageDisplayScreen(
      {required this.image, required this.onSendPressed, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is SocialSendMessageSuccessState) {
          Get.off(ChatDetailsScreen(model: model));
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              leading: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Container(
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
                      )))),
          body: Form(
            key: formstate,
            child: Column(
              children: [
                Expanded(
                  child: Image.file(
                    image!,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "add a caption..."),
                        validator: (value) {
                          if (value!.isEmpty) {
                            "please write a message";
                          }
                          if (value.length == 0) {
                            "please write a message";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.always,
                      )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 16,
                        child: MaterialButton(
                          color: primarycolor,
                          minWidth: 1,
                          onPressed: () {
                            if (formstate.currentState!.validate()) {
                              if (SocialCubit.get(context).Chatimage == null) {
                                SocialCubit.get(context).sendMessage(
                                  receiverId: model.uid,
                                  dateTime: DateTime.now().toString(),
                                  text: controller.text,
                                );
                                controller.clear();
                              } else {
                                SocialCubit.get(context).uploadChatImage(
                                  text: controller.text,
                                  datetime: DateTime.now().toString(),
                                  receiverId: model.uid,
                                );
                              }
                            }
                          },
                          child: Icon(
                            IconBroken.Send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
