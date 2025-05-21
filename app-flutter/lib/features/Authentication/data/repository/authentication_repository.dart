import 'package:aviz_project/features/Authentication/data/source/authentication_source.dart';
import 'package:aviz_project/networks/api_exeption.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

@immutable
sealed class AuthenticationRepository {
  Future<Either<String, String>> login(
    String email,
    String password,
  );
  Future<Either<String, String>> register(
    String username,
    String email,
    String password,
    String passwordConfirm,
  );
  Future<Either<String, String>> verifyCode(String code);
}

class IAuthRepository extends AuthenticationRepository {
  final AuthenticationSource _authenticationSource;
  IAuthRepository(this._authenticationSource);

  @override
  Future<Either<String, String>> login(String email, String password) async {
    try {
      bool logedIn = await _authenticationSource.login(email, password);
      if (logedIn) {
        return right('شما وارد شده اید');
      } else {
        return left('خطایی در هنگام ورود رخ داده است');
      }
    } on ApiExeption catch (ex) {
      return left(ex.errorMessage);
    }
  }

  @override
  Future<Either<String, String>> register(
    String username,
    String email,
    String password,
    String passwordConfirm,
  ) async {
    try {
      bool isRegistered = await _authenticationSource.register(
        username,
        email,
        password,
        passwordConfirm,
      );
      if (isRegistered) {
        return right('کد با موفقیت ارسال شد');
      } else {
        return left('خطایی رخ داده است');
      }
    } on ApiExeption catch (ex) {
      return left(ex.errorMessage);
    }
  }
  
  @override
  Future<Either<String, String>> verifyCode(String code) async {
    try {
      bool isVerifyed = await _authenticationSource.verifyCode(code);
      if (isVerifyed) {
        return right('با موفقیت ثبت نام شدید');
      } else {
        return left('خطایی رخ داده است');
      }
    } on ApiExeption catch (ex) {
      return left(ex.errorMessage);
    }
  }
}
