// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

var raisedDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: Colors.grey,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(5, 2),
        blurRadius: 3.0,
        spreadRadius: 0.0,
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-5, -2),
        blurRadius: 3.0,
        spreadRadius: 0.0,
      ),
    ]);

const primarycolor = Color.fromARGB(255, 32, 50, 58);
const homeprimarycolor = Color.fromARGB(255, 55, 134, 170);
const chatcolorr = Color.fromARGB(255, 160, 204, 223);

Color facebookColor = Color(0xFF416BC1);
Color googleColor = Color(0xFFCF4333);
Color twitterColor = Color(0xFF08A0E9);
