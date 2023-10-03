// ignore_for_file: avoid_print, non_constant_identifier_names, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/UserModel.dart';
import 'Register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  bool changeicon = false;
  void changeIcon() {
    changeicon = !changeicon;
    emit(changeIconState());
  }

  void UserRegister() {
    emit(LoadingRegisterstate());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      print(value.user?.email);
      print(value.user?.uid);
      createUser(Uid: value.user!.uid);
    }).catchError((error) {
      print(error.toString());
      emit(ErrorRegisterState(error: error));
    });
  }

  void createUser({required String Uid}) async {
    final token = await FirebaseMessaging.instance.getToken();
    print(token);
    UserModel model = UserModel(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        image:
            "https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?w=740&t=st=1694313555~exp=1694314155~hmac=e3dd70a1eee08ed004afc819a6c2c7f75f857100decfae1107376907f82536c6",
        bio: "write your bio ...",
        cover:
            "https://img.freepik.com/free-photo/blue-user-icon-symbol-website-admin-social-login-element-concept-white-background-3d-rendering_56104-1217.jpg?w=826&t=st=1694313866~exp=1694314466~hmac=bba304e28ace8457c66404d193a171383cdcb26d11fa0fc2c87333127ffe8109",
        uid: Uid,
        tokenDevice: token.toString(),
        lastMessage: "No Message Yet",
        isEmailVarified: false,
        dateTime: "You haven't chatted with them yet");
    FirebaseFirestore.instance
        .collection("users")
        .doc(Uid)
        .set(model.toMap())
        .then((value) {
      emit(SuccsesfullCreateState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCreateState(error: error.toString()));
    });
  }
}
