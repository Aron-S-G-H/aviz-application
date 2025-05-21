import 'package:aviz_project/DI/di.dart';
import 'package:aviz_project/features/Authentication/data/manager/auth_manager.dart';
import 'package:aviz_project/features/Authentication/data/model/user_info.dart';
import 'package:aviz_project/features/Authentication/data/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authenticationRepository = locator.get();

  AuthBloc() : super(AuthInitState()) {
    on<AuthInitEvent>(
      (event, emit) => emit(AuthInitState()),
    );

    on<AuthLoginRequestEvent>(
      (event, emit) async {
        emit(AuthLoadingState());
        var response = await _authenticationRepository.login(
          event.email,
          event.password,
        );
        emit(AuthResponseState(response));
      },
    );

    on<AuthRegisterRequestEvent>(
      (event, emit) async {
        emit(AuthLoadingState());
        var response = await _authenticationRepository.register(
          event.username,
          event.email,
          event.password,
          event.confirmPassword,
        );
        emit(AuthResponseState(response));
      },
    );

    on<AuthVerifyCodeRequestEvent>(
      (event, emit) async {
        emit(AuthLoadingState());
        var response = await _authenticationRepository.verifyCode(event.code);
        emit(AuthResponseState(response));
      },
    );

    on<AuthResendCodeEvent>(
      (event, emit) async {
        emit(AuthLoadingState());
        UserInfo userInfo = AuthManager.getUserInfo();
        var response = await _authenticationRepository.register(
          userInfo.username,
          userInfo.email,
          userInfo.password,
          userInfo.confirmPassword,
        );
        emit(AuthResentCodeReponseState(response));
      },
    );
  }
}
