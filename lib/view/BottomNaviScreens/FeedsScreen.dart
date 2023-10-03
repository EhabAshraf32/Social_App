// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, sized_box_for_whitespace, unrelated_type_equality_checks, unnecessary_string_interpolations, prefer_is_empty, non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_null_comparison

import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../Widgets.dart';
import '../../controller/socialCubit/cubit/social_cubit.dart';
import '../../model/CreatePost.dart';
import '../../model/setLikes.dart';
import '../../styles/AuthStyles.dart';
import '../LoadingPost.dart';

class FeedsScreen extends StatelessWidget {
  FeedsScreen({super.key});
  setLike? likeModel;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigh = MediaQuery.of(context).size.height;
    var bo = false;
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is SocialGetUserLoadingState) {
          LoadingPost();
        }
      },
      builder: (context, state) {
        if (SocialCubit.get(context).model != null &&
            SocialCubit.get(context).posts.isNotEmpty &&
            state is! SocialGetUserLoadingState) {
          return ConditionalBuilder(
              condition: SocialCubit.get(context).model != null &&
                  SocialCubit.get(context).posts.length != 0 &&
                  SocialCubit.get(context).posts.isNotEmpty &&
                  state is! SocialGetUserLoadingState,
              builder: (context) => RefreshIndicator(
                    backgroundColor: primarycolor,
                    displacement: 50.0,
                    onRefresh: () async {
                      // Add the logic here to refresh and fetch new posts
                      await SocialCubit.get(context).refreshPosts();
                    },
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => buildPostItem(
                                    context,
                                    heigh,
                                    SocialCubit.get(context).posts[index],
                                    state,
                                    index),
                                separatorBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 2,
                                        width: double.infinity,
                                      ),
                                    ),
                                itemCount:
                                    SocialCubit.get(context).posts.length),
                            SizedBox(
                              height: 8,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              fallback: (context) {
                // Display a loading indicator while refreshing
                return LoadingPost();
              });
        } else {
          return LoadingPost();
        }
      },
    );
  }

  Widget Hashtag({required String text}) {
    return Container(
      padding: EdgeInsetsDirectional.only(end: 6, bottom: 1),
      child: Text(
        "${text}",
        style: TextStyle(color: homeprimarycolor),
      ),
    );
  }
}
