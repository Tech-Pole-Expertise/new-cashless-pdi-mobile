import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pdi_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pdi_deme/api/controllers/api_controller.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_navigation.dart';
import 'package:pdi_deme/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final merchantController = Get.put(MerchantController(), permanent: true);
  merchantController.loadMerchant();
  Get.put(ApiController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PDI Deme',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppNavigation.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
