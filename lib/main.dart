import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pv_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pv_deme/api/Service/token_data_controller.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/api/controllers/dependancy_injection.dart';
import 'package:pv_deme/api/controllers/network_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_navigation.dart';
import 'package:pv_deme/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Get.put(NetworkController());
  await GetStorage.init();
  Get.put(TokenDataController());
  Get.put(MerchantController());
  Get.put(ApiController());
  DependancyInjection.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
  return ScreenUtilInit(
  designSize: const Size(430, 932),
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (_, __) => GetMaterialApp(
    title: 'PV Dêmê',
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('fr', 'FR')],
    locale: const Locale('fr', 'FR'),
    theme: ThemeData(
      fontFamily: 'Inter',
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      scaffoldBackgroundColor: Colors.white,
    ),
    initialRoute: AppRoutes.splash,
    getPages: AppNavigation.routes,
    // 👇 très important
    builder: (context, child) {
      ScreenUtil.init(context);
      return child!;
    },
  ),
);

  }
}
