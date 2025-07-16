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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.asset('assets/img/users.png', fit: BoxFit.cover),
              ),

              // Partie formulaire scrollable
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: formkey,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Se connecter',
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
                        regexPattern: r'^\d{8}$',
                        validationMessage:
                            'Veuillez entrer un numéro de téléphone valide.',
                        hint: '7X XX XX XX',
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icon(
                          Icons.phone,
                        ), // facultatif, pour être clair
                        suffixIcon: null,
                        formatAsPhoneNumber: true,

                        // Utilise prefix à la place
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

                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: passwordController,
                        label: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock),
                        // regexPattern: r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
                        // validationMessage: 'Le mot de passe doit contenir au moins 8 caractères, une lettre et un chiffre.',
                        isPassword: true,
                        hint: '********',
                        keyboardType: TextInputType.text,
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
                              decorationColor: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                      Obx(
                        () => CustomElevatedButton(
                          label: 'Se connecter',
                          labelColor: Colors.yellow,
                          isLoading: apiController.isLoading.value,
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              Logger().d(
                                'phone:'
                                '+226${phoneController.text}',
                              );
                              apiController.login({
                                'username':
                                    '+226${phoneController.text.replaceAll(' ', '').trim()}',
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
