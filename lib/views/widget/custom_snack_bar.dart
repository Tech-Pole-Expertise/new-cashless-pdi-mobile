import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/constant/app_color.dart';

class CustomSnackBar {

  
  void showError(String title,String message) {
    Get.snackbar(
      title, // Titre
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      isDismissible: true,
      duration: const Duration(seconds: 4),
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

    void showSuccess(String title,String message,) {
    Get.snackbar(
      title, // Titre
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      isDismissible: true,
      duration: const Duration(seconds: 4),
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
