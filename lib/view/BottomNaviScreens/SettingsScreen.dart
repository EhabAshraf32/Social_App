// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, sized_box_for_whitespace, unnecessary_string_interpolations, dead_code, curly_braces_in_flow_control_structures, body_might_complete_normally_nullable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../Widgets.dart';
import '../../controller/socialCubit/cubit/social_cubit.dart';
import '../../model/CreatePost.dart';
import '../../styles/AuthStyles.dart';
import '../../styles/icon_broken.dart';
import '../DisplayChatImage.dart';
import '../ShowProfilePhoto.dart';
import '../UpdateProfileScreen.dart';
import 'NewPostScreen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigh = MediaQuery.of(context).size.height;
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var model = SocialCubit.get(context).model;
        return ConditionalBuilder(
            condition: SocialCubit.get(context).model != null &&
                state is! SocialGetUserLoadingState &&
                SocialCubit.get(context).posts.isNotEmpty,
            builder: (context) => RefreshIndicator(
                  backgroundColor: primarycolor,
                  onRefresh: () async {
                    // Add the logic here to refresh and fetch new posts
                    await SocialCubit.get(context).refreshPosts();
                  },
                  child: GestureDetector(
                    onTap: () {
                      SocialCubit.get(context).returnPhotoDefault();
                    },
                    child: Scaffold(
                        body: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: heigh / 3.3,
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(DisplayChatImage(
                                        image: model?.cover,
                                      ));
                                    },
                                    child: Hero(
                                      tag: "${model?.cover}",
                                      child: Container(
                                        height: heigh / 4.2,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(4),
                                                topLeft: Radius.circular(4)),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: model?.cover != null
                                                    ? NetworkImage(
                                                        "${model?.cover}")
                                                    : AssetImage(
                                                            "assets/defaultCover.png")
                                                        as ImageProvider)),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(ShowProfilePhoto(
                                      image: model?.image,
                                    ));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: width / 27),
                                    child: Hero(
                                      tag: "${model?.image}",
                                      child: CircleAvatar(
                                        radius: 74,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        child: CircleAvatar(
                                          backgroundColor: primarycolor,
                                          radius: 70,
                                          backgroundImage: model?.image != null
                                              ? NetworkImage("${model?.image}")
                                              : AssetImage(
                                                      "assets/defaultprofile.png")
                                                  as ImageProvider,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${model?.name}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  "${model?.bio}",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(NewPostScreen());
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: primarycolor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                  topRight: Radius.circular(5)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  IconBroken.Paper_Upload,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  'Add Post',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(UpdateProfileScreen(),
                                              curve: Curves.bounceIn,
                                              duration: Duration(seconds: 1));
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: 45,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                  topRight: Radius.circular(5)),
                                            ),
                                            child:
                                                Icon(IconBroken.Edit_Square)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                CreatePostModel? postmodel;
                                // ignore: unrelated_type_equality_checks
                                if (SocialCubit.get(context).posts[index].uid ==
                                    model?.uid) {
                                  return buildPostItem(
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
                        ],
                      ),
                    )),
                  ),
                ),
            fallback: (context) => Center(child: CircularProgressIndicator()));
      },
    );
  }
}
