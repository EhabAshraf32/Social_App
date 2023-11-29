// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, unnecessary_null_comparison, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:socialapp/controller/socialCubit/cubit/social_cubit.dart';
import 'package:socialapp/styles/AuthStyles.dart';
import '../Widgets.dart';

class ChangepasswordScreen extends StatelessWidget {
  ChangepasswordScreen({super.key});
  var formstate = GlobalKey<FormState>();
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is SocialUpdatePasswordSuccessState) {
          snackbar(
              type: "Success",
              message:
                  "Your password has been changed successfully", // Access directly from state.model
              color: HexColor("#1B5E20"));
        } else if (state is SocialUpdatePasswordErrorState) {
          snackbar(
              type: "Error",
              message:
                  "Make sure your data is correct", // Access directly from state.model
              color: HexColor("#1B5E20"));
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back,
                  color: primarycolor,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Change Password",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Form(
                    key: formstate,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state is SocialUpdatePasswordLoadingState)
                            LinearProgressIndicator(
                              color: primarycolor,
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          inputTextField(
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "The field can not be empty";
                                }
                                if (text !=
                                    SocialCubit.get(context).model!.password) {
                                  return "Your old password not correct";
                                }

                                return null;
                              },
                              keyboartype: TextInputType.emailAddress,
                              hintText: 'old password',
                              labeltext: "Old pasword",
                              obscuretext: false,
                              controller: oldpasswordController),
                          SizedBox(height: 16),
                          inputTextField(
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Password can not be Empty";
                                }
                                return null;
                              },
                              keyboartype: TextInputType.visiblePassword,
                              hintText: '******',
                              labeltext: "New Password",
                              obscuretext: SocialCubit.get(context).changeicon
                                  ? false
                                  : true,
                              icon: IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).changeIcon();
                                  },
                                  icon: SocialCubit.get(context).changeicon
                                      ? Icon(
                                          Icons.visibility,
                                          color: primarycolor,
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          color: Color(0xFF979797),
                                        )),
                              controller: newpasswordController),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 14,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primarycolor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (formstate.currentState!.validate()) {
                                    SocialCubit.get(context).changePassword(
                                        newPassword:
                                            newpasswordController.text);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Check Out",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                )),
                          )
                        ]))));
      },
    );
  }
}
