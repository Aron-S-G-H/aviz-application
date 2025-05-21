import 'package:aviz_project/features/Authentication/bloc/auth_bloc.dart';
import 'package:aviz_project/features/Authentication/pages/register_screen.dart';
import 'package:aviz_project/features/Dashboard/pages/dashboard_screen.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:aviz_project/widgets/error_handler.dart';
import 'package:aviz_project/widgets/loading_animation.dart';
import 'package:aviz_project/widgets/logo_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const LoginScreenView(),
    );
  }
}

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthResponseState) {
              if (state.response.isRight()) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                  (route) => false,
                );
              } else {
                context.read<AuthBloc>().add(AuthInitEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  showSnackBar(
                    context,
                    state.response.fold(
                      (l) => l,
                      (r) => 'خطایی در ارتباط با سرور به وجود آمده',
                    ),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            if (state is AuthInitState) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 16.0,
                    left: 16.0,
                    top: 20.0,
                    bottom: 30.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'ورود به آویز',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          logoContainer(),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'خوشحالیم که مجددا آویز رو برای آگهی انتخاب کردی!',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 32.0),
                      TextField(
                        controller: _emailController,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorSetting.customGrey,
                          border: InputBorder.none,
                          hintText: 'آدرس ایمیل',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: ColorSetting.textGray),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextField(
                        controller: _passwordController,
                        autocorrect: false,
                        enableSuggestions: false,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorSetting.customGrey,
                          border: InputBorder.none,
                          hintText: 'رمز عبور',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: ColorSetting.textGray),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            context.read<AuthBloc>().add(AuthLoginRequestEvent(
                                _emailController.text,
                                _passwordController.text));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              showSnackBar(
                                context,
                                'لطفاً تمامی فیلد ها را پر کنید',
                              ),
                            );
                          }
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
                          minimumSize: const Size(double.infinity, 50.0),
                          backgroundColor: ColorSetting.customRed,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'مرحله بعد',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.white),
                            ),
                            const Icon(Icons.arrow_right, color: Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تا حالا ثبت نام نکردی ؟',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              ' ثبت نام',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: ColorSetting.customRed,
                                    fontSize: 15.0,
                                  ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else if (state is AuthLoadingState) {
              return loadingAnimation();
            } else {
              return showErrorMessage();
            }
          },
        ),
      ),
    );
  }
}
