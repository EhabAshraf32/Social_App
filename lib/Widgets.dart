// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, non_constant_identifier_names, body_might_complete_normally_nullable, unused_local_variable, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:socialapp/styles/AuthStyles.dart';
import 'package:socialapp/styles/icon_broken.dart';
import 'package:socialapp/view/AllUsersProfileScreen.dart';
import 'package:socialapp/view/ChatsDetails.dart';
import 'package:socialapp/view/DisplayChatImage.dart';

import 'constants/Functions.dart';
import 'controller/socialCubit/cubit/social_cubit.dart';
import 'model/CommentsModel.dart';
import 'model/CreatePost.dart';
import 'model/MessagesModel.dart';
import 'model/UserModel.dart';

var controller2 = TextEditingController();

inputTextField(
    {hintText,
    labeltext,
    obscuretext,
    controller,
    IconButton? icon,
    required TextInputType keyboartype,
    validator}) {
  return TextFormField(
    validator: validator,
    keyboardType: keyboartype,
    obscureText: obscuretext,
    controller: controller,
    decoration: InputDecoration(
        suffixIcon: icon,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primarycolor),
            borderRadius: BorderRadius.circular(20)),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        hintText: hintText,
        labelText: labeltext,
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(
          color: Colors.black38,
        )),
  );
}

topheader(context, text, {required image}) {
  return Padding(
    padding: EdgeInsets.only(
      left: MediaQuery.of(context).size.width / 20,
      top: MediaQuery.of(context).size.width / 10,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 28,
          ),
        ),
        Image.asset(
          '${image}',
          height: MediaQuery.of(context).size.height / 6.2,
          fit: BoxFit.fitHeight,
        )
      ],
    ),
  );
}

void showToast() => Fluttertoast.showToast(
      msg: "This is Center Short Toast",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );

SnackbarController snackbar(
        {required String type,
        required String message,
        required HexColor color,
        SnackPosition snackPosition = SnackPosition.TOP}) =>
    Get.snackbar(
      "$type",
      "$message",
      colorText: Colors.white,
      snackPosition: snackPosition,
      backgroundColor: color,
    );

Widget chatsListView(UserModel model, BuildContext context) {
  String receiverId = model.uid;

  return InkWell(
    onTap: () {
      Get.to(() => ChatDetailsScreen(
            model: model,
          ));
    },
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Hero(
            tag: "${model.uid}",
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage("${model.image}"),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${model.name}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primarycolor),
                    ),
                    Spacer(),
                    Text(
                      "${formattedDateTimeForChats(model.dateTime).toString()}",
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                Text(
                  "${model.lastMessage}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                      color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget userComments(CommentsModel Commentsmodel, context, index) {
  DateTime commentasDateTime = DateTime.parse(Commentsmodel.dateTime);
  final bool isCurrentUserComment =
      Commentsmodel.uid == SocialCubit.get(context).model?.uid;
  int commentIndex = index; // Create a local variable to capture the index

  return InkWell(
    onLongPress: () {
      if (isCurrentUserComment)
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actionsPadding: EdgeInsets.only(bottom: 10),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("cancel", style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                      onPressed: () {
                        SocialCubit.get(context).deleteComment(
                          postId: SocialCubit.get(context).postId[commentIndex],
                          CommentsId: Commentsmodel.CommentsId,
                        );
                        Get.back();
                      },
                      child:
                          Text("Ok", style: TextStyle(color: homeprimarycolor)))
                ],
                title: Text(
                  "Warning",
                  style: TextStyle(
                      color: primarycolor, fontWeight: FontWeight.bold),
                ),
                content: Text(
                    "are you sure that you want to delete your comment",
                    style: TextStyle(color: primarycolor)),
                backgroundColor: Colors.white,
              );
            });
    },
    child: Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage("${Commentsmodel.image}"),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${Commentsmodel.name}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.check_circle,
                    color: homeprimarycolor,
                    size: 16,
                  )
                ],
              ),
              Text(
                "${Commentsmodel.text}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Text(formatDateTimeForPosts(commentasDateTime),
            style: Theme.of(context).textTheme.bodySmall)
      ],
    ),
  );
}

