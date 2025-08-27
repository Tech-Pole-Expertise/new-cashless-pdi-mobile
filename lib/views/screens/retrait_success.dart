import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class RetraitSuccessScreen extends StatelessWidget {
  const RetraitSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final message = Get.arguments ?? "Retrait effectué avec succès !";

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            // 🔹 Logo en haut
            SizedBox(height: 24.h),
            Container(
              width: 120.w,
              height: 50.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/img/logo.png'),
                ),
              ),
            ),

            // 🔹 Icône + message au centre
            Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: const Color(0xFFCCFF00),
                  size: 100.w,
                ),
                SizedBox(height: 16.h),
                Text(
                  '$message!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // 🔹 Bouton en bas
            Padding(
              padding: EdgeInsets.all(24.w),
              child: SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  label: "Effectuer un retrait",
                  labelColor: AppColors.primary,
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.bottom);
                  },
                  backgroundColor: const Color(0xFFE0F2F1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
