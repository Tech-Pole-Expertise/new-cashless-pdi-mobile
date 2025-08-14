import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 👈
import 'package:get/get.dart';
import 'package:pv_deme/api/Service/merchant_stat_controller.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/custom_outline_button.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';
import 'package:pv_deme/views/widget/phone_entry_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ApiController apiController = Get.find<ApiController>();
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final merchantStat = apiController.merchantStat.value;

      if (apiController.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildUserHeader(merchantStat),
              _buildPdiWithdraw('500'),
              // SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: _buildStatsCards(merchantStat),
              ),
              // SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Expanded(child: _buildRetraitSection(context)),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildUserHeader(merchantStat) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40.r,
          backgroundColor: Colors.transparent,
          backgroundImage: const AssetImage('assets/img/pro.png'),
        ),
        // SizedBox(width: 12.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
              children: [
                TextSpan(
                  text:
                      merchantStat != null
                          ? '${merchantStat.lastname.toUpperCase()} ${merchantStat.firstname}\n'
                          : 'Utilisateur inconnu\n',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: merchantStat?.phone ?? 'Téléphone indisponible',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPdiWithdraw(String count) {
    return Container(
      height: 108.h,
      // padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            Color(0xFFD8E6D5), // Vert clair
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nombre de PDI servi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Total: $count',
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: AppColors.secondaryLight,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Container(
                    width: 140.w,
                    height: 65.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF7CAC10).withAlpha(
                            (0.6 * 255).toInt(),
                          ), // Vert clair semi-transparent
                          Colors.yellow..withAlpha((0.6 * 255).toInt()),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      // Vert clair
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(280.h), // arrondi haut gauche
                        topRight: Radius.circular(280.h), // arrondi haut droit
                      ),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        left: BorderSide(
                          color: Colors.white,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        right: BorderSide(
                          color: Colors.white,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 35.w,
                top: 35.h,
                child: Image.asset(
                  'assets/img/vector.png',
                  height: 65.h,
                  width: 65.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(merchantStat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard(
          image: 'assets/img/appro.png',
          title: "Approvisionnement",
          count: merchantStat?.supplyCount ?? 0,

          color: AppColors.primary,
        ),
        _buildStatCard(
          image: 'assets/img/retrait.png',
          title: "Retraits effectués",
          count: merchantStat?.withdrawalCount ?? 0,

          color: Color(0xFF7CAC10), // Vert
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String image,
    required String title,
    required int count,
    required Color color,
  }) {
    return Container(
      width: 165.w,
      height: 123.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          // Contenu principal centré
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(image, height: 35.h, width: 35.w),
                SizedBox(height: 6.h),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 10.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Total: $count',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Ligne en bas
          Positioned(
            bottom: 0,
            left: 12,
            right: 12,
            child: Container(
              width: 50.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetraitSection(BuildContext context) {
    return Container(
      
      padding: EdgeInsets.all(20.w),
       decoration: BoxDecoration(
         color: AppColors.primaryLight,
         borderRadius: BorderRadius.only(
           topLeft: Radius.circular(24),
           topRight: Radius.circular(24),
         ),
       ),
      child: Column(
        children: [
           Text(
             'Veuillez sélectionner\nune méthode de retrait',
             textAlign: TextAlign.center,
             style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
           ),
           SizedBox(height: 16.h),
          CustomElevatedButton(
            label: "Scanner le QR code",
            onPressed: () => Get.toNamed(AppRoutes.scan),
            backgroundColor: Colors.green[900]!,
            labelColor: Colors.yellow,
          ),
          SizedBox(height: 12.h),
          CustomOutlinedButton(
            label: "Entrer le numéro de la personne",
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                ),
                builder:
                    (context) =>
                        PhoneEntryBottomSheet(showLoadingIndicator: false),
              );
            },
            borderColor: AppColors.primary,
            labelColor: Colors.green[900],
          ),
        ],
      ),
    );
  }
}
