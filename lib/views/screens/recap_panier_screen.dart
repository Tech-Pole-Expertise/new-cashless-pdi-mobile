import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/api/models/panier_model.dart';
import 'package:pv_deme/api/models/retrait_product_model.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/custom_app_bar.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class RecapitulatifScreen extends StatelessWidget {
  const RecapitulatifScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiController apiController = Get.find<ApiController>();

    final args = Get.arguments;
    final List<PanierProduitModel> produitsSelectionnes =
        args['produits'] ?? [];
    final identifier = args['identifier'];

    // final int totalRetrait = produitsSelectionnes.fold(
    //   0,
    //   (somme, item) =>
    //       somme + int.tryParse(item.retrait)!.clamp(0, item.quantite),
    // );

    // final merchantController = Get.find<MerchantController>();
    final pdi = apiController.pdiProfile.value;
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: CustomAppBar(title: 'Recapitilatif'), // ton appbar avec profil
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    '${pdi!.firstname.toUpperCase()} ${pdi.lastname}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'N°${pdi.identifier}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              // child: Row(
              //   children: [
              //     CircleAvatar(
              //       radius: 25,
              //       backgroundImage:
              //           (pdi?.photoUrl != null && pdi!.photoUrl!.isNotEmpty)
              //               ? NetworkImage(pdi.photoUrl!)
              //               : const AssetImage('assets/img/pdi.jpeg')
              //                   as ImageProvider,
              //     ),
              //     const SizedBox(width: 16),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           '${pdi!.firstname.toUpperCase()} ${pdi.lastname}',
              //           style: TextStyle(fontSize: 16),
              //         ),
              //         Text(
              //           pdi.identifier,
              //           style: const TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 16,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ),
            const SizedBox(height: 20),

            // Liste
            Expanded(
              child: ListView.separated(
                itemCount: produitsSelectionnes.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final produit = produitsSelectionnes[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            margin: const EdgeInsets.only(right: 12),
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
                          Text(
                            produit.label,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          produit.retrait,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            //  Total
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text(
            //       "Total à retirer :",
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //     ),
            //     Text(
            //       "$totalRetrait unités",
            //       style: const TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.green,
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 20),

            // Bouton principal
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomElevatedButton(
                    label:
                        apiController.isLoading.value
                            ? 'Chargement...'
                            : 'Confirmer le retrait',
                    labelColor: Colors.white,
                    onPressed:
                        apiController.isLoading.value
                            ? null
                            : () {
                              List<RetraitProductModel> retraitList =
                                  produitsSelectionnes
                                      .map(
                                        (produit) => produit.toRetraitModel(),
                                      )
                                      .toList();

                              Logger().d({
                                'identifier': identifier,
                                'produits':
                                    retraitList.map((r) => r.toJson()).toList(),
                              });

                              apiController.initWithdraw({
                                'identifier': identifier,
                                'produits':
                                    retraitList.map((r) => r.toJson()).toList(),
                              });
                            },
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Lien retour
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "Retour au panier",
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
