part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthInitEvent extends AuthEvent {}

class AuthLoginRequestEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequestEvent(this.email, this.password);
}

class AuthRegisterRequestEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  AuthRegisterRequestEvent(
    this.username,
    this.email,
    this.password,
    this.confirmPassword,
  );
}

class AuthVerifyCodeRequestEvent extends AuthEvent {
  final String code;

  AuthVerifyCodeRequestEvent(this.code);
}

class AuthResendCodeEvent extends AuthEvent {}