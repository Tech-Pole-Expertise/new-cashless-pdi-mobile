import 'package:get/get.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/screens/api_error_screen.dart';
import 'package:pv_deme/views/screens/appro_stock_screen.dart';
import 'package:pv_deme/views/screens/bottom_navigation_screen.dart';
import 'package:pv_deme/views/screens/change_password_screen.dart';
import 'package:pv_deme/views/screens/change_phone_number_screen.dart';
import 'package:pv_deme/views/screens/empty_panier_screen.dart';
import 'package:pv_deme/views/screens/forgot_password_screen.dart';
import 'package:pv_deme/views/screens/history_screen.dart';
import 'package:pv_deme/views/screens/home_screen.dart';
import 'package:pv_deme/views/screens/login_screen.dart';
import 'package:pv_deme/views/screens/panier_screen.dart';
import 'package:pv_deme/views/screens/pdi_profil_screen.dart';
import 'package:pv_deme/views/screens/pin_code_screen.dart';
import 'package:pv_deme/views/screens/profile_screen.dart';
import 'package:pv_deme/views/screens/recap_panier_screen.dart';
import 'package:pv_deme/views/screens/retrait_success.dart';
import 'package:pv_deme/views/screens/scan_error_screen.dart';
import 'package:pv_deme/views/screens/scanner_screen.dart';
import 'package:pv_deme/views/screens/splash_screen.dart';
import 'package:pv_deme/views/screens/success_screen.dart';
import 'package:pv_deme/views/screens/verify_otp_for_password_screen.dart';
import 'package:pv_deme/views/screens/verify_otp_screen.dart';
import 'package:pv_deme/views/screens/update_password_screen.dart';

class AppNavigation {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
    GetPage(name: AppRoutes.scan, page: () => ScannerScreen()),
    GetPage(name: AppRoutes.errorScan, page: () => ErrorScanScreen()),
    GetPage(name: AppRoutes.otpVerify, page: () => VerifyOtpScreen()),
    GetPage(name: AppRoutes.home, page: () => HomeScreen()),
    GetPage(name: AppRoutes.marchandStocks, page: () => StockAndApproView()),
    GetPage(name: AppRoutes.profile, page: () => ProfileScreen()),
    GetPage(name: AppRoutes.history, page: () => HistoryScreen()),
    GetPage(name: AppRoutes.bottom, page: () => BottomNavigationScreen()),
    GetPage(name: AppRoutes.pdiProfile, page: () => const PdiProfileScreen()),
    GetPage(name: AppRoutes.panier, page: () => const PanierScreen()),
    GetPage(name: AppRoutes.recapPanier, page: () => RecapitulatifScreen()),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.retraitSuccess,
      page: () => const RetraitSuccessScreen(),
    ),
    GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: AppRoutes.resetPassword, page: () => PinCodeScreen()),
    GetPage(name: AppRoutes.successPage, page: () => SuccessScreen()),
    GetPage(name: AppRoutes.apiError, page: () => ApiErrorScreen()),
    GetPage(name: AppRoutes.changePhone, page: () => ChangePhoneScreen()),
    GetPage(name: AppRoutes.otpVerifyForPassword, page: () => VerifyOtpForPasswordScreen()),
    GetPage(name: AppRoutes.updatePassword, page: () => UpdatePasswordScreen()),

  ];
}
