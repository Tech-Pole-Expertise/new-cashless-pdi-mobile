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
      body: SafeArea(
        child: Column(
          children: [
            // Champs de recherche et filtre
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
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
                        label: Text("Filter"),
                        hintText: "Filter vos transactions",
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 6.0,
                      ),
                      child: GestureDetector(
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

                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryLight,
                                          border: Border.all(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: const Icon(
                                          Icons.shopping_cart,
                                          size: 18,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            retrait.clientName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "N° ${retrait.pdi.identifier}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Quantité",
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
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
