// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_element, override_on_non_overriding_member, annotate_overrides

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:socialapp/constants/variables.dart';
import 'package:socialapp/controller/socialCubit/cubit/social_cubit.dart';

import '../Widgets.dart';
import '../controller/Login/LoginCubit.dart';
import '../controller/Login/LoginStates.dart';
import '../helper/local/sharedPref.dart';
import '../layout/BottomNaviBar.dart';
import '../styles/AuthStyles.dart';
import 'Register.dart';

class Login extends StatelessWidget {
  Login({super.key});

  @override
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is SuccsesfullLoginState) {
          SharedPref.setData(key: "uId", value: state.uId).then((value) {
            uid = state.uId;
            LoginCubit.get(context).fetchUid(Uid: state.uId);

            SocialCubit.get(context).getUserData();
            Get.offAll(BottomNaviBar());
            snackbar(
                type: "Success",
                message: "Successful Login",
                color: HexColor("#1B5E20"));
          });
        } else if (state is ErrorLoginState) {
          snackbar(
              type: "Error",
              message: "${state.error}",
              color: HexColor("#990000"));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: primarycolor,
          body: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                topheader(context, 'Create\nYour\nAccount',
                    image: 'assets/gbimage.png'),
                Expanded(
                    child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.grey[50],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Sign In",
                          style: TextStyle(
                              color: primarycolor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        inputTextField(
                            validator: (text) {
                              if (text.length == 0 || !text.contains("@")) {
                                return "please enter valid email address @example.com";
                              }
                              if (text.length < 6) {
                                return "Email can not be Less than 6 Letter";
                              }
                              if (text.isEmpty) {
                                return "The field can not be empty";
                              }

                              return null;
                            },
                            keyboartype: TextInputType.emailAddress,
                            hintText: 'example@email.com',
                            labeltext: "Email",
                            obscuretext: false,
                            controller:
                                LoginCubit.get(context).emailController),

                        SizedBox(height: 16),

                        inputTextField(
                            validator: (text) {
                              if (text.isEmpty) {
                                return "Password can not be Empty";
                              }
                              if (text.length < 6) {
                                return "Password can not be Less than 6 Letter";
                              }

                              return null;
                            },
                            keyboartype: TextInputType.visiblePassword,
                            hintText: '******',
                            labeltext: "Password",
                            obscuretext: LoginCubit.get(context).changeicon
                                ? false
                                : true,
                            icon: IconButton(
                                onPressed: () {
                                  LoginCubit.get(context).changeIcon();
                                },
                                icon: LoginCubit.get(context).changeicon
                                    ? Icon(
                                        Icons.visibility,
                                        color: primarycolor,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: Color(0xFF979797),
                                      )),
                            controller:
                                LoginCubit.get(context).passwordController),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              //TODO
                            },
                            child: Text(
                              'Forgot Password ?',
                              style: TextStyle(
                                color: primarycolor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ConditionalBuilder(
                          condition: state is! Loadingstate,
                          builder: (context) => GestureDetector(
                            onTap: () {
                              if (formkey.currentState!.validate()) {
                                LoginCubit.get(context).UserLogin();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: primarycolor,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                          fallback: (context) => Center(
                            child:
                                CircularProgressIndicator(color: primarycolor),
                          ),
                        ),

                        SizedBox(height: 18),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '__OR__',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 238, 235, 235),
                                    padding: EdgeInsets.all(10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () {},
                                label: Text(
                                  "Login with google",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: primarycolor,
                                  ),
                                ),
                                icon: Image(
                                  image: AssetImage("assets/gog.png"),
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Spacer(),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account ?",
                                style: TextStyle(color: Colors.black54)),
                            TextButton(
                                onPressed: () {
                                  Get.to(Register());
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(color: primarycolor),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}
