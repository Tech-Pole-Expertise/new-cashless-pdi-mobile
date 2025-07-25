import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/retrait_detail_bottom_sheet.dart';
import 'package:pv_deme/views/widget/retrait_filter_sheet.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final TextEditingController recherche = TextEditingController();
  final TextEditingController filter = TextEditingController();
  final ApiController apiController = Get.find<ApiController>();

  @override
  Widget build(BuildContext context) {
    // Charger dès l'ouverture
    apiController.retraitHistory();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Historique des retraits',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: Column(
            children: [
              // Champs de recherche et filtre
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: recherche,
                      decoration: InputDecoration(
                        label: Text("Recherche"),
                        hintText: "Rechercher une transaction",
                        suffixIcon: Icon(
                          Icons.search,
                          color: AppColors.primary,
                        ),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                      onChanged: searchItem,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: filter,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: Text(
                          "Filtrer par date",
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black54,
                          ),
                        ),
                        hintText: "Filtrer par date ou client",
                        hintStyle: TextStyle(
                          // maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black54,
                        ),
                        suffixIcon: Icon(
                          Icons.filter_alt,
                          color: AppColors.primary,
                        ),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                          builder: (_) => const RetraitFilterSheet(),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Liste des historiques
              Expanded(
                child: Obx(() {
                  if (apiController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (apiController.retraitHistoryData.isEmpty) {
                    return const Center(
                      child: Text('Aucun historique disponible.'),
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

                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder:
                                (_) => RetraitDetailsSheet(retrait: retrait),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Affichage du mois si nécessaire
                            if (index == 0 ||
                                retrait.date.month !=
                                    apiController
                                        .retraitHistoryData[index - 1]
                                        .date
                                        .month)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      DateFormat(
                                        'MMMM yyyy',
                                        'fr_FR',
                                      ).format(retrait.date),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Utilisation de ListTile pour le retrait
                            // Calcul de la quantité totale à faire avant (ex. dans ton build)
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primary),
                                  color: AppColors.primaryLight,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                              ),
                              title: Text(
                                retrait.clientName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'N° ${retrait.pdi.identifier}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Qté produits : $totalProduits',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Date du retrait',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(retrait.date),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),

                            // Ligne séparatrice
                            const Divider(color: Colors.black12),
                          ],
                        ),
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
      // Si aucun texte tapé → réinitialiser la liste filtrée
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

    // Mettre à jour la liste filtrée
    apiController.filteredRetraitHistoryData.assignAll(suggestion);
  }
}
