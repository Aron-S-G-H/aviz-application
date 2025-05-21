import 'package:aviz_project/components/custom_button.dart';
import 'package:aviz_project/components/detail_screen_components.dart';
import 'package:aviz_project/features/Add/pages/uploadimage_screen.dart';
import 'package:aviz_project/features/Dashboard/pages/dashboard_screen.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:latlong2/latlong.dart';

class LocationScreen extends StatefulWidget {
  final Map<String, dynamic> avizInfo;
  const LocationScreen(this.avizInfo, {super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LatLng? _selectedLocation;
  bool isLocationAllowed = true;

  void setAvizInfo() {
    widget.avizInfo['isLocationAllowed'] = isLocationAllowed;
    widget.avizInfo['location'] = _selectedLocation != null
        ? '${_selectedLocation!.latitude},${_selectedLocation!.longitude}'
        : '';
  }

  Future<void> _openMapScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

    if (result != null && result is LatLng) {
      setState(() {
        _selectedLocation = result;
      });
    }
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
                      'موقعیت مکانی',
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
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
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
                        padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                        sliver: SliverToBoxAdapter(
                          child: detailScreenCustomHeader(
                            context,
                            'موقعیت مکانی',
                            Image.asset('assets/images/map_icon.png'),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Text(
                          'بعد انتخاب محل دقیق روی نقشه میتوانید نمایش آن را فعال یا غیر فعال کید تا حریم خصوصی شما خفظ شود.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: ColorSetting.textGray),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        sliver: SliverToBoxAdapter(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 144.0,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/map.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (_selectedLocation != null) ...{
                                CustomElevatedButton(
                                  title: 'موقعیت انتخاب شده',
                                  backgroundColor: Colors.green,
                                  onActionTap: () {},
                                ),
                              } else ...{
                                CustomElevatedButton(
                                  title: 'انتخاب موقعیت مکانی',
                                  onActionTap: () => _openMapScreen(),
                                ),
                              }
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'موقعیت دقیق نقشه نمایش داده شود؟',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Transform.scale(
                                scale: 0.5,
                                child: Switch(
                                  value: isLocationAllowed,
                                  activeColor: Colors.white,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: ColorSetting.lightGrey,
                                  activeTrackColor: ColorSetting.customRed,
                                  onChanged: (value) {
                                    setState(() {
                                      isLocationAllowed = value;
                                    });
                                  },
                                ),
                              ),
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
                                title: 'بعدی',
                                onActionTap: () {
                                  setAvizInfo();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UploadimageScreen(widget.avizInfo),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<Marker> _markers = [];
  LatLng? _selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(35.72856716954415, 51.33476821885296),
              initialZoom: 10.0,
              onLongPress: (tapPosition, point) {
                setState(() {
                  _markers.clear();
                  _markers.add(
                    Marker(
                      point: point,
                      child: const Icon(
                        Icons.location_pin,
                        color: ColorSetting.customRed,
                        size: 40.0,
                      ),
                    ),
                  );
                  _selectedPosition = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.aviz_project',
              ),
              MarkerLayer(markers: _markers)
            ],
          ),
          if (_selectedPosition != null)
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.1,
              child: AnimationConfiguration.synchronized(
                child: ScaleAnimation(
                  duration: const Duration(milliseconds: 400),
                  child: FadeInAnimation(
                    duration: const Duration(milliseconds: 400),
                    child: CustomElevatedButton(
                      onActionTap: () {
                        Navigator.pop(context, _selectedPosition);
                      },
                      title: 'ثبت موقعیت',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
