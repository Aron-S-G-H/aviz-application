import 'package:aviz_project/components/horizontal_cart.dart';
import 'package:aviz_project/components/vertical_cart.dart';
import 'package:aviz_project/features/Home/bloc/home_bloc.dart';
import 'package:aviz_project/features/Home/pages/list_screen.dart';
import 'package:aviz_project/widgets/error_handler.dart';
import 'package:aviz_project/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var bloc = HomeBloc();
        bloc.add(HomeInitialEvent());
        return bloc;
      },
      child: const HomeScreenView(),
    );
  }
}

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Image.asset('assets/images/logo_with_not_background.png'),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return loadingAnimation();
            } else if (state is HomeResponseState) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(HomeInitialEvent());
                },
                child: CustomScrollView(
                  slivers: [
                    state.hotAvizs.fold(
                      (errorMessage) => _showErrorMessage(),
                      (avizHotList) {
                        return SliverPadding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                            left: 16.0,
                            right: 16.0,
                            top: 24.0,
                          ),
                          sliver: _buildSectionHeader(
                            context,
                            'آویزهای داغ',
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ListScreen(
                                  avizHotList,
                                  'لیست آویزهای داغ',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    state.hotAvizs.fold(
                      (errorMessage) => _showErrorMessage(),
                      (avizHotList) {
                        return SliverToBoxAdapter(
                          child: SizedBox(
                            height: 300.0,
                            child: ListView.builder(
                              reverse: true,
                              itemCount: avizHotList.length > 4
                                  ? 4
                                  : avizHotList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return VerticalCart(avizHotList[index]);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    state.recentAvizs.fold(
                      (errorMessage) => _showErrorMessage(),
                      (recentAvizsList) {
                        return SliverPadding(
                          padding: const EdgeInsets.only(
                            bottom: 24.0,
                            left: 16.0,
                            right: 16.0,
                            top: 24.0,
                          ),
                          sliver: _buildSectionHeader(
                            context,
                            'آویزهای اخیر',
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ListScreen(
                                  recentAvizsList,
                                  'لیست آویزهای اخیر',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    state.recentAvizs.fold(
                      (errorMessage) => _showErrorMessage(),
                      (recentAvizsList) {
                        return SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: recentAvizsList.length > 4
                                  ? 4
                                  : recentAvizsList.length,
                              (context, index) => HorizontalCart(
                                recentAvizsList[index],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            } else {
              return showErrorMessage();
            }
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onActionTap,
  ) {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              'مشاهده همه',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _showErrorMessage() {
    return SliverToBoxAdapter(
      child: showErrorMessage(),
    );
  }
}
