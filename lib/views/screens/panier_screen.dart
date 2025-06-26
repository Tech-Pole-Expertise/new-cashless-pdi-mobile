import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pdi_deme/api/models/panier_model.dart';
import 'package:pdi_deme/api/models/pdi_model.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';

class PanierScreen extends StatefulWidget {
  const PanierScreen({super.key});

  @override
  State<PanierScreen> createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen> {
  bool isLoading = true;
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  List<PanierProduitModel> panierProduits = [];

  PdiModel? pdi;

  @override
  void initState() {
    final args = Get.arguments;
    panierProduits = args['possessions'] as List<PanierProduitModel>;
    pdi = args['pdi'] as PdiModel?;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier disponible'),
        leading: const BackButton(),
      ),
      body:
          panierProduits.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_grocery_store_outlined,
                      size: 50,
                      color: AppColors.error,
                    ),
                    Text('Aucun produit dans le panier'),
                    SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomElevatedButton(
                        label: "Retour",
                        onPressed: () {
                          Get.back();
                        },
                        backgroundColor: AppColors.error,
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          (pdi?.photoUrl != null &&
                                  pdi!.photoUrl.toString().isNotEmpty)
                              ? NetworkImage(pdi!.photoUrl.toString())
                              : const AssetImage(
                                    'assets/img/defaut_profil.jpeg',
                                  )
                                  as ImageProvider,
                    ),
                  ),

                  const SizedBox(height: 16),
                  _buildTableHeader(),
                  Form(
                    key: key,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Expanded(
                      child: ListView.builder(
                        itemCount: panierProduits.length,
                        itemBuilder: (context, index) {
                          final produit = panierProduits[index];

                          return Container(
                            color:
                                produit.isSelected ? Colors.blue.shade50 : null,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: produit.isSelected,
                                  onChanged: (val) {
                                    setState(() {
                                      produit.isSelected = val!;
                                      if (!val) {
                                        produit.retrait = '';
                                      }
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    '${produit.label} de ${produit.poids}',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(produit.quantite.toString()),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    enabled: produit.isSelected,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) => produit.retrait = val,
                                    controller: TextEditingController(
                                      text:
                                          produit.retrait.isNotEmpty
                                              ? produit.retrait
                                              : '0',
                                    ),
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Quantité invalide';
                                      }
                                      final quantity = int.tryParse(val);
                                      if (quantity == null || quantity < 0) {
                                        return 'Quantité invalide';
                                      }
                                      if (quantity > produit.quantite) {
                                        return 'Quantité invalide';
                                      }
                                      return null;
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomElevatedButton(
                      label: "Voir le récapitulatif",
                      onPressed: () {
                        if (!key.currentState!.validate()) {
                          return;
                        }
                        Logger().d(
                          'Mes infos : produits : ${panierProduits.where((p) => p.isSelected).toList()} et identifier : ${pdi!.identifier}',
                        );
                        Get.toNamed(
                          AppRoutes.recapPanier,
                          arguments: {
                            'produits':
                                panierProduits
                                    .where((p) => p.isSelected)
                                    .toList(),
                            'identifier': pdi!.identifier,
                          },
                        );
                      },
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: const [
          Text("Choisir", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              "Libellé du produits",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Text("Quantité", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 16),
          Text("Retrait", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
