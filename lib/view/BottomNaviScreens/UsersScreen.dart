// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/controller/socialCubit/cubit/social_cubit.dart';

import '../../Widgets.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch notifications from the database
    // Display notifications in a ListView
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder(
            stream: SocialCubit.get(context).getlikesAndCommentsNotifications(),
            builder: (context, snapshot) {
              SocialCubit.get(context).likesAndCommentsNotifications =
                  snapshot.data;
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: SocialCubit.get(context)
                      .likesAndCommentsNotifications!
                      .length,
                  itemBuilder: (context, index) {
                    return userLikesAndCommentsItem(
                      SocialCubit.get(context)
                          .likesAndCommentsNotifications![index],
                      context,
                      index,
                    );
                  });
            },
          ),
        );
      },
    );
  }
}
