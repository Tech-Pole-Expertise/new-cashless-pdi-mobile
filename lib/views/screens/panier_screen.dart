import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/api/models/panier_model.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';

class PanierScreen extends StatefulWidget {
  const PanierScreen({super.key});

  @override
  State<PanierScreen> createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen> {
  List<PanierProduitModel> panierProduits = Get.arguments ?? [];
  bool isLoading = true;
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier Fayçal KIEMDE'),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/img/pdi-show.png'),
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
                    color: produit.isSelected ? Colors.blue.shade50 : null,
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
                        Expanded(child: Text(produit.libelle)),
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
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
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
                Get.toNamed(
                  AppRoutes.recapPanier,
                  arguments: panierProduits.where((p) => p.isSelected).toList(),
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
