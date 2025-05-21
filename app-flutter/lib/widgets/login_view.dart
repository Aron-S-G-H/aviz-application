import 'package:aviz_project/features/Authentication/pages/login_screen.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:flutter/material.dart';

Widget loginView(BuildContext context, String text) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 30.0),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(
              color: ColorSetting.customRed,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
            minimumSize: const Size(180.0, 50.0),
            backgroundColor: ColorSetting.customRed,
          ),
          child: Text(
            'ورود به حساب کاربری',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    ),
  );
}
