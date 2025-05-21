import 'package:aviz_project/settings/settings.dart';
import 'package:flutter/material.dart';

Widget loadingAnimation() {
  return const Center(
    child: SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        color: ColorSetting.customRed,
      ),
    ),
  );
}
