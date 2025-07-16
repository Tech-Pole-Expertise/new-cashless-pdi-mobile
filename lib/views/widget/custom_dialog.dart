import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';
import 'package:pdi_deme/views/widget/elevated_button_with_icons.dart';

class CustomDialog {
  static void showCustomDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width,
                  child: CustomElevatedButonWithIcons(
                    backgroundColor: AppColors.primary,
                    label: 'Annuler',
                    icon: Icons.keyboard_return,
                    onPressed: onCancel,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: Get.width,
                  child: CustomElevatedButonWithIcons(
                    backgroundColor: AppColors.error,
                    label: 'Confirmer',
                    icon: Icons.logout,
                    onPressed: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static void showError(String title,String message) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title:  Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          CustomElevatedButton(
              label: 'Retour',
              labelColor: Colors.white,
              onPressed: () {
                Get.back();
              },
              backgroundColor: AppColors.error,
            ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
