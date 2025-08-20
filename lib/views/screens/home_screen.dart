import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 👈
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pv_deme/api/Service/merchant_stat_controller.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/api/controllers/network_controller.dart';
import 'package:pv_deme/api/models/retrait_history_model.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/elevated_button_with_icons.dart';
import 'package:pv_deme/views/widget/phone_entry_bottom_sheet.dart';

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

  if (apiController.merchantStat.value == null) {
    apiController.getMarchandStat();
  }

  // Écoute la reconnexion
  final networkController = Get.find<NetworkController>();
  networkController.onReconnect = () {
    // Actualise automatiquement les données quand la connexion revient
    apiController.getMarchandStat();
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
                top: 160.h,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    width: 390.w,
                    height: 225.h,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    child: _buildStatsCards(merchantStat),
                  ),
                ),
              ),
              Positioned(
                top: 400.h,
                left: 0,
                right: 0,
                child: _buildRetraitSection(context),
              ),
              Positioned(
                top: 550.h,
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
    return Container(
      height: 205.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Icon(Icons.person, size: 45.sp, color: AppColors.primary),
            ),
          ),
          // SizedBox(width: 12.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
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
      ),
    );
  }

  Widget _buildStatsCards(merchantStat) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Statistiques générales',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            _buildStatCard(
              title: "PV Servis",
              value: '500',
              imagePath: 'assets/img/pv.png',
            ),
            _buildStatCard(
              title: "Approvisionnement",
              value: merchantStat?.supplyCount.toString() ?? '0',
              imagePath: 'assets/img/appro.png',
            ),
            _buildStatCard(
              title: "Retrait du mois",
              value: merchantStat?.withdrawalCount.toString() ?? '0',
              imagePath: 'assets/img/scan.png',
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
            color: AppColors.primary,
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
          width: Get.width,
          color: AppColors.primaryLight,
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 170.w,
                  height: 50.h,
                  child: CustomElevatedButonWithIcons(
                    label: "Scanner",
                    icon: Icons.qr_code_scanner,
                    iconColor: Colors.yellow,
                    onPressed: () => Get.toNamed(AppRoutes.scan),
                    backgroundColor: Colors.green[900]!,
                    labelColor: Colors.yellow,
                  ),
                ),
                SizedBox(
                  width: 170.w,
                  height: 50.h,
                  child: CustomElevatedButonWithIcons(
                    label: "Saisir",
                    icon: Icons.person,
                    iconColor: Colors.yellow,
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
                    backgroundColor: Colors.green[900]!,
                    labelColor: Colors.yellow,
                  ),
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
            height: 220.h, // ajuste selon ce que tu veux afficher
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

                  return _buildTransactionItem(retrait, totalProduits);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(RetraitHistoryModel retrait, int totalProduits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLight,
                  border: Border.all(color: AppColors.primary),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      retrait.clientName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'N° ${retrait.pdi.identifier}',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    Text(
                      'Qté produits : $totalProduits',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Date du retrait',
                    style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('dd/MM/yyyy').format(retrait.date),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: Colors.black12, height: 1.h),
      ],
    );
  }
}
