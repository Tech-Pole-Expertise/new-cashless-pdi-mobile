import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 👈
import 'package:get/get.dart';
import 'package:pv_deme/api/Service/merchant_stat_controller.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/api/controllers/network_controller.dart';
import 'package:pv_deme/api/models/retrait_history_model.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/created_elevated_button.dart';
import 'package:pv_deme/views/widget/curved_container_widget.dart';
import 'package:pv_deme/views/widget/phone_entry_bottom_sheet.dart';
import 'package:pv_deme/views/widget/transaction_item.dart';
import 'package:pv_deme/views/widget/user_account_data_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiController apiController = Get.find<ApiController>();

  final homeController = Get.put(HomeController());

  bool isrefreshing = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (apiController.merchantStat.value == null) {
        apiController.getMarchandStat();
      }
    });

    // Écoute la reconnexion
    final networkController = Get.find<NetworkController>();
    networkController.onReconnect = () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        apiController.getMarchandStat();
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: () {
        isrefreshing = true;
        return apiController.getMarchandStat();
      },
      child: Obx(() {
        final merchantStat = apiController.merchantStat.value;

        if (apiController.isLoading.value && !isrefreshing) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          color: Colors.white,
          width: Get.width,
          height: Get.height,
          child: Stack(
            children: [
              _buildUserHeader(merchantStat),
              Positioned(
                top: 130.h,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    width: 390.w,
                    height: 195.h,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    child: _buildStatsSection(merchantStat),
                  ),
                ),
              ),
              Positioned(
                top: 320.h,
                left: 0,
                right: 0,
                child: _buildRetraitSection(context),
              ),
              Positioned(
                top: 445.h,
                left: 0,
                right: 0,
                child: _buildLastWithdrawalSection(merchantStat),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildUserHeader(merchantStat) {
    return CurvedContainer(
      child: Padding(
        padding: EdgeInsets.only(bottom: 80.h),
        child: UserAccountDataWidget(merchantStat: merchantStat),
      ),
    );
  }

  Widget _buildStatsSection(merchantStat) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Statistiques générales',
          style: TextStyle(
            fontSize: 16.sp,
            color: Color(0xFF191E28), // Couleur primaire
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            _buildStatCard(
              title: "PV Servis",
              value: merchantStat?.customerCount.toString() ?? '0',
              imagePath: 'assets/icons/people.png',
            ),
            _buildStatCard(
              title: "Approvisionnement",
              value: merchantStat?.supplyCount.toString() ?? '0',
              imagePath: 'assets/icons/transit.png',
            ),
            _buildStatCard(
              title: "Retrait du mois",
              value: merchantStat?.withdrawalCount.toString() ?? '0',
              imagePath: 'assets/icons/scann.png',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String imagePath, // Add imagePath parameter
  }) {
    return Column(
      children: [
        Container(
          width: 62.w,
          height: 62.h,
          decoration: BoxDecoration(
            color: AppColors.primary,

            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              imagePath, // Replace with the actual image path
              height: 30.h,
              width: 30.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildRetraitSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(12.w),
          child: Text(
            'Actions rapides',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
        ),

        Container(
          color: AppColors.primaryLight,
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CreatedElevatedButton(
                  text: "Scanner",
                  imagePath: 'assets/icons/scann.png',
                  onPressed: () => Get.toNamed(AppRoutes.scan),
                ),
                CreatedElevatedButton(
                  text: "Saisir",
                  imagePath: 'assets/icons/phone.png',
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
                          (context) => PhoneEntryBottomSheet(
                            showLoadingIndicator: false,
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastWithdrawalSection(merchantStat) {
    if (merchantStat == null || merchantStat.lastThreeWithdraw == null) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dernières transactions',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 24.h),
            Center(
              child: Text(
                'Aucun historique disponible.',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
      );
    }

    final List<RetraitHistoryModel> lastWithdrawal =
        merchantStat.lastThreeWithdraw;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dernières transactions',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          // SizedBox(height: 8.h),

          // 🟢 Hauteur fixe pour activer le scroll interne
          SizedBox(
            height: 180.h, // ajuste selon ce que tu veux afficher
            child: Obx(() {
              if (apiController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (lastWithdrawal.isEmpty) {
                return Center(
                  child: Text(
                    'Aucun historique disponible.',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                );
              }

              return ListView.builder(
                itemCount: lastWithdrawal.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final retrait = lastWithdrawal[index];
                  final int totalProduits = retrait.produits.fold(
                    0,
                    (sum, p) => sum + p.qte,
                  );

                  return TransactionItemWidget(
                    retrait: retrait,
                    totalProduits: totalProduits,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  //
}
