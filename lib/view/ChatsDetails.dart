// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations, non_constant_identifier_names, unnecessary_cast, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:socialapp/view/ChatUserDetails.dart';
import '../Widgets.dart';
import '../controller/socialCubit/cubit/social_cubit.dart';
import '../model/UserModel.dart';
import '../styles/AuthStyles.dart';
import '../styles/icon_broken.dart';
import 'BottomNaviScreens/imagedisplay.dart';
import 'MessageSearch.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({super.key, required this.model});

  UserModel model;
  var formstate = GlobalKey<FormState>();
  var controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(receiverId: model.uid);
        return BlocConsumer<SocialCubit, SocialState>(
          listener: (context, state) {
            if (state is SocialChatPicedImageSuccesState) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ImageDisplayScreen(
                    image: SocialCubit.get(context).Chatimage,
                    model: model,
                    onSendPressed: () {
                      // Handle sending the message with the image
                      // You can access the message text from the TextFormField
                      // and the image from SocialCubit.get(context).Chatimage
                      // Send the message and navigate back.
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            Future.delayed(Duration(milliseconds: 200), () {
              if (scrollController.hasClients) {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });

            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                titleSpacing: 0,
                title: InkWell(
                  onTap: () {
                    Get.to(ChatUserDetails(
                      model: model,
                    ));
                  },
                  child: Row(
                    children: [
                      Hero(
                        tag: "${model.uid}",
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage("${model.image}"),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "${model.name}",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(IconBroken.Search),
                    onPressed: () {
                      showSearch(
                          context: context, delegate: MessageSearchDelegate());
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Form(
                  key: formstate,
                  child: Column(
                    children: [
                      if (SocialCubit.get(context).messagesmodel.isEmpty)
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 6,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/nomessage.png"))),
                              ),
                              Text(
                                "No Message yet",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: primarycolor,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      if (SocialCubit.get(context).messagesmodel.isNotEmpty)
                        Expanded(
                            child: ListView.separated(
                                controller: scrollController,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var message = SocialCubit.get(context)
                                      .messagesmodel[index];
                                  SocialCubit.get(context).confirmMessageRead(
                                      message.messageId,
                                      model.uid,
                                      SocialCubit.get(context).model!.uid);
                                  if (SocialCubit.get(context).model?.uid ==
                                      message.senderId) {
                                    return GestureDetector(
                                        onLongPress: () {
                                          showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.grey.shade900,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10))),
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  alignment: Alignment.center,
                                                  height: 200,
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10))),
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Delete Message?",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            icon: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey.shade800,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  SocialCubit.get(
                                                                          context)
                                                                      .deleteMessageForAll(
                                                                    receiverId:
                                                                        model
                                                                            .uid, // The receiver's user ID
                                                                    messageId:
                                                                        message
                                                                            .messageId, // The ID of the message to delete
                                                                  );
                                                                  Get.back();
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Delete for Everyone",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                )),
                                                            Container(
                                                              height: 1,
                                                              color: Colors.grey
                                                                  .shade300,
                                                            ),
                                                            TextButton(
                                                                onPressed: () {
                                                                  SocialCubit.get(
                                                                          context)
                                                                      .deleteMessageForYou(
                                                                    receiverId:
                                                                        model
                                                                            .uid, // The receiver's user ID
                                                                    messageId:
                                                                        message
                                                                            .messageId, // The ID of the message to delete
                                                                  );
                                                                  Get.back();
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                        "Delete for Me",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                  ],
                                                                ))
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                                );
                                              });
                                        },
                                        child:
                                            BuildMyMessage(message, context));
                                  } else {
                                    return GestureDetector(
                                        onLongPress: () {
                                          showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.grey.shade900,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10))),
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  alignment: Alignment.center,
                                                  height: 150,
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10))),
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Delete Message?",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            icon: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey.shade800,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  SocialCubit.get(
                                                                          context)
                                                                      .deleteMessageForYou(
                                                                    receiverId:
                                                                        model
                                                                            .uid, // The receiver's user ID
                                                                    messageId:
                                                                        message
                                                                            .messageId, // The ID of the message to delete
                                                                  );
                                                                  Get.back();
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                        "Delete for Me",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:
                                                                                25,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                  ],
                                                                ))
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                                );
                                              });
                                        },
                                        child:
                                            BuildHimMessage(message, context));
                                  }
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 15,
                                    ),
                                itemCount: SocialCubit.get(context)
                                    .messagesmodel
                                    .length)),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 16,
                              child: MaterialButton(
                                minWidth: 1,
                                onPressed: () {
                                  // Call the startRecording function
                                },
                                child: Icon(
                                  IconBroken.Voice,
                                  color: primarycolor,
                                ),
                              ),
                            ),
                            Expanded(
                                child: TextFormField(
                              controller: controller,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Write your message here ..."),
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
                                minWidth: 1,
                                onPressed: () {
                                  SocialCubit.get(context).getchatImage();
                                },
                                child: Icon(
                                  IconBroken.Camera,
                                  color: primarycolor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 16,
                              child: MaterialButton(
                                color: primarycolor,
                                minWidth: 1,
                                onPressed: () {
                                  if (formstate.currentState!.validate()) {
                                    SocialCubit.get(context).sendMessage(
                                        receiverId: model.uid,
                                        dateTime: DateTime.now().toString(),
                                        text: controller.text);
                                    SocialCubit.get(context).PostNotification(
                                      to: model.tokenDevice,
                                      title:
                                          SocialCubit.get(context).model!.name,
                                      body: "Sent you a message",
                                    );
                                    controller.clear();
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
              ),
            );
          },
        );
      },
    );
  }
}
