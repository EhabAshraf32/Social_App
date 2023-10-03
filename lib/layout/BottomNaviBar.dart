// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../controller/socialCubit/cubit/social_cubit.dart';
import '../main.dart';
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
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(IconBroken.Notification)),
              IconButton(
                  onPressed: () {
                    if (cubit.selectedindex == 1)
                      showSearch(context: context, delegate: SearchBar());
                  },
                  icon: Icon(IconBroken.Search))
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
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
                    icon: Icon(IconBroken.Location), label: "Users"),
                BottomNavigationBarItem(
                    icon: CircleAvatar(
                      radius: 19,
                      backgroundColor: cubit.selectedindex == 4
                          ? homeprimarycolor
                          : Colors.grey,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage("${cubit.model?.image}"),
                      ),
                    ),
                    label: "Profile")
              ]),
          body: cubit.pages[cubit.selectedindex],
        );
      },
    );
  }
}
