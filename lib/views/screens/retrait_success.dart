import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';

class RetraitSuccessScreen extends StatelessWidget {
  const RetraitSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final message = Get.arguments ?? "Retrait effectué avec succès !";

    return Scaffold(
      backgroundColor: const Color(0xFF004D40),
      // ton appbar avec profil
      // Vert foncé
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Bouton retour
              const SizedBox(height: 8),
        
              // Logo centré (remplace par ton image si nécessaire)
              Center(
                child: Image.asset(
                  'assets/img/logo.png', // ✅ à adapter selon ton asset
                ),
              ),
        
              // Icône check
              const Icon(
                Icons.check_circle,
                color: Color(0xFFCCFF00), // vert clair fluo
                size: 100,
              ),
              const SizedBox(height: 24),
        
              // Message principal
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
        
              // Bouton en bas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    label: "Retourner sur accueil",
                    labelColor: AppColors.primary,
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.bottom);
                    },
                    backgroundColor: const Color(0xFFE0F2F1),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
