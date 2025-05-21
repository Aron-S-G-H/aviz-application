import 'package:aviz_project/components/custom_button.dart';
import 'package:aviz_project/components/detail_screen_components.dart';
import 'package:aviz_project/features/Add/bloc/add_bloc.dart';
import 'package:aviz_project/features/Add/data/model/facility.dart';
import 'package:aviz_project/features/Add/data/model/sub_category.dart';
import 'package:aviz_project/features/Add/pages/location_screen.dart';
import 'package:aviz_project/features/Dashboard/pages/dashboard_screen.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:aviz_project/widgets/error_handler.dart';
import 'package:aviz_project/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecsScreen extends StatelessWidget {
  final List<SubCategory> subCategories;
  final int selectedItem;
  const SpecsScreen(this.subCategories, this.selectedItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBloc, AddState>(
      builder: (context, state) {
        if (state is CategoryInitialState) {
          return loadingAnimation();
        } else if (state is FacilitiesResponseState) {
          return state.response.fold(
            (error) {
              return showErrorMessage();
            },
            (facilities) {
              return SpecsScreenView(
                subCategories: subCategories,
                selectedItem: selectedItem,
                facilities: facilities,
              );
            },
          );
        }
        return showErrorMessage();
      },
    );
  }
}

class SpecsScreenView extends StatefulWidget {
  final List<SubCategory> subCategories;
  final int selectedItem;
  final List<Facility> facilities;
  const SpecsScreenView({
    required this.subCategories,
    required this.selectedItem,
    required this.facilities,
    super.key,
  });

  @override
  State<SpecsScreenView> createState() => _SpecsScreenViewState();
}

