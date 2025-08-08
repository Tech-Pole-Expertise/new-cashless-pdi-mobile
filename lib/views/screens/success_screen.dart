import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';  // 👈 ajouté
import 'package:get/get.dart';
import 'package:pv_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/elevated_button_with_icons.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String title = args['title'] ?? "Succès !";
    final String message =
        args['message'] ?? "Opération effectuée avec succès.";
    final IconData icon = args['icon'] ?? Icons.check_circle_outline;
    final String nextRoute = args['nextRoute'] ?? AppRoutes.login;
    final bool logoutRequired = args['logoutRequired'] ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w), // responsive padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primary, size: 100.w), // icon size responsive
              SizedBox(height: 20.h), // responsive spacing
              Text(
                title,
                style: TextStyle(
                  fontSize: 22.sp, // responsive fontSize
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp, // responsive fontSize
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: Get.width, // on peut aussi faire Get.width.w si tu préfères
                child: CustomElevatedButonWithIcons(
                  backgroundColor: AppColors.primary,
                  label: 'Terminer',
                  labelColor: Colors.yellow,
                  iconColor: Colors.yellow,
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    if (logoutRequired) {
                      MerchantController().logout();
                    }
                    Get.offAllNamed(nextRoute);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
