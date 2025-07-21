import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/models/pdi_model.dart';
import 'package:pv_deme/constant/app_color.dart' show AppColors;
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class EmptyPanierScreen extends StatelessWidget {
  final PdiModel pdi;
  const EmptyPanierScreen({super.key, required this.pdi});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  '${pdi.firstname.toUpperCase()} ${pdi.lastname}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'N°${pdi.identifier}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/img/panier-vide.png', height: 150),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Votre panier est vide\n',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'Ouups... Votre panier ne contient aucun produit.\nVeuillez vous approvisionner puis réessayer.',

                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Adjust the image path and size as needed
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomElevatedButton(
              label: 'Retour à l\'accueil',
              onPressed: () {
                Get.offAllNamed(AppRoutes.bottom);
              },
              labelColor: Colors.yellow,
              backgroundColor: AppColors.primary,
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
