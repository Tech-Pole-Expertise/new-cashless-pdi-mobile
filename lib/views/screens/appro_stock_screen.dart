import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/appro_bottom_sheet.dart';

class StockAndApproView extends StatefulWidget {
  const StockAndApproView({super.key});

  @override
  State<StockAndApproView> createState() => _StockAndApproViewState();
}

class _StockAndApproViewState extends State<StockAndApproView> {
  List<bool> isSelected = [true, false]; // Stock = index 0, Appro = index 1
  final ApiController apiController = Get.find<ApiController>();
  final TextEditingController recherche = TextEditingController();
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
          'Gestion du stock',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header personnalisé avec photo + infos
              const SizedBox(height: 24),

              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight, // fond vert clair
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
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
                        width: 150,
                        height: 45,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color:
                              selected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // Coins légèrement arrondis
                        ),
                        child: Text(
                          label,
                          softWrap: false, // optionnel mais conseillé ici
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
              SizedBox(height: 12),
              TextFormField(
                controller: recherche,
                decoration: InputDecoration(
                  label: Text("Recherche"),
                  hintText: "Rechercher une opération",
                  suffixIcon: Icon(Icons.search, color: AppColors.primary),
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
    if (apiController.marchandFilteredStocks.isEmpty) {
      return const Center(
        child: Text(
          'Aucun produit en stock.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: apiController.marchandFilteredStocks.length,
      itemBuilder: (context, index) {
        final stock = apiController.marchandFilteredStocks[index];

        return GestureDetector(
          onTap: () {
            Get.snackbar(
              'Info',
              'Auccun détail disponible pour ce stock',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.white,
              icon: const Icon(Icons.info, color: AppColors.primary),
              colorText: AppColors.textPrimary,
            );
          },
          child: Column(
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
                  'Code: ${stock.code}',
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
          ),
        );
      },
    );
  }

  Widget _buildApproList() {
    if (apiController.marchandFilteredAppro.isEmpty) {
      return const Center(
        child: Text(
          'Aucun approvisionnement trouvé.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
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
            Get.bottomSheet(
              ApproBottomSheetDetailsSheet(produits: appro.produits),
              isScrollControlled: false,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            );
          },
          child: Column(
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
                    color: AppColors.primaryLight.withAlpha(100),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryLight),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.local_shipping,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                title: Text(
                  'Approvisionnement',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Reçu le :${DateFormat('dd/MM/yyyy').format(appro.date)}', // Utilise stock.code si disp
                ), // Utilise stock.code si dispo
                trailing: Text(
                  'Qté total : $totalQte',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
            ],
          ),
        );
      },
    );
  }

  String formatDate(DateTime dateToFormat) {
    DateTime date = dateToFormat; // ta date ici

    String jour = DateFormat.EEEE('fr_FR').format(date); // Vendredi
    String jourNum = DateFormat.d('fr_FR').format(date); // 14
    String mois = DateFormat.MMMM('fr_FR').format(date); // juillet
    String heure = DateFormat.H('fr_FR').format(date); // 12
    String minute = DateFormat.m('fr_FR').format(date); // 14

    String texteFinal = 'Reçu le $jour $jourNum $mois à $heure : ${minute}min';
    return texteFinal;
  }

  void searchItem(String query) {
    final input = query.toLowerCase();

    if (input.isEmpty) {
      // Si aucun texte tapé → réinitialiser la liste filtrée
      apiController.marchandFilteredAppro.assignAll(
        apiController.marchandAppro,
      );
      apiController.marchandFilteredStocks.assignAll(
        apiController.marchandStocks,
      );
      return;
    }
    // Filtrer les données en fonction de la saisie
    if (isSelected[0]) {
      // Filtrer pour la liste de stock
      _filterStock(input);
    } else {
      // Filtrer pour la liste d'approvisionnement
      _filterAppro(input);
    }

    // Mettre à jour la liste filtrée
  }

  void _filterStock(String input) {
    final filtered =
        apiController.marchandStocks.where((stock) {
          final stockLabel = stock.label.toLowerCase();
          final stockCode = stock.code.toLowerCase();
          final stockPoids = stock.poids.toLowerCase();
          final stockQte = stock.qtePhysique.toString().toLowerCase();
          return stockLabel.contains(input) ||
              stockCode.contains(input) ||
              stockPoids.contains(input) ||
              stockQte.contains(input);
        }).toList();

    filtered.isNotEmpty
        ? apiController.marchandFilteredStocks.assignAll(filtered)
        : apiController.marchandFilteredStocks.assignAll([]);
  }

  void _filterAppro(String input) {
    final query = input.toLowerCase();

    final filtered =
        apiController.marchandAppro.where((appro) {
          // Vérifie si la date contient le texte recherché
          final formattedDate =
              DateFormat(
                'dd MMM yyyy à HH:mm',
              ).format(appro.date).toLowerCase();

          final matchDate = formattedDate.contains(query);

          // Vérifie si au moins un produit contient le texte recherché
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
