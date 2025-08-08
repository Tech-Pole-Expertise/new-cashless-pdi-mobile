import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/models/pdi_model.dart';
import 'package:pv_deme/constant/app_color.dart' show AppColors;
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class EmptyPanierScreen extends StatelessWidget {
  final PdiModel pdi;
  const EmptyPanierScreen({super.key, required this.pdi});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w), // Responsive padding horizontal
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    '${pdi.firstname.toUpperCase()} ${pdi.lastname}',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Text(
                    'N°${pdi.identifier}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/panier-vide.png',
                  height: 150.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Votre panier est vide\n',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Ouups... Votre panier ne contient aucun produit.\nVeuillez vous approvisionner puis réessayer.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomElevatedButton(
                label: 'Retour à l\'accueil',
                onPressed: () {
                  Get.offAllNamed(AppRoutes.bottom);
                },
                labelColor: Colors.yellow,
                backgroundColor: AppColors.primary,
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
