import 'package:aviz_project/components/category_button.dart';
import 'package:aviz_project/features/Add/bloc/add_bloc.dart';
import 'package:aviz_project/features/Add/pages/specs_screen.dart';
import 'package:aviz_project/features/Authentication/data/manager/auth_manager.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:aviz_project/widgets/error_handler.dart';
import 'package:aviz_project/widgets/loading_animation.dart';
import 'package:aviz_project/widgets/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Container(
          height: 42.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset('assets/images/logo_type.png'),
                  Text(
                    'انتخاب دسته بندی',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: ColorSetting.customRed),
                  ),
                ],
              ),
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
                'برای مشاهده دسته بندی ها باید وارد حساب کاربری خود شوید',
              );
            }
            return BlocProvider(
              create: (context) {
                var bloc = AddBloc();
                bloc.add(CategoryInitialEvent());
                return bloc;
              },
              child: const CategoryScreenView(),
            );
          },
        ),
      ),
    );
  }
}

class CategoryScreenView extends StatelessWidget {
  const CategoryScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBloc, AddState>(
      builder: (context, state) {
        if (state is CategoryLoadingState) {
          return loadingAnimation();
        } else if (state is CategoryResponseState) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<AddBloc>().add(CategoryInitialEvent());
            },
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 4.0,
                    color: ColorSetting.customRed,
                  ),
                ),
                Expanded(
                  child: state.response.fold(
                    (errorMessage) {
                      return showErrorMessage();
                    },
                    (categories) {
                      return CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.only(
                              top: 32.0,
                              right: 16.0,
                              left: 16.0,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                childCount: categories.length,
                                (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    duration: const Duration(seconds: 1),
                                    position: index,
                                    child: SlideAnimation(
                                      horizontalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              useSafeArea: true,
                                              backgroundColor:
                                                  ColorSetting.customGrey,
                                              isDismissible: true,
                                              isScrollControlled: true,
                                              showDragHandle: true,
                                              builder: (context) {
                                                return FractionallySizedBox(
                                                  heightFactor: 0.7,
                                                  child: BlocProvider(
                                                    create: (context) {
                                                      var bloc = AddBloc();
                                                      bloc.add(
                                                        GetSubCategoriesEvent(
                                                            categories[index]
                                                                .id),
                                                      );
                                                      return bloc;
                                                    },
                                                    child: SubCategorySheet(
                                                        categories[index]
                                                            .title),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: CategoryButton(
                                            categories[index],
                                            16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          );
        } else {
          return showErrorMessage();
        }
      },
    );
  }
}

class SubCategorySheet extends StatelessWidget {
  final String title;
  const SubCategorySheet(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBloc, AddState>(
      builder: (context, state) {
        if (state is CategoryLoadingState) {
          return loadingAnimation();
        } else if (state is SubCategoryResponseState) {
          return state.response.fold(
            (errorMessage) {
              return showErrorMessage();
            },
            (subCategories) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 32.0,
                      right: 16.0,
                      left: 16.0,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: subCategories.length,
                        (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) {
                                      var bloc = AddBloc();
                                      bloc.add(GetFacilitiesEvent());
                                      return bloc;
                                    },
                                    child: SpecsScreen(
                                      subCategories,
                                      subCategories[index].id,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: CategoryButton(
                              subCategories[index],
                              16.0,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
            },
          );
        } else {
          return showErrorMessage();
        }
      },
    );
  }
}
