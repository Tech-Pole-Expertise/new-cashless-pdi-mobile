import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/api/controllers/api_controller.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_bottom_sheet.dart';
import 'package:pdi_deme/views/widget/custom_otp_field.dart';
import 'package:pdi_deme/views/widget/custom_text_field.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiController apiController = Get.find<ApiController>();

  @override
  Widget build(BuildContext context) {
    Future<void> onSubmit() async {
      final request = await apiController.initPasswordReset({
        "phone": "+226${phoneController.text}",
      });
      if (request) {
        CustomBottomSheet.show(
          context: context,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomOtpField(
                  text:
                      'Veuillez entrer le code OTP réçu sur le  +22${phoneController.text}',
                  numberOfFields: 6,
                  onCodeChanged: (String code) {
                    // Logique de validation du code ici
                  },
                  onSubmit: (code) {
                    Get.toNamed(AppRoutes.changePassword, arguments: 'reset');
                  },
                ),
              ],
            ),
          ),
        );
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/img/users.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withAlpha((0.8 * 255).toInt()),
                            AppColors.primary.withAlpha((0.2 * 255).toInt()),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 32.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(height: 40),
                          Text(
                            'Bienvenue sur\nCashless !',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'SIMPLE ET RAPIDE',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Partie formulaire scrollable
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mot de passe oublié',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      'Entrez votre numéro pour continuer.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: phoneController,
                      label: 'Numéro de téléphone',
                      maxLength: 8,
                      hint: '56 78 90 12',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/img/drapeau.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                          const Text(
                            '+226',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    Obx(
                      () => CustomElevatedButton(
                        isLoading: apiController.isLoading.value,
                        label: 'Vérifier le numéro',
                        onPressed: () {
                          onSubmit();
                        },
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          'Retourner sur la connexion',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
