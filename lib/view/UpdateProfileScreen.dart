// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/socialCubit/cubit/social_cubit.dart';
import '../styles/AuthStyles.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});
  TextEditingController Namecontroller = TextEditingController();
  TextEditingController Biocontroller = TextEditingController();

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigh = MediaQuery.of(context).size.height;
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var model = SocialCubit.get(context).model;

        var profileimage = SocialCubit.get(context).profileimage;
        var coverimage = SocialCubit.get(context).coverImage;

        final bio = model?.bio ?? '';
        final Name = model?.name ?? '';

        Namecontroller.text = Name;
        Biocontroller.text = bio;
        return Scaffold(
          appBar: AppBar(
            title: Text("Edit profile"),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () {
                  SocialCubit.get(context).updateUserData(
                      name: Namecontroller.text, bio: Biocontroller.text);
                },
                child: Text(
                  "Update",
                  style: TextStyle(
                      color: homeprimarycolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              )
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      if (state is SocialUpdateUserDetailsLoadingState ||
                          state is SocialGetUserLoadingState ||
                          state is SocialProfilePicedImageLoadingState)
                        LinearProgressIndicator(
                          color: primarycolor,
                        ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: TextFormField(
                                onFieldSubmitted: (value) {
                                  if (formkey.currentState!.validate()) {
                                    SocialCubit.get(context).updateUserData(
                                        name: Namecontroller.text,
                                        bio: Biocontroller.text);
                                  }
                                },
                                controller: Namecontroller,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor)),
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor)),
                                ),
                                autovalidateMode: AutovalidateMode.always,
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return "Name must not be empty";
                                  }
                                  if (text.length > 19) {
                                    return "Name must not be more than 19 letters";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Bio",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.always,
                                onFieldSubmitted: (value) {
                                  if (formkey.currentState!.validate()) {
                                    SocialCubit.get(context).updateUserData(
                                        name: Namecontroller.text,
                                        bio: Biocontroller.text);
                                  }
                                },
                                maxLines: 2,
                                controller: Biocontroller,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor)),
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primarycolor)),
                                ),
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return "Bio must not be empty";
                                  }
                                  if (text.length > 50) {
                                    return "Bio must not be more than 200";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Profile picture",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    SocialCubit.get(context).getProfileImage(
                                        name: Namecontroller.text,
                                        bio: Biocontroller.text);
                                  },
                                  child: Container(
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(
                                          color: homeprimarycolor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: CircleAvatar(
                                radius: 85,
                                backgroundImage: profileimage == null
                                    ? NetworkImage("${model?.image}")
                                    : FileImage(profileimage) as ImageProvider,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              color: Colors.grey[300],
                              height: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Cover photo",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    SocialCubit.get(context).getcoverImage(
                                        name: Namecontroller.text,
                                        bio: Biocontroller.text);
                                  },
                                  child: Container(
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(
                                          color: homeprimarycolor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: heigh / 4.2,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: coverimage == null
                                        ? NetworkImage("${model?.cover}")
                                        : FileImage(coverimage)
                                            as ImageProvider,
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              color: Colors.grey,
                              height: 1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
