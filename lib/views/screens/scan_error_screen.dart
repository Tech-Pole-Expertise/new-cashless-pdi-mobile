import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/views/widget/elevated_button_with_icons.dart';

class ErrorScanScreen extends StatelessWidget {
  const ErrorScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color.fromARGB(234, 244, 67, 54),
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                "Erreur lors du scan",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                args?['message'] ?? 'Une erreur inconnue est survenue.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButonWithIcons(
                  backgroundColor: AppColors.error,
                  label: "Revenir au scan",
                  icon: Icons.qr_code_scanner,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              // ElevatedButton.icon(
              //   onPressed: () => Get.back(),
              //   icon: const Icon(Icons.qr_code_scanner),
              //   label: const Text("Revenir au scan"),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.red,
              //     minimumSize: const Size.fromHeight(48),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
