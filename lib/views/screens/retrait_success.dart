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
  backgroundColor: const Color(0xFF004D40),
  body: SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 24.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 40.h),

            // Logo en haut
            Image.asset('assets/img/logo.png', width: 250.w),

            SizedBox(height: 60.h),

            // Icône et texte au centre
            Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: const Color(0xFFCCFF00),
                  size: 100.w,
                ),
                SizedBox(height: 14.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            SizedBox(height: 35.h),
            // Bouton en bas
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                label: "Retourner sur accueil",
                labelColor: AppColors.primary,
                onPressed: () {
                  Get.offAllNamed(AppRoutes.bottom);
                },
                backgroundColor: const Color(0xFFE0F2F1),
              ),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    ),
  ),
);

  }
}
