// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations, non_constant_identifier_names, unnecessary_cast, must_be_immutable, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:socialapp/view/ChatUserDetails.dart';
import 'package:swipe_to/swipe_to.dart';
import '../Widgets.dart';
import '../controller/socialCubit/cubit/social_cubit.dart';
import '../model/MessagesModel.dart';
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
  MessageModel? replayMessageText;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        FirebaseFirestore.instance.collection("users").doc(model.uid).update(
            {'unreadMessages.${SocialCubit.get(context).model?.uid}': 0});
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
                          context: context,
                          delegate: MessageSearchDelegate(name: model.name));
                    },
                  ),
                ],
              ),
              body: Form(
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
                                      image:
                                          AssetImage("assets/nomessage.png"))),
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
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10))),
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
                                                            topRight:
                                                                Radius.circular(
                                                                    10))),
                                                child: Center(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Delete Message?",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                            color: Colors.white,
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
                                                                  receiverId: model
                                                                      .uid, // The receiver's user ID
                                                                  messageId: message
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
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                          TextButton(
                                                              onPressed: () {
                                                                SocialCubit.get(
                                                                        context)
                                                                    .deleteMessageForYou(
                                                                  receiverId: model
                                                                      .uid, // The receiver's user ID
                                                                  messageId: message
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
                                      child: SwipeTo(
                                          onRightSwipe: () {
                                            SocialCubit.get(context)
                                                .changeReplayStatus(
                                                    message: message);
                                            print(
                                                "Replay message set: ${message.text}");
                                          },
                                          child: BuildMyMessage(
                                            message,
                                            context,
                                            username: model.name,
                                          )));
                                } else {
                                  return GestureDetector(
                                      onLongPress: () {
                                        showModalBottomSheet(
                                            backgroundColor:
                                                Colors.grey.shade900,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10))),
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
                                                            topRight:
                                                                Radius.circular(
                                                                    10))),
                                                child: Center(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Delete Message?",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                            color: Colors.white,
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
                                                                  receiverId: model
                                                                      .uid, // The receiver's user ID
                                                                  messageId: message
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
                                      child: SwipeTo(
                                          onRightSwipe: () {
                                            SocialCubit.get(context)
                                                .changeReplayStatus(
                                                    message: message);
                                            print(
                                                "Replay message set: ${message.text}");
                                          },
                                          child: BuildHimMessage(
                                              message, context,
                                              username: model.name)));
                                }
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 15,
                                  ),
                              itemCount: SocialCubit.get(context)
                                  .messagesmodel
                                  .length)),
                    Column(
                      children: [
                        if (SocialCubit.get(context).replayMessage != null)
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Container(
                                  color: primarycolor,
                                  width: 3,
                                ),
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 8, bottom: 2),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                SocialCubit.get(context)
                                                            .model
                                                            ?.uid !=
                                                        SocialCubit.get(context)
                                                            .replayMessage
                                                            ?.senderId
                                                    ? "${model.name}"
                                                    : "You",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  SocialCubit.get(context)
                                                      .cancelReplay();
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  size: 18,
                                                ))
                                          ],
                                        ),
                                        if (SocialCubit.get(context)
                                                .replayMessage
                                                ?.text !=
                                            "")
                                          Text(
                                            "${SocialCubit.get(context).replayMessage?.text}",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 17),
                                          ),
                                        SocialCubit.get(context)
                                                    .replayMessage
                                                    ?.image !=
                                                ""
                                            ? Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                            "${SocialCubit.get(context).replayMessage?.image}"))),
                                              )
                                            : Container(
                                                width: 0,
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(),
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
                                autofocus: false
                                // SocialCubit.get(context).replayMessage ==
                                //         null
                                //     ? false
                                //     : true
                                ,
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
                                      if (SocialCubit.get(context)
                                              .replayMessage !=
                                          null) {
                                        // Access the replayMessage from your Cubit using SocialCubit.get(context).replayMessage
                                        Text(
                                            "${SocialCubit.get(context).replayMessage?.text}");
                                        replayMessageText =
                                            SocialCubit.get(context)
                                                .replayMessage;
                                      }
                                      SocialCubit.get(context).cancelReplay();

                                      SocialCubit.get(context).sendMessage(
                                          receiverId: model.uid,
                                          dateTime: DateTime.now().toString(),
                                          text: controller.text,
                                          replaymessage: replayMessageText);
                                      SocialCubit.get(context).PostNotification(
                                        to: model.tokenDevice,
                                        title: SocialCubit.get(context)
                                            .model!
                                            .name,
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
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
