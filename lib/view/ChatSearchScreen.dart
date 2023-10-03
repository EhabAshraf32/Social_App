// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets.dart';
import '../controller/socialCubit/cubit/social_cubit.dart';

class SearchBar extends SearchDelegate {
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
        .getallUsers
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final userModel = results[index];
        return chatsListView(userModel, context);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = SocialCubit.get(context)
        .getallUsers
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.separated(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final userModel = suggestions[index];
        return InkWell(
          onTap: () {
            query = userModel.name;
            showResults(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage("${userModel.image}"),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "${userModel.name}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );

        // ListTile(
        //   title: Text(userModel.name),
        //   onTap: () {
        //     query = userModel.name;
        //     showResults(context);
        //   },
        // );
      },
      separatorBuilder: (context, index) => Container(
        height: 1,
        color: Colors.grey[300],
      ),
    );
  }
}
