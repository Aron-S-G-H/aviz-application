import 'package:aviz_project/features/Authentication/bloc/auth_bloc.dart';
import 'package:aviz_project/features/Authentication/pages/code_confirm_screen.dart';
import 'package:aviz_project/features/Authentication/pages/login_screen.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:aviz_project/widgets/error_handler.dart';
import 'package:aviz_project/widgets/loading_animation.dart';
import 'package:aviz_project/widgets/logo_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const RegisterScreenView(),
    );
  }
}

class RegisterScreenView extends StatefulWidget {
  const RegisterScreenView({super.key});

  @override
  State<RegisterScreenView> createState() => _RegisterScreenViewState();
}

class _RegisterScreenViewState extends State<RegisterScreenView> {
  final List<TextEditingController> _controlers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var controller in _controlers) {
      controller.dispose();
    }
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
                            'خوش اومدی به',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          logoContainer(),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'این فوق العادست که آویزو برای آگهی هات انتخاب کردی !',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 32.0),
                      TextField(
                        controller: _controlers[0],
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorSetting.customGrey,
                          border: InputBorder.none,
                          hintText: 'نام نام خانوادگی',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: ColorSetting.textGray),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextField(
                        controller: _controlers[1],
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
                        controller: _controlers[2],
                        autocorrect: false,
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
                      const SizedBox(height: 24.0),
                      TextField(
                        controller: _controlers[3],
                        autocorrect: false,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorSetting.customGrey,
                          border: InputBorder.none,
                          hintText: 'تائید رمز عبور',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: ColorSetting.textGray),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (_controlers.every(
                            (controler) => controler.text.isNotEmpty,
                          )) {
                            context.read<AuthBloc>().add(
                                AuthRegisterRequestEvent(
                                    _controlers[0].text,
                                    _controlers[1].text,
                                    _controlers[2].text,
                                    _controlers[3].text));
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
                            'قبلا ثبت نام کردی ؟',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              ' ورود',
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
          listener: (context, state) {
            if (state is AuthResponseState) {
              if (state.response.isRight()) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const CodeConfirmScreen(),
                  ),
                );
              } else {
                context.read<AuthBloc>().add(AuthInitEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  showSnackBar(
                    context,
                    state.response.fold(
                      (l) => l,
                      (r) => 'خطایی در ثبت نام به وجود آمده',
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
