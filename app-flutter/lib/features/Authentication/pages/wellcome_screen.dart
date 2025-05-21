import 'package:aviz_project/features/Authentication/pages/login_screen.dart';
import 'package:aviz_project/features/Authentication/pages/register_screen.dart';
import 'package:aviz_project/features/Dashboard/pages/dashboard_screen.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:aviz_project/widgets/logo_container.dart';
import 'package:flutter/material.dart';

class WellcomeScreen extends StatelessWidget {
  const WellcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 150.0, bottom: 30.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/background_pattern_image.png',
                  ),
                  Center(
                    child: Image.asset('assets/images/welcome_image.png'),
                  )
                ],
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'آگهی شماست',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(width: 5.0),
                  logoContainer(),
                  const SizedBox(width: 5.0),
                  Text(
                    'اینجا محل',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(
                  right: 35.0,
                  left: 35.0,
                  top: 16.0,
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  'در آویز ملک خود را برای فروش،اجاره و رهن آگهی کنید و یا اگر دنبال ملک با مشخصات دلخواه خود هستید آویز ها را ببینید',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: ColorSetting.customRed),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ),
                            minimumSize: const Size(180.0, 50.0),
                          ),
                          child: Text(
                            'ورود',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: ColorSetting.customRed),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterScreen(),
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
                            'ثبت نام',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const DashboardScreen(),
                          ),
                        );
                      },
                      child: Text(
                        '! بعداً وارد حساب کاربری میشم',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
