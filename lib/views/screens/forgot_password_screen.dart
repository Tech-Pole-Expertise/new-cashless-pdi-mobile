import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/custom_text_field.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController phoneController = TextEditingController();
  final ApiController apiController = Get.find<ApiController>();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Future<void> onSubmit() async {
      await apiController.initPasswordReset({
        "phone": "+226${phoneController.text.replaceAll(' ', '')}",
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true, // Important !
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              border: Border.all(color: AppColors.primaryLight),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image pleine largeur et hauteur partielle
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.asset('assets/img/users.png', fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: formKey,
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
                      regexPattern: r'^\d{8}$',
                      validationMessage:
                          'Veuillez entrer un numéro de téléphone valide.',
                      hint: '7X XX XX XX',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(
                        Icons.phone,
                        color: AppColors.textPrimary,
                      ),
                      suffixIcon: null,
                      formatAsPhoneNumber: true,
                      prefix: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '+226',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Obx(
                      () => CustomElevatedButton(
                        isLoading: apiController.isLoading.value,
                        label: 'Vérifier le numéro',
                        labelColor: Colors.yellow,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            onSubmit();
                          }
                        },
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: const Text(
                          'Retourner sur la page de connexion',
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
            ),
          ],
        ),
      ),
    );
  }
}
