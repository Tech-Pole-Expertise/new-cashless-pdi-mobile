import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/elevated_button_with_icons.dart';

class RetraitSuccessScreen extends StatelessWidget {
  const RetraitSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.success, // ou Colors.green
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                "Retrait effectué avec succès",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Vous pouvez consulter le récapitulatif dans votre historique.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: CustomElevatedButonWithIcons(backgroundColor: AppColors.primary, label: "Retour à l'accueil", icon: Icons.home, onPressed:(){
                  Get.offAllNamed(AppRoutes.bottom);
                }),
              ),
      
            ],
          ),
        ),
      ),
    );
  }
}
