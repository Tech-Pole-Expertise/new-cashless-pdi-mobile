import 'package:flutter/material.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/views/screens/history_screen.dart';
import 'package:pdi_deme/views/screens/home_screen.dart';
import 'package:pdi_deme/views/screens/profile_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [HomeScreen(), HistoryScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
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
        items: [
          _buildAnimatedNavItem(Icons.home, 'Accueil', 0),
          _buildAnimatedNavItem(Icons.history, 'Historique', 1),
          _buildAnimatedNavItem(Icons.person, 'Profil', 2),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildAnimatedNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = index == currentIndex;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        width: 50,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isSelected ? AppColors.primary : null,
        ),
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: isSelected ? 14 : 0),
        child: Icon(
          icon,
          size: isSelected ? 35 : 24,
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
      ),
      label: label,
    );
  }
}
