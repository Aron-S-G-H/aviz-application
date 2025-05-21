import 'dart:io';
import 'package:aviz_project/components/custom_button.dart';
import 'package:aviz_project/components/detail_screen_components.dart';
import 'package:aviz_project/features/Add/bloc/add_bloc.dart';
import 'package:aviz_project/features/Dashboard/pages/dashboard_screen.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:aviz_project/widgets/error_handler.dart';
import 'package:aviz_project/widgets/input_formatter.dart';
import 'package:aviz_project/widgets/loading_animation.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class UploadimageScreen extends StatelessWidget {
  final Map<String, dynamic> avizInfo;
  const UploadimageScreen(this.avizInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddBloc(),
      child: UploadImageScreenView(avizInfo),
    );
  }
}

class UploadImageScreenView extends StatefulWidget {
  final Map<String, dynamic> avizInfo;
  const UploadImageScreenView(this.avizInfo, {super.key});

  @override
  State<UploadImageScreenView> createState() => _UploadImageScreenViewState();
}

class _UploadImageScreenViewState extends State<UploadImageScreenView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController pricePerMeterController = TextEditingController();
  bool chatAvailable = true;
  bool callAvailable = true;
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      List<File> images = pickedFiles.map((file) => File(file.path)).toList();
      List<File> compressedImages = await _compressAllImages(images);
      setState(() {
        _clearPreviousFiles();
        _images = compressedImages;
      });
    }
  }

  Future<File?> _compressImage(File image) async {
    try {
      String targetPath = image.path.replaceAll('.jpg', '_compressed.jpg');
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 80,
        minWidth: 800,
        minHeight: 800,
      );
      if (compressedFile != null) {
        print('حجم عکس اصلی: ${(await image.length()) / 1024} KB');
        print(
            'حجم عکس فشرده‌شده: ${(await File(compressedFile.path).length()) / 1024} KB');
        return File(compressedFile.path);
      }
      return null;
    } catch (e) {
      print('خطا در فشرده‌سازی: $e');
      return null;
    }
  }

  Future<List<File>> _compressAllImages(List<File> images) async {
    List<File> compressed = [];
    for (var image in images) {
      File? compressedImage = await _compressImage(image);
      if (compressedImage != null) {
        compressed.add(compressedImage);
      }
    }
    return compressed;
  }

