// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:socialapp/view/AllUsersProfileScreen.dart';
import 'package:socialapp/view/BottomNaviScreens/SettingsScreen.dart';
import 'package:socialapp/view/ChangePassword.dart';

import '../Widgets.dart';
import '../controller/socialCubit/cubit/social_cubit.dart';
import '../main.dart';
import '../model/CreatePost.dart';
import '../model/UserModel.dart';
import '../styles/AuthStyles.dart';
import '../styles/icon_broken.dart';
import '../view/BottomNaviScreens/NewPostScreen.dart';
import '../view/ChatSearchScreen.dart';
import '../view/drawer.dart';

class BottomNaviBar extends StatelessWidget {
  const BottomNaviBar({super.key});

  static dynamic navigateToChatsTab(BuildContext context) {
    final cubit = SocialCubit.get(context);
    cubit.ChangeIndex(1);
  }

  static dynamic navigateToNotificationsTab(BuildContext context) {
    final cubit = SocialCubit.get(context);
    cubit.ChangeIndex(3);
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

              return AdvancedDrawer(
                drawer: SafeArea(
                  child: Container(
                    child: ListTileTheme(
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 24, bottom: 40),
                            child: CircleAvatar(
                              radius: 74,
                              backgroundColor: Colors.blueGrey,
                              child: CircleAvatar(
                                backgroundColor: primarycolor,
                                radius: 70,
                                backgroundImage: cubit.model?.image != null
                                    ? NetworkImage("${cubit.model?.image}")
                                    : AssetImage("assets/defaultprofile.png")
                                        as ImageProvider,
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Get.to(SettingsScreen());
                            },
                            leading: Icon(IconBroken.Profile),
                            title: Text('Profile'),
                          ),
                          ListTile(
                            onTap: () {
                              Get.to(() => ChangepasswordScreen());
                            },
                            leading: Icon(IconBroken.Password),
                            title: Text('Change Password'),
                          ),
                          ListTile(
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              SignOut(context);
                            },
                            leading: Icon(IconBroken.Logout),
                            title: Text('Sign Out'),
                          ),
                          Spacer(),
                          DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: Text('Terms of Service | Privacy Policy'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                backdrop: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blueGrey,
                        Colors.blueGrey.withOpacity(0.2)
                      ],
                    ),
                  ),
                ),
                controller: cubit.advancedDrawerController,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 300),
                animateChildDecoration: true,
                rtlOpening: false,
                // openScale: 1.0,
                disabledGestures: false,
                childDecoration: const BoxDecoration(
                  // NOTICE: Uncomment if you want to add shadow behind the page.
                  // Keep in mind that it may cause animation jerks.
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //     color: Colors.black12,
                  //     blurRadius: 0.0,
                  //   ),
                  // ],
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: cubit.handleMenuButtonPressed,
                      icon: ValueListenableBuilder<AdvancedDrawerValue>(
                        valueListenable: cubit.advancedDrawerController,
                        builder: (_, value, __) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 250),
                            child: Icon(
                              value.visible ? Icons.clear : IconBroken.Setting,
                              key: ValueKey<bool>(value.visible),
                            ),
                          );
                        },
                      ),
                    ),
                    centerTitle: cubit.selectedindex == 4 ? true : false,
                    title: cubit.selectedindex == 4
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${cubit.model?.name}",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height / 40,
                                    fontWeight: FontWeight.bold),
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
                      if (cubit.selectedindex == 3)
                        IconButton(
                            onPressed: () {
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
                                                  .deleteAllNotifications();
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
                                          "are you sure that you want to delete all notifications",
                                          style:
                                              TextStyle(color: primarycolor)),
                                      backgroundColor: Colors.white,
                                    );
                                  });
                            },
                            icon: Icon(IconBroken.Delete)),
                      if (cubit.selectedindex != 3)
                        IconButton(
                            onPressed: () {
                              if (cubit.selectedindex == 1)
                                showSearch(
                                    context: context, delegate: SearchBar());
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
                            icon: Icon(IconBroken.Paper_Upload),
                            label: "Posts"),
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
                                backgroundColor: Colors.grey.shade300,
                                radius: 11,
                                backgroundImage:
                                    NetworkImage("${cubit.model?.image}"),
                              ),
                            ),
                            label: "Profile")
                      ]),
                  body: cubit.pages[cubit.selectedindex],
                ),
              );
            });
      },
    );
  }
}
