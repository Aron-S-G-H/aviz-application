import 'package:aviz_project/Utils/int_extention.dart';
import 'package:aviz_project/components/detail_screen_components.dart';
import 'package:aviz_project/features/Aviz/bloc/aviz_bloc.dart';
import 'package:aviz_project/features/Aviz/data/model/aviz.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:aviz_project/widgets/cached_network_image.dart';
import 'package:aviz_project/components/custom_button.dart';
import 'package:aviz_project/widgets/error_handler.dart';
import 'package:aviz_project/widgets/loading_animation.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

part 'specifications_screen.dart';
part 'features_screen.dart';

class AvizDetailScreen extends StatelessWidget {
  final Aviz aviz;
  const AvizDetailScreen(this.aviz, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var bloc = AvizBloc();
        bloc.add(AvizInitialEvent(aviz.id));
        return bloc;
      },
      child: AvizDetailScreenView(aviz),
    );
  }
}

class AvizDetailScreenView extends StatefulWidget {
  final Aviz aviz;
  const AvizDetailScreenView(this.aviz, {super.key});

  @override
  State<AvizDetailScreenView> createState() => _AvizDetailScreenViewState();
}

class _AvizDetailScreenViewState extends State<AvizDetailScreenView> {
  final PageController sliderController = PageController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    sliderController.dispose();
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/information_icon.png'),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/share_icon.png'),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/save_icon.png'),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset(
            'assets/images/grey_arrow_left_icon.png',
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<AvizBloc, AvizState>(
          builder: (context, state) {
            if (state is AvizLoadingState) {
              return loadingAnimation();
            } else if (state is AvizResponseState) {
              return RefreshIndicator(
                backgroundColor: ColorSetting.customGrey,
                color: ColorSetting.customRed,
                onRefresh: () async {
                  context
                      .read<AvizBloc>()
                      .add(AvizInitialEvent(widget.aviz.id));
                },
                child: state.aviz.fold(
                  (errorMessage) => showErrorMessage(),
                  (aviz) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: [
                            Expanded(
                              child: CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 32.0,
                                    ),
                                    sliver: SliverToBoxAdapter(
                                      child: _bannerSlider(
                                        aviz.images,
                                        sliderController,
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: _headerSection(aviz.createdAt!),
                                  ),
                                  SliverPadding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    sliver: SliverToBoxAdapter(
                                      child: Text(
                                        aviz.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: _alarmBox(),
                                  ),
                                  SliverPadding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 32.0,
                                    ),
                                    sliver: SliverToBoxAdapter(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildNavButton('مشخصات', 0),
                                          _buildNavButton('قیمت', 1),
                                          _buildNavButton('ویژگی و امکانات', 2),
                                          _buildNavButton('توضیحات', 3),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: navScrennSection(
                                      aviz,
                                      _selectedIndex,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const ButtonContainer(),
                          ],
                        ),
                      ),
                    );
                  },
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

  Widget _buildNavButton(String title, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: isSelected ? ColorSetting.customRed : Colors.transparent,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: isSelected ? Colors.white : ColorSetting.customRed),
        ),
      ),
    );
  }

  Widget _bannerSlider(List<String> avizPosters, PageController controller) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 180.0,
          child: PageView.builder(
            controller: controller,
            itemCount: avizPosters.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: cachedNetworkImage(avizPosters[index], 4.0),
              );
            },
          ),
        ),
        Positioned(
          bottom: 3.0,
          child: SmoothPageIndicator(
            controller: controller,
            count: avizPosters.length,
            effect: const ExpandingDotsEffect(
              expansionFactor: 4,
              dotHeight: 8.0,
              dotWidth: 8.0,
              dotColor: Colors.white,
              activeDotColor: ColorSetting.customRed,
            ),
          ),
        )
      ],
    );
  }

  Widget _headerSection(String createdAt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 30.0,
          width: 60.0,
          decoration: BoxDecoration(
            color: ColorSetting.customGrey,
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          child: Center(
            child: Text(
              'آپارتمان',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: ColorSetting.customRed),
            ),
          ),
        ),
        Text(
          createdAt,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: ColorSetting.textGray),
        ),
      ],
    );
  }

  Widget _alarmBox() {
    return Container(
      height: 40.0,
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorSetting.lightGrey,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'هشدارهای قبل از معامله !',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Icon(
            Icons.keyboard_arrow_left,
            color: ColorSetting.lightGrey,
          )
        ],
      ),
    );
  }

  Widget navScrennSection(Aviz aviz, int selectedIndex) {
    List<Widget> pages = [
      SpecificationsScreen(
        aviz.totalArea!,
        aviz.rooms!,
        aviz.floor!,
        aviz.yearOfConstruction!,
      ),
      customBox(
        context,
        [
          {
            'title': 'قیمت هر متر :',
            'value': aviz.pricePerMeter!.priceFormat()
          },
          {'title': 'قیمت کل :', 'value': aviz.price.priceFormat()},
        ],
      ),
      FeaturesScreen(aviz.facilities ?? []),
      Text(
        aviz.description,
        style: TextStyle(
          fontFamily: 'ShabnamBold',
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: ColorSetting.textGray,
          height: 2.0,
        ),
      ),
    ];
    return pages[selectedIndex];
  }
}

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomElevatedButton(
            title: 'گفت و گو',
            onActionTap: () {},
            icon: Image.asset('assets/images/call_icon.png'),
          ),
          CustomElevatedButton(
            title: 'اطلاعات تماس',
            onActionTap: () {},
            icon: Image.asset('assets/images/call_icon.png'),
          ),
        ],
      ),
    );
  }
}