Widget userNumberComments(CommentsModel Commentsmodel, context, index) {
  DateTime commentasDateTime = DateTime.parse(Commentsmodel.dateTime);
  final bool isCurrentUserComment =
      Commentsmodel.uid == SocialCubit.get(context).model?.uid;
  int commentIndex = index; // Create a local variable to capture the index

  return Row(
    children: [
      Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage("${Commentsmodel.image}"),
          ),
          CircleAvatar(
              backgroundColor: Colors.white,
              radius: 10,
              child: Icon(
                IconBroken.Chat,
                color: Colors.amber,
                size: 20,
              )),
        ],
      ),
      SizedBox(
        width: 15,
      ),
      Expanded(
        child: Row(
          children: [
            Text(
              "${Commentsmodel.name}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildPostItem(
  BuildContext context,
  double heigh,
  CreatePostModel postmodell,
  SocialState state,
  index,
) {
  DateTime postDateTime = DateTime.parse(
      postmodell.datetime as String); // Parse the string to DateTime

  return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(AllUsersProfileScreen(
                      model: postmodell,
                    ));
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(postmodell.image),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${postmodell.name}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.check_circle,
                            color: homeprimarycolor,
                            size: 16,
                          )
                        ],
                      ),
                      Text(
                        formatDateTimeForPosts(postDateTime),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                IconButton(
                    onPressed: () {
                      if (SocialCubit.get(context).model?.uid ==
                          SocialCubit.get(context).posts[index].uid) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actionsPadding: EdgeInsets.only(bottom: 10),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("cancel",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        SocialCubit.get(context).deletePost(
                                            SocialCubit.get(context)
                                                .postId[index]);
                                        Get.back();
                                      },
                                      child: Text("Ok",
                                          style: TextStyle(
                                              color: homeprimarycolor)))
                                ],
                                title: Text(
                                  "Warning",
                                  style: TextStyle(
                                      color: primarycolor,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                    "are you sure that you want to delete your post",
                                    style: TextStyle(color: primarycolor)),
                                backgroundColor: Colors.white,
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actionsPadding: EdgeInsets.only(bottom: 10),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text("Ok got it",
                                          style: TextStyle(
                                              color: homeprimarycolor)))
                                ],
                                title: Text(
                                  "Warning",
                                  style: TextStyle(
                                      color: primarycolor,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Text("This is not your post",
                                    style: TextStyle(color: primarycolor)),
                                backgroundColor: Colors.white,
                              );
                            });
                      }
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      size: 17,
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3),
              child: Container(
                width: double.infinity,
                color: Colors.grey[300],
                height: 1,
              ),
            ),
            if (postmodell.text != "")
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  "${postmodell.text}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            postmodell.postImage != ""
                ? InkWell(
                    onTap: () {
                      Get.to(DisplayChatImage(
                        image: postmodell.postImage,
                      ));
                    },
                    child: Hero(
                      tag: "${postmodell.postImage}",
                      child: Container(
                        height: heigh / 2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image:
                                    NetworkImage("${postmodell.postImage}"))),
                      ),
                    ),
                  )
                : postmodell.postImage!.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          Get.to(DisplayChatImage(
                            image: postmodell.postImage,
                          ));
                        },
                        child: Container(
                          height: heigh / 2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image:
                                      NetworkImage("${postmodell.postImage}"))),
                        ),
                      )
                    : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              IconBroken.Heart,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${SocialCubit.get(context).Likes[index]}",
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                  padding: EdgeInsets.all(10),
                                  color: Colors.white,
                                  height: double.infinity,
                                  child: Column(
                                    children: [
                                      StreamBuilder(
                                          stream: SocialCubit.get(context)
                                              .getComments(
                                                  SocialCubit.get(context)
                                                      .postId[index]),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  "Error: ${snapshot.error}");
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return Text("No comments yet.");
                                            } else {
                                              SocialCubit.get(context)
                                                  .commentss = snapshot.data;
                                              int originalCommentIndex = index;
                                              return Expanded(
                                                child: ListView.separated(
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (SocialCubit.get(
                                                                      context)
                                                                  .commentss !=
                                                              null &&
                                                          index <
                                                              SocialCubit.get(
                                                                      context)
                                                                  .commentss!
                                                                  .length) {
                                                        return userNumberComments(
                                                          SocialCubit.get(
                                                                      context)
                                                                  .commentss![
                                                              index],
                                                          context,
                                                          originalCommentIndex,
                                                        );
                                                      }
                                                    },
                                                    separatorBuilder: (context,
                                                            index) =>
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 7),
                                                          height: 1,
                                                          color: Colors
                                                              .grey.shade300,
                                                        ),
                                                    itemCount:
                                                        SocialCubit.get(context)
                                                            .commentss!
                                                            .length),
                                              );
                                            }
                                          }),
                                    ],
                                  ));
                            });
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              IconBroken.Chat,
                              color: Colors.amber,
                              size: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${SocialCubit.get(context).Comments[index]}",
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                width: double.infinity,
                color: Colors.grey[300],
                height: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
                              height: double.infinity,
                              child: Column(
                                children: [
                                  StreamBuilder(
                                      stream: SocialCubit.get(context)
                                          .getComments(SocialCubit.get(context)
                                              .postId[index]),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              "Error: ${snapshot.error}");
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Text("No comments yet.");
                                        } else {
                                          SocialCubit.get(context).commentss =
                                              snapshot.data;
                                          int originalCommentIndex = index;
                                          return Expanded(
                                            child: ListView.separated(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  if (SocialCubit.get(context)
                                                              .commentss !=
                                                          null &&
                                                      index <
                                                          SocialCubit.get(
                                                                  context)
                                                              .commentss!
                                                              .length) {
                                                    return userComments(
                                                      SocialCubit.get(context)
                                                          .commentss![index],
                                                      context,
                                                      originalCommentIndex,
                                                    );
                                                  }
                                                },
                                                separatorBuilder: (context,
                                                        index) =>
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 7),
                                                      height: 1,
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                itemCount:
                                                    SocialCubit.get(context)
                                                        .commentss!
                                                        .length),
                                          );
                                        }
                                      }),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: TextFormField(
                                          autofocus: true,
                                          // onFieldSubmitted: (value) {
                                          //   return SocialCubit.get(context)
                                          //         .addComments(
                                          //             postId: SocialCubit.get(
                                          //                     context)
                                          //                 .postId[index],
                                          //             commentText:
                                          //                 controller2.text,
                                          //             timestamp:
                                          //                 DateTime.now()
                                          //                     .toString());
                                          // },
                                          controller: controller2,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "Write your comment here ..."),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              "please write a message";
                                            }
                                            if (value.length == 0) {
                                              "please write a message";
                                            }
                                            return null;
                                          },
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                        )),
                                        SizedBox(
                                          height: 50,
                                          child: MaterialButton(
                                            color: primarycolor,
                                            minWidth: 1,
                                            onPressed: () async {
                                              // var date =
                                              //     messagemodel?.dateTime ??
                                              //         "";
                                              // DateTime timestamp =
                                              //     DateTime.parse(date);
                                              SocialCubit.get(context)
                                                  .addComments(
                                                      postId: SocialCubit.get(
                                                              context)
                                                          .postId[index],
                                                      commentText:
                                                          controller2.text,
                                                      timestamp: DateTime.now()
                                                          .toString());

                                              controller2.clear();
                                            },
                                            child: Icon(
                                              IconBroken.Send,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ));
                        });

                    // SocialCubit.get(context).addComments(
                    //     postId: SocialCubit.get(context).postId[index]);
                  },
                  child: Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 17,
                          backgroundImage: NetworkImage(
                              "${SocialCubit.get(context).model?.image}"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "write a comment ...",
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (postmodell.isLiked == true) {
                      // User has already liked the post, so remove the like
                      SocialCubit.get(context).removeLike(
                        postId: SocialCubit.get(context).postId[index],
                        postModel: postmodell,
                      );
                    } else {
                      // User hasn't liked the post, so add a like
                      SocialCubit.get(context).addLikes(
                        postId: SocialCubit.get(context).postId[index],
                        postModel: postmodell,
                      );
                    }
                  },
                  child: Icon(
                    postmodell.isLiked == true
                        ? Icons.favorite_outlined
                        : Icons.favorite_outline,
                    color:
                        postmodell.isLiked == true ? Colors.red : primarycolor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
}

