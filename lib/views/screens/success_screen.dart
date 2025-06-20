import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/views/widget/elevated_button_with_icons.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String title = args['title'] ?? "Succès !";
    final String message = args['message'] ?? "Opération effectuée avec succès.";
    final IconData icon = args['icon'] ?? Icons.check_circle_outline;
    final String? nextRoute = args['nextRoute']; // facultatif

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primary, size: 100),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              CustomElevatedButonWithIcons(
                backgroundColor: AppColors.primary,
                label: 'Continuer',
                icon: Icons.arrow_forward,
                onPressed: () {
                  if (nextRoute != null) {
                    Get.offAllNamed(nextRoute);
                  } else {
                    Get.back(); // ou Get.offAllNamed('/') si besoin
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
