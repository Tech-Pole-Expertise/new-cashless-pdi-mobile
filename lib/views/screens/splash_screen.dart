import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 👈 Important
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pv_deme/api/Service/merchand_data_store_provider.dart';
import 'package:pv_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pv_deme/api/Service/token_data_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/custom_circle_progress_bar.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final MerchandDataStore merchandDataStore = MerchandDataStore();
  final MerchantController merchantController = Get.put(MerchantController());
  final TokenDataController tokenController = Get.find<TokenDataController>();

  bool isLoading = true;
  bool showStartButton = false;

  @override
  void initState() {
    super.initState();
    _loadMerchantAndRedirect();
  }

  Future<void> _loadMerchantAndRedirect() async {
    await Future.delayed(const Duration(seconds: 3));
    final token = tokenController.getToken();

    if (token != null && token.token.isNotEmpty) {
      Logger().d('Merchant found: ${token.token}');
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
            const Spacer(flex: 1),
            // Logo
            Image.asset('assets/img/logo.png'),
            const Spacer(flex: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child:
                  isLoading
                      ? CustomCircleProgressBar(
                        color: Colors.white,
                        backgroundColor: AppColors.primary,
                        strokeWidth: 5.w, // Responsive width
                      )
                      : showStartButton
                      ? CustomElevatedButton(
                        label: 'Commencer',
                        labelColor: AppColors.primary,
                        onPressed: handleStart,
                        backgroundColor: AppColors.secondary,
                      )
                      : SizedBox(height: 10.h),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                'Copyright © Tech Pôle Expertise 2025. All Rights Reserved',
                style: TextStyle(color: Colors.white, fontSize: 10.sp),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
