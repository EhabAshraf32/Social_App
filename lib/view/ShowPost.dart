// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, sized_box_for_whitespace, unrelated_type_equality_checks, unnecessary_string_interpolations, prefer_is_empty, non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_null_comparison, curly_braces_in_flow_control_structures, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:socialapp/model/CreatePost.dart';
import 'package:socialapp/view/AllUsersProfileScreen.dart';
import '../../controller/socialCubit/cubit/social_cubit.dart';
import '../../model/setLikes.dart';
import '../../styles/AuthStyles.dart';

import '../Widgets.dart';
import '../model/LikesAndCommentsNotifications.dart';
import 'LoadingPost.dart';

class ShowPost extends StatelessWidget {
  ShowPost({super.key, required this.model});
  setLike? likeModel;
  LikesAndCommentsNotifications model;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigh = MediaQuery.of(context).size.height;
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is SocialGetUserLoadingState) {
          LoadingPost();
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          backgroundColor: primarycolor,
          displacement: 50.0,
          onRefresh: () async {
            // Add the logic here to refresh and fetch new posts
            await SocialCubit.get(context).refreshPosts();
          },
          child: StreamBuilder(
              stream: SocialCubit.get(context)
                  .getlikesAndCommentsNotifications(UID: model.uid),
              builder: (context, snapshot) {
                SocialCubit.get(context).likesAndCommentsNotifications =
                    snapshot.data;
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: primarycolor,
                      ),
                    ),
                    title: InkWell(
                      onTap: () {
                        Get.to((AllUsersProfileScreen(
                            model: CreatePostModel(
                                uid: SocialCubit.get(context).model!.uid,
                                name: SocialCubit.get(context).model!.name,
                                email: SocialCubit.get(context).model!.email,
                                phone: SocialCubit.get(context).model!.phone,
                                password:
                                    SocialCubit.get(context).model!.password,
                                cover: SocialCubit.get(context).model!.cover,
                                bio: SocialCubit.get(context).model!.bio,
                                image: SocialCubit.get(context).model!.image,
                                tokenDevice: SocialCubit.get(context)
                                    .model!
                                    .tokenDevice))));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Hero(
                            tag: "${model.uid}",
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  "${SocialCubit.get(context).model?.image}"),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("${SocialCubit.get(context).model?.name}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            if (SocialCubit.get(context).model?.uid ==
                                model.recevUserId) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actionsPadding:
                                          EdgeInsets.only(bottom: 10),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("cancel",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              SocialCubit.get(context)
                                                  .deletePost(model.postId);
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
                                          style:
                                              TextStyle(color: primarycolor)),
                                      backgroundColor: Colors.white,
                                    );
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actionsPadding:
                                          EdgeInsets.only(bottom: 10),
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
                                          style:
                                              TextStyle(color: primarycolor)),
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
                    centerTitle: true,
                  ),
                  backgroundColor: Colors.white,
                  body: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // ignore: unrelated_type_equality_checks
                        if (SocialCubit.get(context).postId[index] ==
                            model.postId) {
                          return buildPostItemmmmm(
                            context,
                            heigh,
                            SocialCubit.get(context).posts[index],
                            state,
                            index,
                          );
                        } else {
                          // Return an empty container or null for posts by other users
                          return Container(); // You can replace this with any widget you prefer
                        }
                      },
                      separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              height: 2,
                              width: double.infinity,
                            ),
                          ),
                      itemCount: SocialCubit.get(context).posts.length),
                );
              }),
        );
      },
    );
  }
}
