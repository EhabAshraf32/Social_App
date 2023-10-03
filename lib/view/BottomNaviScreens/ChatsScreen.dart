// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Widgets.dart';
import '../../controller/socialCubit/cubit/social_cubit.dart';
import '../../model/UserModel.dart';
import '../../styles/AuthStyles.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .orderBy("dateTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'Search to chat with friends',
                    style: TextStyle(
                        color: primarycolor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                final users = snapshot.data!.docs
                    .map((document) => UserModel.fromMap(
                        document.data() as Map<String, dynamic>))
                    .where((user) =>
                        user.uid != SocialCubit.get(context).model?.uid)
                    .toList();

                return ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final userModel = users[index];
                    return chatsListView(userModel, context);
                    // Add a null check here
                  },
                  separatorBuilder: (context, index) => Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  itemCount: users.length,
                );
              }
            },
          ),
        );
      },
    );
  }
}
