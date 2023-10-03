// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets.dart';
import '../controller/socialCubit/cubit/social_cubit.dart';
import '../model/MessagesModel.dart';

class MessageSearchDelegate extends SearchDelegate<String> {
  Function(MessageModel)? onTapMessage; // Callback to navigate to a message

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
        onPressed: () {
          Get.back();
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = SocialCubit.get(context)
        .messagesmodel
        .where((message) =>
            message.text.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.separated(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final messagemodel = results[index];

        if (messagemodel.senderId == SocialCubit.get(context).model?.uid) {
          return BuildMyMessage(messagemodel, context);
        } else {
          return BuildHimMessage(messagemodel, context);
        }
      },
      separatorBuilder: (context, index) => SizedBox(
        height: 15,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = SocialCubit.get(context)
        .messagesmodel
        .where((message) =>
            message.text.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.separated(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final messagemodel = suggestions[index];

        if (messagemodel.senderId == SocialCubit.get(context).model?.uid) {
          return BuildMyMessage(messagemodel, context);
        } else {
          return BuildHimMessage(messagemodel, context);
        }
      },
      separatorBuilder: (context, index) => SizedBox(
        height: 15,
      ),
    );
  }
}
