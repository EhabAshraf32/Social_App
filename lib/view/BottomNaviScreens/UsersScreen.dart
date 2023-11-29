// ignore_for_file: prefer_const_constructors, avoid_print, prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/controller/socialCubit/cubit/social_cubit.dart';

import '../../Widgets.dart';
import 'package:gif_view/gif_view.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder(
            stream: SocialCubit.get(context).getlikesAndCommentsNotifications(
                UID: SocialCubit.get(context).model!.uid),
            builder: (context, snapshot) {
              SocialCubit.get(context).likesAndCommentsNotifications =
                  snapshot.data;
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (SocialCubit.get(context)
                      .likesAndCommentsNotifications
                      ?.length !=
                  0) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: SocialCubit.get(context)
                        .likesAndCommentsNotifications!
                        .length,
                    itemBuilder: (context, index) {
                      if (SocialCubit.get(context)
                              .likesAndCommentsNotifications
                              ?.length !=
                          0) {
                        return userLikesAndCommentsItem(
                          SocialCubit.get(context)
                              .likesAndCommentsNotifications![index],
                          context,
                          index,
                        );
                      }
                    });
              } else {
                return Center(
                  child: GifView.asset(
                    "assets/notification.gif",
                    height: MediaQuery.of(context).size.height / 3.5,
                    width: MediaQuery.of(context).size.width / 3.5,
                    frameRate: 30,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
