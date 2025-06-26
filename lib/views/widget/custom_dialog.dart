import 'package:flutter/material.dart';
import 'package:pdi_deme/constant/app_color.dart';
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
            Row(
              children: [
                CustomElevatedButonWithIcons(
                  backgroundColor: AppColors.primary,
                  label: 'Annuler',
                  icon: Icons.keyboard_return,
                  onPressed: onCancel,
                ),
                CustomElevatedButonWithIcons(
                  backgroundColor: AppColors.error,
                  label: 'Confirmer',
                  icon: Icons.logout,
                  onPressed: onConfirm,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
