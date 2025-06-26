import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/views/widget/elevated_button_with_icons.dart';

class ApiErrorScreen extends StatelessWidget {
  const ApiErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;

    final String title = args?['title'] ?? 'Erreur API';
    final String message = args?['message'] ?? 'Une erreur inattendue est survenue.';
    final VoidCallback? onRetry = args?['onRetry']; // optionnel

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off,
                color: AppColors.error,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButonWithIcons(
                  backgroundColor: AppColors.error,
                  label: onRetry != null ? "Réessayer" : "Retour",
                  icon: onRetry != null ? Icons.refresh : Icons.arrow_back,
                  onPressed: () {
                    if (onRetry != null) {
                      onRetry();
                    } else {
                      Get.back();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
