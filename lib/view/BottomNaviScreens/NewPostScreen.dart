// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, unnecessary_cast, unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Widgets.dart';
import '../../controller/socialCubit/cubit/social_cubit.dart';
import '../../styles/AuthStyles.dart';
import '../../styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({super.key});
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is SocialCreatePostSuccessState) {
          SocialCubit.get(context).selectedindex = 0;
          Get.back();
          snackbar(
            type: "Success",
            snackPosition: SnackPosition.TOP,
            color: HexColor("#1B5E20"),
            message: "The post has been added successfully",
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: primarycolor,
              child: Icon(
                IconBroken.Image_2,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                SocialCubit.get(context).getPostImage();
              }),
          appBar: AppBar(
            title: Text("Create Post"),
            leading: IconButton(
                onPressed: () {
                  SocialCubit.get(context).ChangeIndex(0);
                  Get.back();
                },
                icon: Icon(IconBroken.Arrow___Left_Square)),
            centerTitle: true,
            actions: [
              TextButton(
                  onPressed: () {
                    if (SocialCubit.get(context).Postimage == null) {
                      SocialCubit.get(context).createPost(
                          text: controller.text,
                          datetime: DateTime.now().toString());
                    } else {
                      SocialCubit.get(context).uploadPostImage(
                          text: controller.text,
                          datetime: DateTime.now().toString());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Post",
                          style:
                              TextStyle(color: homeprimarycolor, fontSize: 20))
                    ],
                  )),
            ],
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  if (state is SocialCreatePostLoadingState ||
                      state is SocialPostPicedImageLoadingState)
                    LinearProgressIndicator(
                      backgroundColor: primarycolor,
                    ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              "${SocialCubit.get(context).model?.image}"),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "${SocialCubit.get(context).model?.name}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 200,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            TextFormField(
                              maxLines: 2,
                              controller: controller,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "What's on your mind? "),
                            ),
                            if (state is SocialPostPicedImageSuccesState)
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(SocialCubit.get(
                                                          context)
                                                      .Postimage ??
                                                  File('path_to_default_image'))
                                              as ImageProvider,
                                        )),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        SocialCubit.get(context).removeImage();
                                      },
                                      icon: CircleAvatar(
                                        backgroundColor: Colors.redAccent,
                                        radius: 15,
                                        child: Icon(Icons.close),
                                      ))
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: primarycolor,
              //     borderRadius: BorderRadius.only(
              //       topRight: Radius.circular(10),
              //       topLeft: Radius.circular(10),
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: TextButton(
              //             onPressed: () {
              //               SocialCubit.get(context).getPostImage();
              //             },
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Icon(
              //                   IconBroken.Camera,
              //                   color: homeprimarycolor,
              //                   size: 30,
              //                 ),
              //                 SizedBox(
              //                   width: 5,
              //                 ),
              //                 Text(
              //                   "add photo",
              //                   style: TextStyle(
              //                       color: homeprimarycolor,
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.bold),
              //                 )
              //               ],
              //             )),
              //       ),
              //       Expanded(
              //         child: TextButton(
              //             onPressed: () {},
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Text("# tags",
              //                     style: TextStyle(
              //                         color: homeprimarycolor,
              //                         fontSize: 15,
              //                         fontWeight: FontWeight.bold))
              //               ],
              //             )),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        );
      },
    );
  }
}
