import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pdi_deme/api/controllers/api_controller.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_text_field.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final ApiController apiController = Get.put(ApiController());
  @override
  Widget build(BuildContext context) {
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
                child: Form(
                  key: formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Authentification',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        'Entrez vos identifiants pour vous connecter.',
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
                        regexPattern: r'^\d{8}$',
                        validationMessage:
                            'Veuillez entrer un numéro de téléphone valide.',
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

                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: passwordController,
                        label: 'Mot de passe',
                        maxLength: 12,

                        // regexPattern: r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
                        // validationMessage: 'Le mot de passe doit contenir au moins 8 caractères, une lettre et un chiffre.',
                        isPassword: true,
                        hint: 'Entrez votre mot de passe',
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.forgotPassword);
                          },
                          child: const Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Obx(
                        () => CustomElevatedButton(
                          label: 'Se connecter',
                          isLoading: apiController.isLoading.value,
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              Logger().d(
                                'phone:' '+226${phoneController.text}',
                              );
                              apiController.login({
                                'username': '+226${phoneController.text}',
                                'password': passwordController.text,
                              });
                            }
                          },
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
