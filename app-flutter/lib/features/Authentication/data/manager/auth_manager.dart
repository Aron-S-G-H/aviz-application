import 'package:aviz_project/features/Authentication/data/model/user_info.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthManager {
  static final box = Hive.box('auth');
  static ValueNotifier<bool> isUserLogedInNotifier = ValueNotifier<bool>(isUserLogedIn());

  static Future<void> saveTokens(
    String accessToken,
    String refreshToken,
  ) async {
    await box.put('accessToken', accessToken);
    await box.put('refreshToken', refreshToken);
    isUserLogedInNotifier.value = true;
  }

  static Future<void> saveUserId(int userId) async {
    await box.put('userId', userId);
  }

  static String getAccessToken() => box.get('accessToken', defaultValue: '');

  static int getUserId() => box.get('userId', defaultValue: 0);

  static String getRefreshToken() => box.get('refreshToken', defaultValue: '');

  static bool isUserLogedIn() {
    return box.get('accessToken') != null;
  }

  static void logout() async {
    await box.clear();
    isUserLogedInNotifier.value = false;
  }

  static Future<bool> refreshToken() async {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: Settings.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );
    final String refreshToken = getRefreshToken();
    if (refreshToken.isNotEmpty) {
      try {
        final Response response = await dio.post(
          'account/auth/token/refresh/',
          data: {'refresh': refreshToken},
        );
        if (response.statusCode == 200) {
          String accessToken = response.data['access'];
          box.put('accessToken', accessToken);
          isUserLogedInNotifier.value = true;
          print('truuuueee');
          return true;
        }
      } on DioException catch (e) {
        print(e.response!.data);
        return false;
      }
    }
    return false;
  }

  static Future<void> saveUserInfo(
    String username,
    String email,
    String password,
    String passwordConfirm,
  ) async {
    UserInfo userInfo = UserInfo(
      username: username,
      email: email,
      password: password,
      confirmPassword: passwordConfirm,
    );
    await box.put('userInfo', userInfo);
  }

  static void clearUserInfo() async {
    await box.delete('userInfo');
  }

  static UserInfo getUserInfo() {
    return box.get('userInfo');
  }

  static bool isUserInfoExist() {
    return box.get('userInfo') != null;
  }
}
