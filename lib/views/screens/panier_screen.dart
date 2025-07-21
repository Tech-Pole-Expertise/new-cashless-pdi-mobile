import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
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
        setState(() {
          errorMessage =
              '❗ Le champ retrait du produit "${produit.label}" est vide.';
        });
        return false;
      }

      if (quantity == null || quantity < 1) {
        setState(() {
          errorMessage =
              '❗ La quantité du produit "${produit.label}" doit être supérieure à zéro.';
        });
        return false;
      }

      if (quantity > produit.quantite) {
        setState(() {
          errorMessage =
              '❗ La quantité demandée pour "${produit.label}" dépasse le stock disponible (${produit.quantite}).';
        });
        return false;
      }
    }

    setState(() {
      errorMessage = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final ApiController apiController = Get.find<ApiController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: CustomAppBar(
          title: 'Panier disponible',
          onBack: () {
            Get.offAllNamed(AppRoutes.bottom);
          },
        ),
      ),
      body:
          panierProduits.isEmpty
              ? EmptyPanierScreen(pdi: pdi!)
              : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          '${pdi!.firstname.toUpperCase()} ${pdi!.lastname}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'N°${pdi!.identifier}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Expanded(
                    child: ListView.builder(
                      itemCount: panierProduits.length,
                      itemBuilder: (context, index) {
                        final produit = panierProduits[index];
                        int currentQty = int.tryParse(produit.retrait) ?? 0;

                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Image.asset(
                                    'assets/img/fruit.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${produit.label} (${produit.poids})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                              ),
                              subtitle: Text(
                                'Quantité totale : ${produit.quantite}',
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
                                  const SizedBox(width: 8),
                                  Text(
                                    '$currentQty',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
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
                            const Divider(height: 1),
                          ],
                        );
                      },
                    ),
                  ),
                  if (errorMessage != null && errorMessage!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() {
                      return CustomElevatedButton(
                        label:
                            apiController.isLoading.value
                                ? "Traitement en cours..."
                                : "Confirmer le retrait",
                        labelColor: Colors.yellow,
                        onPressed:
                            apiController.isLoading.value
                                ? null
                                : () async {
                                  if (!validatePanier()) return;

                                  final List<PanierProduitModel> selection =
                                      panierProduits
                                          .where((p) => p.isSelected)
                                          .toList();

                                  final retraitList =
                                      selection
                                          .map(
                                            (produit) =>
                                                produit.toRetraitModel(),
                                          )
                                          .toList();

                                  Logger().d({
                                    'phone':
                                        '+226${pdi!.phone.replaceAll(' ', '')}',
                                    'produits':
                                        retraitList
                                            .map((r) => r.toJson())
                                            .toList(),
                                  });

                                  await apiController.initWithdraw({
                                    'phone': pdi!.phone,
                                    'produits':
                                        retraitList
                                            .map((r) => r.toJson())
                                            .toList(),
                                  });
                                },
                        backgroundColor: AppColors.primary,
                      );
                    }),
                  ),
                ],
              ),
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isEnabled,
  }) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isEnabled ? Colors.green.shade100 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          child: Icon(icon, size: 20, color: Colors.black),
        ),
      ),
    );
  }
}
