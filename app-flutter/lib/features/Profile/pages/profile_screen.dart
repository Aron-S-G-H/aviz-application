import 'package:aviz_project/components/detail_screen_components.dart';
import 'package:aviz_project/features/Authentication/data/manager/auth_manager.dart';
import 'package:aviz_project/features/Profile/bloc/profile_bloc.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:aviz_project/widgets/error_handler.dart';
import 'package:aviz_project/widgets/loading_animation.dart';
import 'package:aviz_project/widgets/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Container(
          height: 42.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Row(
            spacing: 2.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'آویز من',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: ColorSetting.customRed),
              ),
              Image.asset('assets/images/active_home_icon.png'),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: AuthManager.isUserLogedInNotifier,
          builder: (context, isLoggedIn, child) {
            if (!isLoggedIn) {
              return loginView(
                context,
                'برای مشاهده صفحه پروفایل باید وارد حساب کاربری خود شوید',
              );
            }
            return BlocProvider(
              create: (context) {
                var bloc = ProfileBloc();
                bloc.add(ProfileInitialEvent());
                return bloc;
              },
              child: const ProfileScreenView(),
            );
          },
        ),
      ),
    );
  }
}

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({super.key});

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadingState) {
          return loadingAnimation();
        } else if (state is ProfileResponseState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<ProfileBloc>().add(ProfileInitialEvent());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: state.response.fold(
                    (errorMessage) {
                      return showErrorMessage();
                    },
                    (profile) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: TextField(
                              controller: controller,
                              textInputAction: TextInputAction.search,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: ColorSetting.darkGrey),
                              decoration: InputDecoration(
                                hintText: 'جستجو کنید...',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: ColorSetting.textGray),
                                prefixIcon: Image.asset(
                                  'assets/images/inactive_search_icon.png',
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  borderSide:
                                      BorderSide(color: ColorSetting.textGray),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide:
                                      BorderSide(color: ColorSetting.customRed),
                                ),
                              ),
                              onSubmitted: (value) {},
                            ),
                          ),
                          detailScreenCustomHeader(
                            context,
                            'حساب کاربری',
                            Image.asset('assets/images/profile-active.png'),
                          ),
                          Container(
                            height: 95.0,
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.only(
                              top: 24.0,
                              bottom: 60.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorSetting.lightGrey),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Image.asset(
                                    'assets/images/profile_image.jpg',
                                    width: 64.0,
                                    height: 64.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.username,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Text(
                                      profile.email,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    'assets/images/edit_profile_icon.png',
                                    height: 24.0,
                                    width: 24.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                          buttonsSection(context),
                          const SizedBox(height: 16.0),
                          Text(
                            'نسخه',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '1.5.9',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        } else {
          return showErrorMessage();
        }
      },
    );
  }

  final List<Map<String, String>> titleNames = [
    {'title': 'آگهی های من', 'icon': 'my_aviz_icon.png'},
    {'title': 'پرداخت های من', 'icon': 'card_icon.png'},
    {'title': 'بازدید های اخیر', 'icon': 'view_icon.png'},
    {'title': 'ذخیره شده ها', 'icon': 'save_2_icon.png'},
    {'title': 'تنظیمات', 'icon': 'setting_2_icon.png'},
    {'title': 'پشتیبانی و قوانین', 'icon': 'support_icon.png'},
    {'title': 'درباره آویز', 'icon': 'aviz_info_icon.png'},
  ];

  Widget buttonsSection(BuildContext context) {
    return SizedBox(
      height: 377.0,
      child: ListView.separated(
        itemCount: titleNames.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: ColorSetting.lightGrey),
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            ),
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 5.0,
                  children: [
                    Image.asset(
                      'assets/images/${titleNames[index]['icon']}',
                      width: 24.0,
                      height: 24.0,
                    ),
                    Text(
                      titleNames[index]['title']!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Icon(
                  Icons.keyboard_arrow_left,
                  color: ColorSetting.textGray,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
