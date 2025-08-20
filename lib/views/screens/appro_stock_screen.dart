import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/api/controllers/network_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/appro_bottom_sheet.dart';

class StockAndApproView extends StatefulWidget {
  const StockAndApproView({super.key});

  @override
  State<StockAndApproView> createState() => _StockAndApproViewState();
}

class _StockAndApproViewState extends State<StockAndApproView> {
  List<bool> isSelected = [true, false];
  final ApiController apiController = Get.find<ApiController>();
  final TextEditingController recherche = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(apiController.marchandFilteredStocks.isEmpty) {
      apiController.getMarchandStock();
      
    }
    if(apiController.marchandFilteredAppro.isEmpty) {
      apiController.getMarchandAppro();
    }
     // Écoute la reconnexion
  final networkController = Get.find<NetworkController>();
  networkController.onReconnect = () {
    // Actualise automatiquement les données quand la connexion revient
    apiController.getMarchandStock();
    apiController.getMarchandAppro();
  };
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Gestion du stock',
          style: TextStyle(
            fontSize: 20.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Container(
                height: 60.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(2, (index) {
                    final bool selected = isSelected[index];
                    final String label =
                        index == 0 ? 'Stock disponible' : 'Approvisionnements';

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = i == index;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 150.w,
                        height: 45.h,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color:
                              selected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: FittedBox(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color:
                                  selected
                                      ? Colors.yellow
                                      : Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: recherche,
                decoration: InputDecoration(
                  label: Text("Recherche", style: TextStyle(fontSize: 14.sp)),
                  hintText: "Rechercher une opération",
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
              SizedBox(height: 12.h),
              Obx(() {
                if (apiController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox.shrink();
              }),
              SizedBox(height: 12.h),
              Expanded(
                child: Obx(() {
                  return isSelected[0] ? _buildStockList() : _buildApproList();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockList() {
    if (apiController.marchandFilteredStocks.isEmpty) {
      return Center(
        child: Text(
          'Aucun produit en stock.',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: apiController.marchandFilteredStocks.length,
      itemBuilder: (context, index) {
        final stock = apiController.marchandFilteredStocks[index];

        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 4.h,
              ),
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.w),
                  child: Image.asset(
                    'assets/img/fruit.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              title: Text(
                '${stock.label} (${stock.poids})',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              subtitle: Text(
                'Code: ${stock.code}',
                style: TextStyle(fontSize: 12.sp),
              ),
              trailing: Text(
                'Qté dispo : ${stock.qtePhysique}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
            Divider(height: 1.h),
          ],
        );
      },
    );
  }

  Widget _buildApproList() {
    if (apiController.marchandFilteredAppro.isEmpty) {
      return Center(
        child: Text(
          'Aucun approvisionnement trouvé.',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: apiController.marchandFilteredAppro.length,
      itemBuilder: (context, index) {
        final appro = apiController.marchandFilteredAppro[index];
        final int totalQte = appro.produits.fold(
          0,
          (sum, produit) => sum + produit.qte,
        );

        return InkWell(
          onTap: () {
            appro.produits.isEmpty
                ? Get.snackbar(
                  'Info',
                  'Aucun détail disponible',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.white,
                  icon: Icon(Icons.info, color: AppColors.primary),
                  colorText: AppColors.textPrimary,
                )
                : Get.bottomSheet(
                  ApproBottomSheetDetailsSheet(produits: appro.produits),
                  isScrollControlled: false,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                  ),
                );
          },
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 4.h,
                ),
                leading: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withAlpha(100),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryLight),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(6.w),
                    child: Icon(
                      Icons.local_shipping,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),
                ),
                title: Text(
                  'Approvisionnement',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                subtitle: Text(
                  'Reçu le : ${DateFormat('dd/MM/yyyy').format(appro.date)} à ${DateFormat('HH:mm').format(appro.date)}',
                  style: TextStyle(fontSize: 12.sp),
                ),
                trailing: Text(
                  'Qté total : $totalQte',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              Divider(height: 1.h),
            ],
          ),
        );
      },
    );
  }

  void searchItem(String query) {
    final input = query.toLowerCase();
    if (input.isEmpty) {
      apiController.marchandFilteredAppro.assignAll(
        apiController.marchandAppro,
      );
      apiController.marchandFilteredStocks.assignAll(
        apiController.marchandStocks,
      );
      return;
    }
    if (isSelected[0]) {
      _filterStock(input);
    } else {
      _filterAppro(input);
    }
  }

  void _filterStock(String input) {
    final filtered =
        apiController.marchandStocks.where((stock) {
          final label = stock.label.toLowerCase();
          final code = stock.code.toLowerCase();
          final poids = stock.poids.toLowerCase();
          final qte = stock.qtePhysique.toString().toLowerCase();
          return label.contains(input) ||
              code.contains(input) ||
              poids.contains(input) ||
              qte.contains(input);
        }).toList();

    apiController.marchandFilteredStocks.assignAll(filtered);
  }

  void _filterAppro(String input) {
    final query = input.toLowerCase();
    final filtered =
        apiController.marchandAppro.where((appro) {
          final formattedDate =
              DateFormat(
                'dd MMM yyyy à HH:mm',
              ).format(appro.date).toLowerCase();
          final matchDate = formattedDate.contains(query);
          final matchProduit = appro.produits.any(
            (produit) =>
                produit.produit.toLowerCase().contains(query) ||
                produit.qte.toString().toLowerCase().contains(query) ||
                produit.poids.toLowerCase().contains(query),
          );
          return matchDate || matchProduit;
        }).toList();

    apiController.marchandFilteredAppro.assignAll(filtered);
  }
}
