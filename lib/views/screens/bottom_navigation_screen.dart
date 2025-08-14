import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/screens/appro_stock_screen.dart';
import 'package:pv_deme/views/screens/history_screen.dart';
import 'package:pv_deme/views/screens/home_screen.dart';
import 'package:pv_deme/views/screens/profile_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    StockAndApproView(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 1,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          showUnselectedLabels: true,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          selectedLabelStyle: TextStyle(fontSize: 14.sp),
          unselectedLabelStyle: TextStyle(fontSize: 12.sp),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 24.sp),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory, size: 24.sp),
              label: 'Stock',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history, size: 24.sp),
              label: 'Historique',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 24.sp),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
