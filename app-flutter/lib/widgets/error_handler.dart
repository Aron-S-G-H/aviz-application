import 'package:aviz_project/settings/settings.dart';
import 'package:flutter/material.dart';

Widget showErrorMessage() {
  return const Center(
    child: Text(
      '! خطایی در دریافت اطلاعات به وجود آمده',
      style: TextStyle(fontFamily: 'SB'),
    ),
  );
}

SnackBar showSnackBar(BuildContext context, String text) {
  return SnackBar(
    content: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'ShabnamBold',
        fontSize: 14.0,
        color: Colors.white,
      ),
    ),
    backgroundColor: ColorSetting.customRed,
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 3),
    dismissDirection: DismissDirection.down,
    margin: EdgeInsets.only(
      left: 16.0,
      right: 16.0,
      bottom: MediaQuery.of(context).size.height - 140.0,
    ),
  );
}
