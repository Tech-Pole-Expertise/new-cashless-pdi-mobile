import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/models/marchand_appro_model.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class ApproBottomSheetDetailsSheet extends StatelessWidget {
  final List<ProduitAppro> produits;

  const ApproBottomSheetDetailsSheet({super.key, required this.produits});

  @override
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Titre fixe (hors scroll)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha((255 * 0.1).toInt()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Détails de l\'approvisionnement',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Contenu scrollable
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...produits.map((produit) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Image.asset('assets/img/fruit.png'),
                          title: Text(produit.produit),
                          subtitle: Text('Poids: ${produit.poids}'),
                          trailing: Text(
                            '+${produit.qte}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // ✅ Bouton en bas
                    CustomElevatedButton(
                      label: 'Fermer',
                      onPressed: () => Get.back(),
                      backgroundColor: AppColors.primary,
                      labelColor: Colors.yellow,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