Widget BuildMyMessage(MessageModel model, context, {username}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 2 / 3),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: primarycolor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (model.replayMessage != null)
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(
                            color: chatcolorr,
                            width: 4,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    model.senderId !=
                                            model.replayMessage?.senderId
                                        ? "${username}"
                                        : "You",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                        color: Colors.white),
                                  ),
                                  if (model.replayMessage?.text != "")
                                    Text(
                                      "${model.replayMessage?.text}",
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 17),
                                    ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  model.replayMessage?.image != ""
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
                                                  BorderRadius.circular(4),
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      "${model.replayMessage?.image}"))),
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
                  model.image != null &&
                          model.image != "" &&
                          model.image!.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            Get.to(DisplayChatImage(
                              image: model.image,
                            ));
                          },
                          child: Hero(
                            tag: "${model.image}",
                            child: Container(
                              height: MediaQuery.of(context).size.height / 2.5,
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage("${model.image}"))),
                            ),
                          ),
                        )
                      : Container(
                          width: 0,
                        ),
                  Text(
                    "${model.text}",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    "${formattedDateTime(model.dateTime, 'hh:mm a').toString()}",
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ],
              )),
          Text(
            model.isRead == true
                ? 'Read'
                : model.isSeen == true
                    ? "Read"
                    : "Unreed", // Display text "Read" or "Unread"
            style: TextStyle(
              fontSize: 14,
              color: model.isRead ? Colors.grey.shade800 : Colors.deepOrange,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget BuildHimMessage(MessageModel model, context, {username}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 2 / 3),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (model.replayMessage != null)
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        color: chatcolorr,
                        width: 4,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                model.senderId == model.replayMessage?.senderId
                                    ? "${username}"
                                    : "You",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                    color: Colors.black),
                              ),
                              if (model.replayMessage?.text != "")
                                Text(
                                  "${model.replayMessage?.text}",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 17),
                                ),
                              SizedBox(
                                height: 2,
                              ),
                              model.replayMessage?.image != ""
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  "${model.replayMessage?.image}"))),
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
              model.image != null &&
                      model.image != "" &&
                      model.image!.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        Get.to(DisplayChatImage(
                          image: model.image,
                        ));
                      },
                      child: Hero(
                        tag: "${model.image}",
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2.5,
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage("${model.image}"))),
                        ),
                      ),
                    )
                  : Container(
                      width: 0,
                    ),
              Text(
                "${model.text}",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              Text(
                "${formattedDateTime(model.dateTime, 'hh:mm a').toString()}",
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),
            ],
          )),
    ),
  );
}



    // SocialCubit.get(context)
    //                       .getComments(SocialCubit.get(context).postId[index]);
    //                   showModalBottomSheet(
    //                       context: context,
    //                       builder: (context) {
    //                         return Container(
    //                             padding: EdgeInsets.all(10),
    //                             color: Colors.white,
    //                             height: double.infinity,
    //                             child: Column(
    //                               children: [
    //                                 if (state is SocialGetCommentsSuccessState)
    //                                   Expanded(
    //                                     child: ListView.separated(
    //                                         itemBuilder: (context, index) {
    //                                           return userComments(
    //                                               SocialCubit.get(context)
    //                                                   .commentss[index]);
    //                                         },
    //                                         separatorBuilder: (context,
    //                                                 index) =>
    //                                             Container(
    //                                               margin: EdgeInsets.symmetric(
    //                                                   vertical: 7),
    //                                               height: 1,
    //                                               color: Colors.grey.shade300,
    //                                             ),
    //                                         itemCount: state.commentss!.length),
    //                                   ),
    //                                 Container(
    //                                   padding: EdgeInsets.only(left: 10),
    //                                   clipBehavior: Clip.antiAliasWithSaveLayer,
    //                                   decoration: BoxDecoration(
    //                                       border: Border.all(
    //                                           color: Colors.grey.shade300,
    //                                           width: 1),
    //                                       borderRadius:
    //                                           BorderRadius.circular(15)),
    //                                   child: Row(
    //                                     children: [
    //                                       Expanded(
    //                                           child: TextFormField(
    //                                         controller: controller2,
    //                                         decoration: InputDecoration(
    //                                             border: InputBorder.none,
    //                                             hintText:
    //                                                 "Write your comment here ..."),
    //                                         validator: (value) {
    //                                           if (value!.isEmpty) {
    //                                             "please write a message";
    //                                           }
    //                                           if (value.length == 0) {
    //                                             "please write a message";
    //                                           }
    //                                           return null;
    //                                         },
    //                                         autovalidateMode:
    //                                             AutovalidateMode.always,
    //                                       )),
    //                                       SizedBox(
    //                                         height: 50,
    //                                         child: MaterialButton(
    //                                           color: primarycolor,
    //                                           minWidth: 1,
    //                                           onPressed: () async {
    //                                             // var date =
    //                                             //     messagemodel?.dateTime ??
    //                                             //         "";
    //                                             // DateTime timestamp =
    //                                             //     DateTime.parse(date);
    //                                             SocialCubit.get(context)
    //                                                 .addComments(
    //                                                     postId: SocialCubit.get(
    //                                                             context)
    //                                                         .postId[index],
    //                                                     commentText:
    //                                                         controller2.text,
    //                                                     timestamp:
    //                                                         DateTime.now()
    //                                                             .toString());

    //                                             controller2.clear();
    //                                           },
    //                                           child: Icon(
    //                                             IconBroken.Send,
    //                                             color: Colors.white,
    //                                           ),
    //                                         ),
    //                                       )
    //                                     ],
    //                                   ),
    //                                 )
    //                               ],
    //                             ));
    //                       });
                      
                      // SocialCubit.get(context).addComments(
                      //     postId: SocialCubit.get(context).postId[index]);