// تابع برای پاک کردن فایل‌های موقت
  void _clearPreviousFiles() {
    for (var image in _images) {
      if (image.existsSync()) {
        image.deleteSync();
      }
    }
  }

  void setAvizInfo() {
    widget.avizInfo['title'] = titleController.text;
    widget.avizInfo['description'] = descriptionController.text;
    widget.avizInfo['price'] = priceController.text.replaceAll(',', '');
    widget.avizInfo['pricePerMeter'] =
        pricePerMeterController.text.replaceAll(',', '');
    widget.avizInfo['chatAvailable'] = chatAvailable;
    widget.avizInfo['callAvailable'] = callAvailable;
    widget.avizInfo['images'] = _images;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    pricePerMeterController.dispose();
    _clearPreviousFiles(); // پاک کردن فایل‌های موقت
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
                      'انتخاب تصویر',
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
      body: SafeArea(
        child: BlocConsumer<AddBloc, AddState>(
          listener: (context, state) {
            if (state is SubmitAvizResponseState) {
              state.response.fold(
                (l) {
                  print(l);
                  ScaffoldMessenger.of(context).showSnackBar(
                    showSnackBar(context, 'خطا در ثبت آویز'),
                  );
                },
                (r) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(
                        initialIndex: 0,
                      ),
                    ),
                    (route) => false,
                  );
                },
              );
            }
          },
          builder: (context, state) {
            if (state is CategoryLoadingState) {
              return loadingAnimation();
            }
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
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
                            padding:
                                const EdgeInsets.only(top: 32.0, bottom: 24.0),
                            sliver: SliverToBoxAdapter(
                              child: detailScreenCustomHeader(
                                context,
                                'تصویر آویز',
                                Image.asset('assets/images/map_icon.png'),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                              child: choseImageContainer(context)),
                          SliverPadding(
                            padding:
                                const EdgeInsets.only(top: 32.0, bottom: 24.0),
                            sliver: SliverToBoxAdapter(
                              child: detailScreenCustomHeader(
                                context,
                                'عنوان آویز',
                                Image.asset('assets/images/title_icon.png'),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              height: 50.0,
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: ColorSetting.lightGrey1,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: TextField(
                                controller: titleController,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                enabled: true,
                                scrollPhysics:
                                    const AlwaysScrollableScrollPhysics(),
                                style: Theme.of(context).textTheme.titleMedium,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'عنوان آویز را وارد کنید',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: ColorSetting.textGray,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding:
                                const EdgeInsets.only(top: 32.0, bottom: 24.0),
                            sliver: SliverToBoxAdapter(
                              child: detailScreenCustomHeader(
                                context,
                                'توضیحات',
                                Image.asset('assets/images/explain_icon.png'),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              height: 104.0,
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: ColorSetting.lightGrey1,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: TextField(
                                controller: descriptionController,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                maxLines: 3,
                                enabled: true,
                                scrollPhysics:
                                    const AlwaysScrollableScrollPhysics(),
                                style: Theme.of(context).textTheme.titleMedium,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'توضیحات آویز را وارد کنید ...',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: ColorSetting.textGray,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding:
                                const EdgeInsets.only(top: 32.0, bottom: 24.0),
                            sliver: SliverToBoxAdapter(
                              child: detailScreenCustomHeader(
                                context,
                                'قیمت',
                                const Icon(
                                  Icons.attach_money,
                                  color: ColorSetting.customRed,
                                ),
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
                                      'قیمت کل',
                                      priceController,
                                    ),
                                  ],
                                ),
                                Column(
                                  spacing: 24.0,
                                  children: [
                                    _specsContainer(
                                      context,
                                      'قیمت هر متر',
                                      pricePerMeterController,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Container(
                                    height: 40.0,
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
                                          'فعال کردن گفتگو',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Transform.scale(
                                          scale: 0.5,
                                          child: Switch(
                                            value: chatAvailable,
                                            activeColor: Colors.white,
                                            inactiveThumbColor: Colors.white,
                                            inactiveTrackColor:
                                                ColorSetting.lightGrey,
                                            activeTrackColor:
                                                ColorSetting.customRed,
                                            onChanged: (value) {
                                              setState(() {
                                                chatAvailable = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Container(
                                    height: 40.0,
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
                                          'فعال کردن تماس',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Transform.scale(
                                          scale: 0.5,
                                          child: Switch(
                                              value: callAvailable,
                                              activeColor: Colors.white,
                                              inactiveThumbColor: Colors.white,
                                              inactiveTrackColor:
                                                  ColorSetting.lightGrey,
                                              activeTrackColor:
                                                  ColorSetting.customRed,
                                              onChanged: (value) {
                                                setState(() {
                                                  callAvailable = value;
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 32.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: CustomElevatedButton(
                                    title: 'ثبت آویز',
                                    onActionTap: () {
                                      if (_checkInputs(context)) {
                                        setAvizInfo();
                                        context.read<AddBloc>().add(
                                            SubmitAizEvent(widget.avizInfo));
                                      }
                                    },
                                  ),
                                ),
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
          },
        ),
      ),
    );
  }

  Widget choseImageContainer(BuildContext context) {
    return DottedBorder(
      radius: const Radius.circular(4.0),
      color: ColorSetting.textGray,
      dashPattern: const [10, 5],
      child: SizedBox(
        height: 160.0,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'لطفا تصویر آویز خود را بارگذاری کنید',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: ColorSetting.textGray),
            ),
            const SizedBox(height: 16.0),
            CustomElevatedButton(
              title: _images.isEmpty ? 'بارگذاری تصویر' : 'تصویر انتخاب شده',
              icon: Image.asset('assets/images/upload_icon.png'),
              onActionTap: () => _pickImages(),
              backgroundColor:
                  _images.isEmpty ? ColorSetting.customRed : Colors.green,
            )
          ],
        ),
      ),
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
          child: TextField(
            textDirection: TextDirection.ltr,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            controller: controller,
            enabled: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ThousandSeparatorFormatter(),
            ],
            style: Theme.of(context).textTheme.titleMedium,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  bool _checkInputs(BuildContext context) {
    String? errorMessage;

    if (_images.isEmpty) {
      errorMessage = 'عکس آویز رو انتخاب کنید';
    } else if (titleController.text.isEmpty) {
      errorMessage = 'لطفا عنوان آویز را وارد کنید';
    } else if (priceController.text.isEmpty ||
        pricePerMeterController.text.isEmpty) {
      errorMessage = 'فیلدهای مربوط به قیمت آویز رو وارد کنید';
    } else {
      int price = int.parse(priceController.text.replaceAll(',', ''));
      int pricePerMeter =
          int.parse(pricePerMeterController.text.replaceAll(',', ''));
      if (price <= pricePerMeter) {
        errorMessage = 'قیمت هر متر از قیمت کل بیشتر است';
      }
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        showSnackBar(context, errorMessage),
      );
      return false;
    }
    return true;
  }
}
