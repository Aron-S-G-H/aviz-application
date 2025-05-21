import 'package:aviz_project/settings/settings.dart';
import 'package:flutter/material.dart';

Widget logoContainer() {
  return Container(
    height: 26.0,
    width: 65.0,
    decoration: BoxDecoration(
      color: ColorSetting.customGrey,
      image: const DecorationImage(
        image: AssetImage(
          'assets/images/logo_with_not_background.png',
        ),
        fit: BoxFit.cover,
      ),
    ),
  );
}
