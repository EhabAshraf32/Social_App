// // ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, prefer_const_constructors

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import 'package:hexcolor/hexcolor.dart';
// import 'package:shopapp/Widgets.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
//   print("On BackgroungMessage");

//   print(message?.data.toString());
// }

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//   Future<void> initNotification() async {
//     await _firebaseMessaging.requestPermission(
//         // alert: true,
//         // announcement: false,
//         // badge: true,
//         // carPlay: false,
//         // criticalAlert: false,
//         // provisional: false,
//         // sound: true,
//         );

//     final token = await _firebaseMessaging.getToken();
//     print("Token is ${token} ");

//     FirebaseMessaging.onMessage.listen((event) {
//       print("On Message");
//       print(event.data.toString());
//       snackbar(
//         type: "Notification",
//         message: "One Message",
//         color: HexColor("#021518"),
//       );
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       print("On Message Opened App");
//       print(event.data.toString());
//       snackbar(
//         type: "Notification",
//         message: "On Message Opened App",
//         color: HexColor("#021518"),
//       );
//     });
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
// }
