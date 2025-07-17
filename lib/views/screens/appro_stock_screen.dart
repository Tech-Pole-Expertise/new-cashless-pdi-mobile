import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';

class StockAndApproView extends StatefulWidget {
  const StockAndApproView({super.key});

  @override
  State<StockAndApproView> createState() => _StockAndApproViewState();
}

class _StockAndApproViewState extends State<StockAndApproView> {
  List<bool> isSelected = [true, false]; // Stock = index 0, Appro = index 1
  final ApiController apiController = Get.find<ApiController>();
  @override
  void initState() {
    super.initState();
    apiController.getMarchandStock();
    apiController.getMarchandAppro();
  }

  @override
  Widget build(BuildContext context) {
    // final merchantController = Get.find<MerchantController>();
    // final merchant = merchantController.merchant.value;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(
          'Stock/Approvisionnement',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// Header personnalisé avec photo + infos
              const SizedBox(height: 20),

              // Text(
              //   'Consultez ici votre stock actuel ou vos derniers approvisionnements enregistrés.',
              //   style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
              // ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight, // fond vert clair
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(2, (index) {
                      final bool selected = isSelected[index];
                      final String label =
                          index == 0
                              ? 'Stock disponible'
                              : 'Approvisionnements';

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
                          width: 150,
                          height: 45,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            color:
                                selected
                                    ? AppColors.primary
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Coins légèrement arrondis
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color:
                                  selected
                                      ? Colors.yellow
                                      : Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// Loader
              Obx(() {
                if (apiController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox.shrink();
              }),

              const SizedBox(height: 12),

              /// Liste
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
    if (apiController.marchandStocks.isEmpty) {
      return const Center(
        child: Text(
          'Aucun produit en stock.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: apiController.marchandStocks.length,
      itemBuilder: (context, index) {
        final stock = apiController.marchandStocks[index];

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
                '${stock.label} (${stock.poids})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Code: ${stock.code ?? '---'}',
              ), // Utilise stock.code si dispo
              trailing: Text(
                'Qté dispo : ${stock.qtePhysique}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
          ],
        );
      },
    );
  }

  Widget _buildApproList() {
    if (apiController.marchandAppro.isEmpty) {
      return const Center(
        child: Text(
          'Aucun approvisionnement reçu.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: apiController.marchandAppro.length,
      itemBuilder: (context, index) {
        final appro = apiController.marchandAppro[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ExpansionTile(
            leading: const Icon(Icons.local_shipping, color: AppColors.primary),
            title: Text(
              'Reçu le ${DateFormat('dd MMM yyyy à HH:mm').format(appro.date)}',
            ),
            children:
                appro.produits.map((prod) {
                  return ListTile(
                    leading: Image.asset('assets/img/fruit.png'),
                    title: Text(prod.produit),
                    subtitle: Text('Poids: ${prod.poids}'),
                    trailing: Text(
                      '+${prod.qte}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
