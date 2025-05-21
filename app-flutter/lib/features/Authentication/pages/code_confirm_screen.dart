import 'dart:async';
import 'package:aviz_project/features/Authentication/bloc/auth_bloc.dart';
import 'package:aviz_project/features/Dashboard/pages/dashboard_screen.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:aviz_project/widgets/error_handler.dart';
import 'package:aviz_project/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeConfirmScreen extends StatelessWidget {
  const CodeConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const CodeConfirmScreenView(),
    );
  }
}

class CodeConfirmScreenView extends StatefulWidget {
  const CodeConfirmScreenView({super.key});

  @override
  State<CodeConfirmScreenView> createState() => _CodeConfirmScreenState();
}

class _CodeConfirmScreenState extends State<CodeConfirmScreenView> {
  final List<TextEditingController> _controlers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  int _remainingTime = 60;
  bool _isResendEnabled = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (var controller in _controlers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _onTextChange(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_remainingTime > 0) {
            --_remainingTime;
          } else {
            _isResendEnabled = true;
            _timer.cancel();
          }
        });
      },
    );
  }

  void _resendCode() {
    setState(() {
      _remainingTime = 60;
      _isResendEnabled = false;
      _startTimer();
    });
  }

  // تابع کمکی برای تبدیل زمان به فرمت 00:00
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60; // محاسبه دقیقه
    int remainingSeconds = seconds % 60; // محاسبه ثانیه
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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
              return Padding(
                padding: const EdgeInsets.only(
                  right: 16.0,
                  left: 16.0,
                  top: 20.0,
                  bottom: 30.0,
                ),
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تائید آدرس ایمیل',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'کد ورود ایمیل شده را وارد کنید',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 32.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) {
                          return SizedBox(
                            width: 73.0,
                            height: 50.0,
                            child: TextField(
                              controller: _controlers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: ColorSetting.lightGrey,
                                border: InputBorder.none,
                              ),
                              onChanged: (value) => _onTextChange(index, value),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_isResendEnabled) {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthResendCodeEvent());
                              _resendCode();
                            }
                          },
                          child: Text(
                            'ارسال مجدد کد',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: _isResendEnabled
                                        ? Colors.black
                                        : ColorSetting.lightGrey),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          _formatTime(_remainingTime),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: 18.0,
                                  color: _isResendEnabled
                                      ? ColorSetting.lightGrey
                                      : Colors.black),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (_controlers.every(
                          (controler) => controler.text.isNotEmpty,
                        )) {
                          String code = _controlers
                              .map((controller) => controller.text)
                              .join();
                          context
                              .read<AuthBloc>()
                              .add(AuthVerifyCodeRequestEvent(code));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            showSnackBar(
                              context,
                              'لطفا تمامی فیلدها را پر کنید',
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
                      child: Text(
                        'تائيد ورود',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is AuthLoadingState) {
              return loadingAnimation();
            } else {
              return showErrorMessage();
            }
          },
          listener: (context, state) {
            if (state is AuthResentCodeReponseState) {
              if (state.response.isRight()) {
                for (var controler in _controlers) {
                  controler.clear();
                }
                context.read<AuthBloc>().add(AuthInitEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  showSnackBar(
                    context,
                    state.response.fold(
                      (l) => l,
                      (r) => r,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  showSnackBar(
                    context,
                    state.response.fold(
                      (l) => l,
                      (r) => 'خطایی در ارسال کد به وجود آمده',
                    ),
                  ),
                );
              }
            }
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
