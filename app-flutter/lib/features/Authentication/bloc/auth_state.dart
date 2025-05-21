part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

class AuthInitState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthResponseState extends AuthState {
  final Either<String, String> response;
  AuthResponseState(this.response);
}

class AuthResentCodeReponseState extends AuthState {
  final Either<String, String> response;
  AuthResentCodeReponseState(this.response);
}