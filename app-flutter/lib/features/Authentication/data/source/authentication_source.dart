import 'package:aviz_project/features/Authentication/data/manager/auth_manager.dart';
import 'package:aviz_project/networks/api_exeption.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

@immutable
sealed class AuthenticationSource {
  Future<bool> login(
    String email,
    String password,
  );
  Future<bool> register(
    String username,
    String email,
    String password,
    String passwordConfirm,
  );
  Future<bool> verifyCode(String code);
}

class IAuthSource extends AuthenticationSource {
  final Dio _dio;
  IAuthSource(this._dio);

  @override
  Future<bool> login(String email, String password) async {
    try {
      final Response response = await _dio.post(
        'account/auth/login/',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        AuthManager.saveTokens(response.data['access'], response.data['refresh']);
        AuthManager.saveUserId(response.data['user']['id']);
        return true;
      }
    } on DioException catch (ex) {
      throw ApiExeption(
        ex.response!.data['success'],
        ex.response!.data['error']['message'],
        ex.response!.data['error']['status'],
      );
    } catch (ex) {
      throw ApiExeption(
        false,
        ex.toString(),
        500,
      );
    }
    return false;
  }

  @override
  Future<bool> register(
    String username,
    String email,
    String password,
    String passwordConfirm,
  ) async {
    try {
      final Response response = await _dio.post(
        'account/auth/register/',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'confirm_password': passwordConfirm,
        },
      );
      if (response.statusCode == 200 && response.data['success']) {
        if (!AuthManager.isUserInfoExist()) {
          await AuthManager.saveUserInfo(username, email, password, passwordConfirm);
        }
        return true;
      }
    } on DioException catch (ex) {
      throw ApiExeption(
        ex.response!.data['success'],
        ex.response!.data['error']['message'],
        ex.response!.data['error']['status'],
      );
    } catch (ex) {
      throw ApiExeption(
        false,
        ex.toString(),
        500,
      );
    }
    return false;
  }

  @override
  Future<bool> verifyCode(String code) async {
    try {
      final Response response = await _dio.post(
        'account/auth/verify-register/',
        data: {'code': code},
      );
      if (response.statusCode == 200) {
        AuthManager.saveTokens(response.data['access'], response.data['refresh']);
        AuthManager.saveUserId(response.data['user']['id']);
        AuthManager.clearUserInfo();
        return true;
      }
    } on DioException catch (ex) {
      throw ApiExeption(
        ex.response!.data['success'],
        ex.response!.data['error']['message'],
        ex.response!.data['error']['status'],
      );
    } catch (ex) {
      throw ApiExeption(
        false,
        ex.toString(),
        500,
      );
    }
    return false;
  }
}
