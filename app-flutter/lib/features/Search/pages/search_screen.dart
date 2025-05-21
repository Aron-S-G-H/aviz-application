import 'package:aviz_project/components/horizontal_cart.dart';
import 'package:aviz_project/features/Search/bloc/search_bloc.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:aviz_project/widgets/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: const SearchScreenView(),
    );
  }
}

class SearchScreenView extends StatefulWidget {
  const SearchScreenView({super.key});

  @override
  State<SearchScreenView> createState() => _SearchScreenViewState();
}

class _SearchScreenViewState extends State<SearchScreenView> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Row(
          spacing: 2.0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_type.png'),
            Text(
              'جست و جوی',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: ColorSetting.customRed),
            ),
            Image.asset('assets/images/active_search_icon.png'),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      sliver: SliverToBoxAdapter(
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
                                .copyWith(color: ColorSetting.darkGrey),
                            prefixIcon: const Icon(Icons.search),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(color: ColorSetting.customRed),
                            ),
                          ),
                          onChanged: (value) {
                            context
                                .read<SearchBloc>()
                                .add(SearchWithQueryEvent(value));
                          },
                        ),
                      ),
                    ),
                    if (state is SearchRequestSuccessState) ...{
                      state.searchResult.fold(
                        (l) {
                          return SliverFillRemaining(
                            child: showErrorMessage(),
                          );
                        },
                        (r) {
                          if (r.isEmpty) {
                            return SliverFillRemaining(
                              child: _showSearchImage(),
                            );
                          }
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => HorizontalCart(r[index]),
                              childCount: r.length,
                            ),
                          );
                        },
                      )
                    } else ...[
                      SliverFillRemaining(
                        child: _showSearchImage(),
                      ),
                    ]
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _showSearchImage() {
    return Center(
      child: Image.asset(
        'assets/images/search_back.jpg',
        fit: BoxFit.cover,
        height: 350.0,
      ),
    );
  }
}
