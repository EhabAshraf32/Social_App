// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../controller/socialCubit/cubit/social_cubit.dart';
import '../main.dart';
import '../model/UserModel.dart';
import '../styles/AuthStyles.dart';
import '../styles/icon_broken.dart';
import '../view/BottomNaviScreens/ChatsScreen.dart';
import '../view/BottomNaviScreens/NewPostScreen.dart';
import '../view/ChatSearchScreen.dart';

class BottomNaviBar extends StatelessWidget {
  const BottomNaviBar({super.key});

  static dynamic navigateToChatsTab(BuildContext context) {
    final cubit = SocialCubit.get(context);
    cubit.ChangeIndex(1); // Set selectedindex to 1 (Chats tab)
    // Get.to(() => ChatsScreen()); // Navigate to ChatsScreen
  }

  @override
  Widget build(BuildContext context) {
    var cubit = SocialCubit.get(context);

    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          print(cubit.model?.name);
          Get.to(() => NewPostScreen());
        }
      },
      builder: (context, state) {
        return StreamBuilder<int>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(cubit.model?.uid)
                .snapshots()
                .map((document) {
              final userData =
                  UserModel.fromMap(document.data() as Map<String, dynamic>);
              return userData.unreadNotification[cubit.model?.uid];
            }),
            builder: (context, snapshot) {
              int unreadCount = snapshot.data ?? 0;

              return Scaffold(
                appBar: AppBar(
                  centerTitle: cubit.selectedindex == 4 ? true : false,
                  title: cubit.selectedindex == 4
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${cubit.model?.name}",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: homeprimarycolor,
                              size: 18,
                            )
                          ],
                        )
                      : Text(
                          cubit.titles[cubit.selectedindex],
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                  actions: [
                    IconButton(
                        onPressed: () {}, icon: Icon(IconBroken.Notification)),
                    IconButton(
                        onPressed: () {
                          if (cubit.selectedindex == 1)
                            showSearch(context: context, delegate: SearchBar());
                        },
                        icon: Icon(IconBroken.Search))
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                    iconSize: 22,
                    currentIndex: cubit.selectedindex,
                    onTap: (index) {
                      cubit.ChangeIndex(index);
                    },
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(IconBroken.Home), label: "Home"),
                      BottomNavigationBarItem(
                          icon: Icon(IconBroken.Chat), label: "Chats"),
                      BottomNavigationBarItem(
                          icon: Icon(IconBroken.Paper_Upload), label: "Posts"),
                      BottomNavigationBarItem(
                          icon: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Icon(IconBroken.Notification),
                              if (unreadCount > 0)
                                CircleAvatar(
                                    radius: 6,
                                    backgroundColor: Colors.red,
                                    child: Text(
                                      "${unreadCount}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold),
                                    )),
                            ],
                          ),
                          label: "Notifications"),
                      BottomNavigationBarItem(
                          icon: CircleAvatar(
                            radius: 13,
                            backgroundColor: cubit.selectedindex == 4
                                ? homeprimarycolor
                                : Colors.grey,
                            child: CircleAvatar(
                              radius: 11,
                              backgroundImage:
                                  NetworkImage("${cubit.model?.image}"),
                            ),
                          ),
                          label: "Profile")
                    ]),
                body: cubit.pages[cubit.selectedindex],
              );
            });
      },
    );
  }
}
