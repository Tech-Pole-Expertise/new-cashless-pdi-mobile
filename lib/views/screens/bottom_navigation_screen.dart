// import 'package:flutter/material.dart';
// import 'package:pdi_deme/constant/app_color.dart';
// import 'package:pdi_deme/views/screens/appro_stock_screen.dart';
// import 'package:pdi_deme/views/screens/history_screen.dart';
// import 'package:pdi_deme/views/screens/home_screen.dart';
// import 'package:pdi_deme/views/screens/profile_screen.dart';

// class BottomNavigationScreen extends StatefulWidget {
//   const BottomNavigationScreen({super.key});

//   @override
//   State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
// }

// class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
//   int currentIndex = 0;

//   final List<Widget> screens = [
//     HomeScreen(),
//     StockAndApproView(),
//     HistoryScreen(),
//     ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: screens[currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.white,
//         elevation: 8,
//         selectedItemColor: AppColors.primary, // Couleur sélectionnée
//         unselectedItemColor: AppColors.textSecondary, // Couleur non sélectionnée
//         showUnselectedLabels: true,
//         currentIndex: currentIndex,
//         type: BottomNavigationBarType.fixed,
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Accueil',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.inventory),
//             label: 'Stock',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history),
//             label: 'Historique',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profil',
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/views/screens/appro_stock_screen.dart';
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 8,
        selectedItemColor: AppColors.primary, // Couleur sélectionnée
        unselectedItemColor:
            AppColors.textSecondary, // Couleur non sélectionnée
        showUnselectedLabels: true,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stock'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