class _SpecsScreenViewState extends State<SpecsScreenView> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController totalAreaController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController yeaController = TextEditingController();
  late int selectedItem;
  late List<Map<String, bool>> facilities;
  late Map<String, dynamic> avizInfo;

  @override
  void dispose() {
    addressController.dispose();
    totalAreaController.dispose();
    roomsController.dispose();
    floorController.dispose();
    yeaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    selectedItem = widget.selectedItem;
    facilities = [
      for (var item in widget.facilities)
        {
          item.title: false,
        }
    ];
    super.initState();
  }

  void increment(TextEditingController controller) {
    int currentValue = int.tryParse(controller.text) ?? 0;
    controller.text = (currentValue + 1).toString();
  }

  void decrement(TextEditingController controller) {
    int currentValue = int.tryParse(controller.text) ?? 0;
    if (currentValue > 0) {
      controller.text = (currentValue - 1).toString();
    }
  }

  void setAvizInfo() {
    String selectedFacilities = facilities
        .where((facility) => facility.values.first) // فقط آیتم‌هایی که value آن‌ها true است
        .map((facility) => facility.keys.first) // استخراج key
        .join(',');
    avizInfo = {
      "categoryId": selectedItem,
      "address": addressController.text,
      "totalArea": totalAreaController.text,
      "rooms": roomsController.text,
      "floor": floorController.text,
      "yearOfConstruction": yeaController.text,
      "facilities": selectedFacilities,
    };
  }

  bool validateInputs() {
    return addressController.text.isNotEmpty &&
        totalAreaController.text.isNotEmpty &&
        roomsController.text.isNotEmpty &&
        floorController.text.isNotEmpty &&
        yeaController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Row(
          spacing: 2.0,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(
                Icons.highlight_off_outlined,
                size: 26.0,
              ),
            ),
            Row(
              children: [
                Row(
                  spacing: 2.0,
                  children: [
                    Image.asset('assets/images/logo_type.png'),
                    Text(
                      'ثبت',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: ColorSetting.customRed),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.keyboard_arrow_right_sharp,
                size: 26.0,
              ),
            )
          ],
        ),
      ),
      body: SafeArea(child: BlocBuilder<AddBloc, AddState>(
        builder: (context, state) {
          if (state is CategoryLoadingState) {
            return loadingAnimation();
          } else if (state is FacilitiesResponseState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      height: 4.0,
                      color: ColorSetting.customRed,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            sliver: SliverToBoxAdapter(
                              child: detailScreenCustomHeader(
                                context,
                                'انتخاب دسته بندی آویز',
                                Image.asset('assets/images/category_icon.png'),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 180.0,
                                  height: 50.0,
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorSetting.lightGrey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    elevation: 0,
                                    value: selectedItem,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: widget.subCategories
                                        .map(
                                          (item) => DropdownMenuItem(
                                            value: item.id,
                                            child: Text(
                                              item.title,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedItem = value!;
                                      });
                                    },
                                    underline: const SizedBox(),
                                  ),
                                ),
                                Container(
                                  width: 180.0,
                                  height: 50.0,
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorSetting.lightGrey,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: TextField(
                                    controller: addressController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    enabled: true,
                                    scrollPhysics:
                                        const AlwaysScrollableScrollPhysics(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'آدرس...',
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: ColorSetting.darkGrey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.only(
                              top: 64.0,
                              bottom: 32.0,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: detailScreenCustomHeader(
                                context,
                                'ویژگی ها',
                                Image.asset('assets/images/property_icon.png'),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  spacing: 24.0,
                                  children: [
                                    _specsContainer(
                                      context,
                                      'متراژ',
                                      totalAreaController,
                                    ),
                                    _specsContainer(
                                      context,
                                      'طبقه',
                                      floorController,
                                    ),
                                  ],
                                ),
                                Column(
                                  spacing: 24.0,
                                  children: [
                                    _specsContainer(
                                      context,
                                      'تعداد اتاق',
                                      roomsController,
                                    ),
                                    _specsContainer(
                                      context,
                                      'سال ساخت',
                                      yeaController,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SliverPadding(
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            sliver: SliverToBoxAdapter(
                              child: Divider(
                                color: ColorSetting.lightGrey1,
                                height: 1.0,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            sliver: SliverToBoxAdapter(
                              child: detailScreenCustomHeader(
                                context,
                                'امکانات',
                                Image.asset(
                                  'assets/images/facilities_icon.png',
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 40.0,
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorSetting.lightGrey,
                                      width: 2.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        facilities[index].keys.first,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Transform.scale(
                                        scale: 0.5,
                                        child: Switch(
                                          value: facilities[index].values.first,
                                          activeColor: Colors.white,
                                          inactiveThumbColor: Colors.white,
                                          inactiveTrackColor:
                                              ColorSetting.lightGrey,
                                          activeTrackColor:
                                              ColorSetting.customRed,
                                          onChanged: (value) {
                                            setState(() {
                                              facilities[index].update(
                                                facilities[index].keys.first,
                                                (val) => value,
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: facilities.length,
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.only(bottom: 32.0),
                            sliver: SliverToBoxAdapter(
                              child: CustomElevatedButton(
                                title: 'بعدی',
                                onActionTap: () {
                                  if (validateInputs()) {
                                    setAvizInfo();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => LocationScreen(avizInfo),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      showSnackBar(
                                        context,
                                        'تمامی فیلد هارا پر کنید',
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return showErrorMessage();
          }
        },
      )),
    );
  }

  Widget _specsContainer(
    BuildContext context,
    String title,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: ColorSetting.textGray),
        ),
        Container(
          width: 180.0,
          height: 60.0,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: ColorSetting.lightGrey1,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120.0,
                child: TextField(
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.end,
                  controller: controller,
                  enabled: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => increment(controller),
                    child: const Icon(
                      Icons.arrow_drop_up_outlined,
                      size: 18.0,
                      color: ColorSetting.customRed,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => decrement(controller),
                    child: const Icon(
                      Icons.arrow_drop_down_outlined,
                      size: 18.0,
                      color: ColorSetting.customRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
