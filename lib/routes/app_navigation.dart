import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/screens/bottom_navigation_screen.dart';
import 'package:pdi_deme/views/screens/confirm_pin_screen.dart';
import 'package:pdi_deme/views/screens/forgot_password_screen.dart';
import 'package:pdi_deme/views/screens/history_screen.dart';
import 'package:pdi_deme/views/screens/home_screen.dart';
import 'package:pdi_deme/views/screens/login_screen.dart';
import 'package:pdi_deme/views/screens/panier_screen.dart';
import 'package:pdi_deme/views/screens/pdi_profil_screen.dart';
import 'package:pdi_deme/views/screens/pin_code_screen.dart';
import 'package:pdi_deme/views/screens/profile_screen.dart';
import 'package:pdi_deme/views/screens/recap_panier_screen.dart';
import 'package:pdi_deme/views/screens/retrait_success.dart';
import 'package:pdi_deme/views/screens/scan_error_screen.dart';
import 'package:pdi_deme/views/screens/scanner_screen.dart';
import 'package:pdi_deme/views/screens/splash_screen.dart';
import 'package:pdi_deme/views/screens/success_screen.dart';
import 'package:pdi_deme/views/screens/verify_otp_screen.dart';

class AppNavigation {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.scan,
      page: () => ScannerScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.errorScan,
      page: () => ErrorScanScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.otpVerify,
      page: () => VerifyOtpScreen(),
      transition: Transition.zoom,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => HistoryScreen(),
      transition: Transition.upToDown,
      transitionDuration: Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.bottom,
      page: () => BottomNavigationScreen(),
      transition: Transition.zoom,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.pdiProfile,
      page: () => const PdiProfileScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.panier,
      page: () => const PanierScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.recapPanier,
      page: () => const RecapitulatifScreen(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.pin,
      page: () => const PinCodeScreen(),
      transition: Transition.topLevel,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.retraitSuccess,
      page: () => const RetraitSuccessScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => PinCodeScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.successPage,
      page: () => SuccessScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.confirmPin,
      page: () => ConfirmPinScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 500),
    ),
  ];
}
