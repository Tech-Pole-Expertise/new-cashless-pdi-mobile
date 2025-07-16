import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pdi_deme/api/Service/merchand_data_store_provider.dart';
import 'package:pdi_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_circle_progress_bar.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final MerchandDataStore merchandDataStore = MerchandDataStore();
  final MerchantController merchantController = Get.find<MerchantController>();
  bool isLoading = true;
  bool showStartButton = false;

  @override
  void initState() {
    super.initState();
    _loadMerchantAndRedirect();
  }

  Future<void> _loadMerchantAndRedirect() async {
    merchantController.loadMerchant();

    await Future.delayed(const Duration(seconds: 3));

    final merchant = merchantController.merchant.value;

    if (merchant != null) {
      Logger().d('Merchant found: ${merchant.token}');
      Get.offAllNamed(AppRoutes.bottom);
    } else {
      Logger().d('No merchant found');
      setState(() {
        isLoading = false;
        showStartButton = true;
      });
    }
  }

  void handleStart() {
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            const Spacer(flex: 1), // 🔼 plus petit => logo monte
            // Logo plus haut
            Image.asset('assets/img/logo.png'),

            const Spacer(flex: 5), // 🔽 plus grand => bouton descend
            // Bouton ou loader
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child:
                  isLoading
                      ? CustomCircleProgressBar(
                        color: Colors.white,
                        backgroundColor: AppColors.primary,
                        strokeWidth: 5,
                      )
                      : showStartButton
                      ? CustomElevatedButton(
                        label: 'Commencer',
                        labelColor: AppColors.primary,
                        onPressed: handleStart,
                        backgroundColor: AppColors.secondary,
                      )
                      : const SizedBox(),
            ),

            const Spacer(flex: 2), // garde espace en bas
            // Texte collé en bas
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Copyright © Tech Pôle Expertise 2025. All Rights Reserved',
                style: const TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
