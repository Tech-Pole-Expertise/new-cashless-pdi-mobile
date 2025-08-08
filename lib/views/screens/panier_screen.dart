import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/api/models/panier_model.dart';
import 'package:pv_deme/api/models/pdi_model.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/screens/empty_panier_screen.dart';
import 'package:pv_deme/views/widget/custom_app_bar.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class PanierScreen extends StatefulWidget {
  const PanierScreen({super.key});

  @override
  State<PanierScreen> createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  List<PanierProduitModel> panierProduits = [];
  PdiModel? pdi;
  String? errorMessage;

  @override
  void initState() {
    final args = Get.arguments;
    pdi = args['pdi'] as PdiModel?;
    panierProduits = pdi?.possessions ?? [];
    for (var produit in panierProduits) {
      produit.retrait = '0';
    }
    super.initState();
  }

  bool validatePanier() {
    final selection = panierProduits.where((p) => p.isSelected).toList();
    if (selection.isEmpty) {
      setState(() {
        errorMessage = '❗ Veuillez sélectionner au moins un produit.';
      });
      return false;
    }
    for (var produit in selection) {
      final val = produit.retrait;
      final quantity = int.tryParse(val);
      if (val.isEmpty) {
        errorMessage =
            '❗ Le champ retrait du produit "${produit.label}" est vide.';
        return false;
      }
      if (quantity == null || quantity < 1) {
        errorMessage =
            '❗ La quantité du produit "${produit.label}" doit être > 0.';
        return false;
      }
      if (quantity > produit.quantite) {
        errorMessage =
            '❗ La quantité pour "${produit.label}" dépasse le stock disponible (${produit.quantite}).';
        return false;
      }
    }
    errorMessage = null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final ApiController apiController = Get.find<ApiController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.h),
        child: CustomAppBar(
          title: 'Panier disponible',
          onBack: () => Get.offAllNamed(AppRoutes.bottom),
        ),
      ),
      body:
          panierProduits.isEmpty
              ? EmptyPanierScreen(pdi: pdi!)
              : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '${pdi!.firstname.toUpperCase()} ${pdi!.lastname}',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          Text(
                            'N°${pdi!.identifier}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: panierProduits.length,
                        itemBuilder: (context, index) {
                          final produit = panierProduits[index];
                          int currentQty = int.tryParse(produit.retrait) ?? 0;

                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 6.h,
                                horizontal: 12.w,
                              ),
                              leading: Container(
                                width: 40.w,
                                height: 40.w,
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
                                '${produit.label} (${produit.poids})',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                'Quantité totale : ${produit.quantite}',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildQtyButton(
                                    icon: Icons.remove,
                                    onPressed: () {
                                      setState(() {
                                        currentQty--;
                                        produit.retrait = currentQty.toString();
                                        produit.isSelected = currentQty > 0;
                                      });
                                    },
                                    isEnabled: currentQty > 0,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    '$currentQty',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  _buildQtyButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      setState(() {
                                        currentQty++;
                                        produit.retrait = currentQty.toString();
                                        produit.isSelected = currentQty > 0;
                                      });
                                    },
                                    isEnabled: currentQty < produit.quantite,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Obx(() {
                        return CustomElevatedButton(
                          label:
                              apiController.isLoading.value
                                  ? "Traitement en cours..."
                                  : "Confirmer le retrait",
                          labelColor: Colors.yellow,
                          isLoading: apiController.isLoading.value,
                          onPressed:
                              apiController.isLoading.value
                                  ? null
                                  : () async {
                                    if (!validatePanier()) return;
                                    final selection =
                                        panierProduits
                                            .where((p) => p.isSelected)
                                            .toList();
                                    final retraitList =
                                        selection
                                            .map((e) => e.toRetraitModel())
                                            .toList();
                                    await apiController.initWithdraw({
                                      'phone': pdi!.phone,
                                      'produits':
                                          retraitList
                                              .map((e) => e.toJson())
                                              .toList(),
                                    });
                                  },
                          backgroundColor: AppColors.primary,
                        );
                      }),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isEnabled,
  }) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.3,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: isEnabled ? Colors.green.shade100 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          child: Icon(icon, size: 18.sp, color: Colors.black),
        ),
      ),
    );
  }
}
