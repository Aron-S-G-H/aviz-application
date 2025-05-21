import 'package:hive/hive.dart';

part 'user_info.g.dart';

@HiveType(typeId: 1)
class UserInfo {
  @HiveField(0)
  final String username;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String password;
  @HiveField(3)
  final String confirmPassword;

  UserInfo({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}