// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors_in_immutables, avoid_print
// ignore_for_file: non_constant_identifier_names, unused_local_variable, prefer_const_constructors, unnecessary_null_comparison

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:socialapp/styles/AuthStyles.dart';
import 'package:socialapp/view/BottomNaviScreens/ChatsScreen.dart';
import 'package:socialapp/view/Login.dart';
import 'package:socialapp/view/OnBoarding.dart';

import 'BlocObserve.dart';
import 'constants/variables.dart';
import 'controller/Login/LoginCubit.dart';
import 'controller/Register/Register_cubit.dart';
import 'controller/socialCubit/cubit/social_cubit.dart';
import 'helper/local/sharedPref.dart';
import 'layout/BottomNaviBar.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SocialCubit().initNotification();
  await SharedPref.init();
  bool OnBoard = SharedPref.getData(key: "OnBoarding");
  uid = SharedPref.getData(key: "uId");
  print(uid);
  Bloc.observer = MyBlocObserver();

  Widget widget;

  if (OnBoard != null) {
    if (uid != null) {
      widget = BottomNaviBar();
    } else {
      widget = Login();
    }
  } else {
    widget = OnBoarding();
  }

  runApp(MyApp(
    widget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget widget;
  MyApp({
    super.key,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => SocialCubit()
              ..getPosts()
              ..getUserData()),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        getPages: [
          GetPage(
              name: '/chats',
              page: () => ChatsScreen()), // Define ChatsScreen route
          GetPage(name: '/bottomnavi', page: () => BottomNaviBar()),
        ],
        theme: ThemeData(
          fontFamily: "ehab",
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: homeprimarycolor,
              unselectedItemColor: Colors.grey,
              elevation: 20,
              backgroundColor: Colors.white),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: primarycolor, size: 26),
            titleTextStyle:
                TextStyle(color: primarycolor, fontWeight: FontWeight.w500),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
            ),
          ),
        ),
        home: widget,
      ),
    );
  }
}
