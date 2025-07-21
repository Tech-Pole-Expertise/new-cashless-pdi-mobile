import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pv_deme/api/models/retrait_history_model.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class RetraitDetailsSheet extends StatelessWidget {
  final RetraitHistoryModel retrait;

  const RetraitDetailsSheet({super.key, required this.retrait});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy').format(retrait.date);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// --- Header avec fond vert clair ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha((255 * 0.1).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Détails du retrait',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// --- Infos utilisateur ---
              _infoRow(Icons.person_outline, 'Nom complet', retrait.clientName),
              _infoRow(Icons.phone_outlined, 'Téléphone', retrait.pdi.phone),
              _infoRow(Icons.lock_outline, 'Identifiant', retrait.identifier),
              _infoRow(
                Icons.calendar_today_outlined,
                'Date de la transaction',
                date,
              ),

              const SizedBox(height: 20),

              /// --- Titre panier retiré ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha((255 * 0.1).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Panier retiré',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Produit',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Quantité',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              /// --- Liste des produits ---
              ...retrait.produits.map((prod) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/img/fruit.png',
                        width: 25,
                        height: 25,
                      ),
                      // const Icon(Icons.check_circle, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prod.produit,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Column(children: [Text(prod.qte.toString())]),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 24),

              /// --- Bouton fermer ---
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
    );
  }

  /// Méthode utilitaire pour les lignes info
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
