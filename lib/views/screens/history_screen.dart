import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/api/controllers/network_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/retrait_detail_bottom_sheet.dart';
import 'package:pv_deme/views/widget/retrait_filter_sheet.dart';
import 'package:pv_deme/views/widget/transaction_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController recherche = TextEditingController();

  final TextEditingController filter = TextEditingController();

  final ApiController apiController = Get.find<ApiController>();
  @override
  void initState() {
    super.initState();
    if (apiController.retraitHistoryData.isEmpty) {
      apiController.retraitHistory();
    }
    // Écoute la reconnexion
    final networkController = Get.find<NetworkController>();
    networkController.onReconnect = () {
      // Actualise automatiquement les données quand la connexion revient
      apiController.retraitHistory();
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Historique des retraits',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: recherche,
                      style: TextStyle(fontSize: 13.sp),
                      decoration: InputDecoration(
                        label: Text(
                          "Recherche",
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        hintText: "Rechercher une transaction",
                        hintStyle: TextStyle(fontSize: 12.sp),
                        suffixIcon: Icon(
                          Icons.search,
                          color: AppColors.primary,
                          size: 22.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onChanged: searchItem,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextFormField(
                      controller: filter,
                      readOnly: true,
                      style: TextStyle(fontSize: 13.sp),
                      decoration: InputDecoration(
                        label: Text(
                          "Filtrer par date",
                          style: TextStyle(
                            fontSize: 12.sp,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black54,
                          ),
                        ),
                        hintText: "Filtrer par date ou client",
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                        suffixIcon: Icon(
                          Icons.filter_alt,
                          color: AppColors.primary,
                          size: 22.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.r),
                            ),
                          ),
                          isScrollControlled: true,
                          builder: (_) => RetraitFilterSheet(context: context),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Obx(() {
                  if (apiController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (apiController.retraitHistoryData.isEmpty) {
                    return Center(
                      child: Text(
                        'Aucun historique disponible.',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    );
                  }
                  if (apiController.filteredRetraitHistoryData.isEmpty) {
                    return Center(
                      child: Text(
                        'Aucun correspondance pour ces filtres.',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: apiController.filteredRetraitHistoryData.length,
                    itemBuilder: (context, index) {
                      final retrait =
                          apiController.filteredRetraitHistoryData[index];
                      final int totalProduits = retrait.produits.fold(
                        0,
                        (sum, p) => sum + p.qte,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0 ||
                              retrait.date.month !=
                                  apiController
                                      .retraitHistoryData[index - 1]
                                      .date
                                      .month)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 16.sp,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    DateFormat(
                                      'MMMM yyyy',
                                      'fr_FR',
                                    ).format(retrait.date),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          TransactionItemWidget(
                            onPressed: (){
                              showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.r),
                              ),
                            ),
                            builder:
                                (_) => RetraitDetailsSheet(retrait: retrait),
                          );
                            },
                            retrait: retrait,
                            totalProduits: totalProduits,
                          ),
                          
                        ],
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void searchItem(String query) {
    final input = query.toLowerCase();

    if (input.isEmpty) {
      apiController.filteredRetraitHistoryData.assignAll(
        apiController.retraitHistoryData,
      );
      return;
    }

    final suggestion =
        apiController.retraitHistoryData.where((retrait) {
          final identifier = retrait.pdi.identifier.toLowerCase();
          final clientName = retrait.clientName.toLowerCase();
          final date =
              DateFormat('dd/MM/yyyy').format(retrait.date).toLowerCase();
          return identifier.contains(input) ||
              clientName.contains(input) ||
              date.contains(input);
        }).toList();

    apiController.filteredRetraitHistoryData.assignAll(suggestion);
  }
}
