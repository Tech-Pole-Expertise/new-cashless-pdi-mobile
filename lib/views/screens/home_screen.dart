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
              // SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: _buildStatsCards(merchantStat),
              ),
              // SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: _buildRetraitSection(context),
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

  Widget _buildStatsCards(merchantStat) {
    return Column(
      children: [
        _buildStatCard(
          icon: Icons.local_shipping,
          title: "Approvisionnement reçu",
          count: merchantStat?.supplyCount ?? 0,
          subtitle: "Statistiques générales",
          color: AppColors.primary,
        ),
        _buildStatCard(
          icon: Icons.import_export,
          title: "Retraits effectués",
          count: merchantStat?.withdrawalCount ?? 0,
          subtitle: "Ce mois",
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required int count,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Icône dans un cercle coloré soft
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withAlpha((255 * 0.1).toInt()),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 16.w),

          // Texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Total : $count",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Image ou graphique
          Image.asset(
            'assets/img/group.png',
            height: 40.h,
            width: 40.w,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildRetraitSection(BuildContext context) {
    return Container(
      height: 300.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16.r),
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
