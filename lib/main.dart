import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pv_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pv_deme/api/Service/token_data_controller.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_navigation.dart';
import 'package:pv_deme/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  Get.put(TokenDataController());
  Get.put(MerchantController());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:
          Colors.transparent, // rend la barre de statut transparente
      statusBarIconBrightness:
          Brightness.dark, // ou Brightness.light selon ton fond
      systemNavigationBarColor: Colors.white, // optionnel : barre en bas
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  Get.put(ApiController());
  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812), // ton design de référence (iPhone 11 par ex)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PV Dêmê',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr', 'FR')],
      locale: const Locale('fr', 'FR'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppNavigation.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
