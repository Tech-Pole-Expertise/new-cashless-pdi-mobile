import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_otp_field.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vérification OTP'), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 24),

          CustomOtpField(
            text: 'Veuillez entrer le code OTP réçu sur le :',
            numberOfFields: 6,
            onCodeChanged: (String code) {},
            onSubmit: (code) => Get.offAllNamed(AppRoutes.retraitSuccess),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(14),
            child: SizedBox(
              width: Get.width,
              child: CustomElevatedButton(
                label: 'Valider',
                onPressed: () {
                  Get.offAllNamed(AppRoutes.retraitSuccess);
                },
                backgroundColor: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
