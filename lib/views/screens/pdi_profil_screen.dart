import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:pdi_deme/api/models/pdi_model.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/elevated_button_with_icons.dart';

class PdiProfileScreen extends StatelessWidget {
  const PdiProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PdiModel pdiModel = Get.arguments as PdiModel;
    return Scaffold(
      appBar: AppBar(title: Text('Informations du profil'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 196,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          'Profil trouvé',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            (pdiModel.photoUrl != null &&
                                    pdiModel.photoUrl!.isNotEmpty)
                                ? NetworkImage(pdiModel.photoUrl!)
                                : const AssetImage(
                                      'assets/img/defaut_profil.jpeg',
                                    )
                                    as ImageProvider,
                      ),
                    ),

                    Text(
                      '${pdiModel.firstname} ${pdiModel.lastname.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '+226 ${pdiModel.phone}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              /// SECTION : Statistiques
              /// SECTION : Statistiques
              Column(
                children: [
                  _buildInfoRow(
                    label1: 'Nom',
                    value1: pdiModel.lastname.toUpperCase(),
                    label2: 'Prénom',
                    value2: pdiModel.firstname,
                  ),
                  _buildInfoRow(
                    label1: 'Centre',
                    value1: pdiModel.userInfos.centre!,
                    label2: 'Sexe',
                    value2: pdiModel.userInfos.gender!,
                  ),
                  _buildInfoRow(
                    label1: 'Type de document',
                    value1: pdiModel.userInfos.docType!,
                    label2: 'No Document',
                    value2: pdiModel.userInfos.docNumber!,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: CustomElevatedButonWithIcons(
            onPressed: () {
              Logger().i('possessions: ${pdiModel.possessions}');
              Get.toNamed(
                AppRoutes.panier,
                arguments: {
                  'possessions': pdiModel.possessions,
                  'pdi': pdiModel,
                }, // Passer le modèle PDI
                // Passer la liste des produits sélectionnés
              );
            },
            backgroundColor: AppColors.primary,
            label: 'Voir son panier',
            icon: Icons.shopping_cart_outlined,
          ),
        ),
      ),
    );
  }

  /// Une ligne avec deux éléments info (Nom + Prénom, etc.)
  Widget _buildInfoRow({
    required String label1,
    required String value1,
    required String label2,
    required String value2,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _buildInfoItem(label: label1, value: value1)),
          SizedBox(width: 16),
          Expanded(child: _buildInfoItem(label: label2, value: value2)),
        ],
      ),
    );
  }

  /// Un élément info (label au-dessus, valeur en dessous)
  Widget _buildInfoItem({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondary)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
