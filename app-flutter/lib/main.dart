import 'package:aviz_project/DI/di.dart';
import 'package:aviz_project/features/Authentication/data/manager/auth_manager.dart';
import 'package:aviz_project/features/Authentication/data/model/user_info.dart';
import 'package:aviz_project/features/Authentication/pages/wellcome_screen.dart';
import 'package:aviz_project/features/Dashboard/pages/dashboard_screen.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(UserInfoAdapter());
    await Hive.openBox('auth');
    await getItInit();
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error initializing Hive: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'ShabnamBold',
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Dana',
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Dana',
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: ColorSetting.darkGrey,
          ),
          labelSmall: TextStyle(
              fontFamily: 'ShabnamBold',
              fontSize: 12.0,
              fontWeight: FontWeight.w500),
          bodySmall: TextStyle(
            fontFamily: 'ShabnamBold',
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Color(0xffD0D5DD),
          ),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: AuthManager.isUserLogedIn()
          ? const DashboardScreen()
          : const WellcomeScreen(),
    );
  }
}
