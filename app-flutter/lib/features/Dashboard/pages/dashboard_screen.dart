import 'package:aviz_project/features/Add/pages/category_screen.dart';
import 'package:aviz_project/features/Home/pages/home_screen.dart';
import 'package:aviz_project/features/Profile/pages/profile_screen.dart';
import 'package:aviz_project/features/Search/pages/search_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final int initialIndex;
  const DashboardScreen({this.initialIndex = 3, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int selectedBottomNavigationIndex;
  
  @override
  void initState() {
    selectedBottomNavigationIndex = widget.initialIndex;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xffF9FAFB),
        elevation: 0.0,
        currentIndex: selectedBottomNavigationIndex,
        selectedItemColor: const Color(0xffE60023),
        unselectedFontSize: 14.0,
        selectedLabelStyle: const TextStyle(fontFamily: 'Dana'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Dana'),
        onTap: (int value) {
          setState(() {
            selectedBottomNavigationIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/inactive_setting_icon.png'),
            activeIcon: Image.asset('assets/images/active_setting_icon.png'),
            label: 'آویز من',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/inactive_add_icon.png'),
            activeIcon: Image.asset('assets/images/active_add_icon.png'),
            label: 'افزودن آویز',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/inactive_search_icon.png'),
            activeIcon: Image.asset('assets/images/active_search_icon.png'),
            label: 'جستجو',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/inactive_home_icon.png'),
            activeIcon: Image.asset('assets/images/active_home_icon.png'),
            label: 'آویز آگهی ها',
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedBottomNavigationIndex,
        children: _getScreens(),
      ),
    );
  }

  List<Widget> _getScreens() {
    return <Widget>[
      const ProfileScreen(),
      const CategoryScreen(),
      const SearchScreen(),
      const HomeScreen(),
    ];
  }
}
