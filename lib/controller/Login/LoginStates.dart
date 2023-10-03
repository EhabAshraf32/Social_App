// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: camel_case_types

abstract class LoginState {}

class LoginInitial extends LoginState {}

class changeIconState extends LoginState {}

class Loadingstate extends LoginState {}

class SuccsesfullLoginState extends LoginState {
  final String uId;
  SuccsesfullLoginState({
    required this.uId,
  });
}

class ErrorLoginState extends LoginState {
  String error;
  ErrorLoginState({
    required this.error,
  });
}

class FeatchUserDataState extends LoginState {}
