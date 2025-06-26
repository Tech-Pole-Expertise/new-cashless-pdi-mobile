import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pdi_deme/api/controllers/api_controller.dart';
import 'package:pdi_deme/api/models/panier_model.dart';
import 'package:pdi_deme/api/models/retrait_product_model.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/views/widget/elevated_button_with_icons.dart';

class RecapitulatifScreen extends StatelessWidget {
  const RecapitulatifScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiController apiController = Get.find<ApiController>();

    final args = Get.arguments;
    final List<PanierProduitModel> produitsSelectionnes =
        args['produits'] ?? []; // Récupération avec GetX
    final identifier = args['identifier'];
    final int totalRetrait = produitsSelectionnes.fold(
      0,
      (somme, item) =>
          somme + int.tryParse(item.retrait)!.clamp(0, item.quantite),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Récapitulatif du panier')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Récapitulatif des produits pour le retrait",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: produitsSelectionnes.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final produit = produitsSelectionnes[index];
                  return ListTile(
                    title: Text('${produit.label} de ${produit.poids}'),
                    subtitle: Text("Quantité initiale : ${produit.quantite}"),
                    trailing: Text(
                      "Retrait : ${produit.retrait}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total à retirer :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$totalRetrait unités",
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButonWithIcons(
                backgroundColor: AppColors.primary,
                label: "Valider le retrait",
                icon: Icons.check_circle,
                onPressed: () {
                  List<RetraitProductModel> retraitList =
                      produitsSelectionnes
                          .map((produit) => produit.toRetraitModel())
                          .toList();
                  Logger().d('Produits : ${retraitList.first.toJson()}');
                  apiController.initWithdraw({
                    'identifier': identifier,
                    'produits': retraitList,
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => Get.back(),
                child: const Text("Retour au panier"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
