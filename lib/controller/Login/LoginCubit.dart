// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/variables.dart';
import 'LoginStates.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit get(context) => BlocProvider.of(context);

  //late Loginmodel LoginData;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  bool changeicon = false;
  void changeIcon() {
    changeicon = !changeicon;
    emit(changeIconState());
  }

  void fetchUid({required String Uid}) {
    uid = Uid;
    emit(FeatchUserDataState());
  }

  void UserLogin() {
    emit(Loadingstate());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      print(value.user?.email);
      print(value.user?.uid);
      emit(SuccsesfullLoginState(uId: (value.user!.uid)));
    }).catchError((error) {
      print(error.toString());
      emit(ErrorLoginState(error: error.toString()));
    });
  }
}
