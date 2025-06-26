import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pdi_deme/api/Service/merchand_data_store_provider.dart';
import 'package:pdi_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final MerchandDataStore merchandDataStore = MerchandDataStore();
@override
void initState() {
  super.initState();
  
  final merchantController = Get.find<MerchantController>();

  // Charge immédiatement le merchant depuis le stockage
  merchantController.loadMerchant();

  Future.delayed(const Duration(seconds: 5), () {
    Logger().d('merchantController: ${merchantController.merchant.value?.token}');
    if (merchantController.merchant.value != null) {
      Get.offAllNamed(AppRoutes.bottom);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primary, elevation: 0),
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 175,
                child: Image.asset('assets/img/phone.png', fit: BoxFit.cover),
              ),
            ),
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Pdi ',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                    children: [
                      TextSpan(
                        text: 'Deme',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                      strokeWidth: 5,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 125,
                child: Image.asset('assets/img/panier.png', fit: BoxFit.cover),
              ),
            ),
            const Text(
              'Copyright ©  Tech Pôle Expertise 2025. All Rights Reserved',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
