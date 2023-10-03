// ignore_for_file: camel_case_types, non_constant_identifier_names

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class changeIconState extends RegisterState {}

class LoadingRegisterstate extends RegisterState {}

class SuccsesfullRegisterState extends RegisterState {}

class ErrorRegisterState extends RegisterState {
  String error;
  ErrorRegisterState({
    required this.error,
  });
}

class SuccsesfullCreateState extends RegisterState {}

class ErrorCreateState extends RegisterState {
  String error;
  ErrorCreateState({
    required this.error,
  });
}
