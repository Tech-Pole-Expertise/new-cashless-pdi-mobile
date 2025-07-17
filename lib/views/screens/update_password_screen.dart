import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/custom_app_bar.dart';
import 'package:pv_deme/views/widget/custom_text_field.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() =>
      _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController newPasswordConfirm = TextEditingController();
  final ApiController apiController = Get.find<ApiController>();

  int step = 0;

  void goToNextStep() {
    setState(() {
      step = 1;
    });
  }

  void submitPasswordChange() {
    if (formKey.currentState!.validate()) {
      apiController.initPasswordChange({
        "old_password": currentPassword.text,
        "new_password": newPassword.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: 'Changer de mot de passe'),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,

              child: Column(
                children: [
                  const Icon(Icons.lock_outline, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    step == 0
                        ? 'Vérification du mot de passe'
                        : 'Nouveau mot de passe',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step == 0
                        ? 'Veuillez entrer votre mot de passe actuel pour continuer.'
                        : 'Entrez et confirmez votre nouveau mot de passe.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Étape 1 : mot de passe actuel
                  if (step == 0) ...[
                    CustomTextField(
                      label: 'Mot de passe actuel',
                      controller: currentPassword,
                      isPassword: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Le mot de passe actuel est requis';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    Obx(
                      () => CustomElevatedButton(
                        isLoading: apiController.isLoading.value,
                        label: 'Continuer',
                        labelColor: Colors.yellow,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            goToNextStep();
                          }
                        },
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ],

                  // Étape 2 : nouveau mot de passe
                  if (step == 1) ...[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        children: [
                          CustomTextField(
                            label: 'Nouveau mot de passe',
                            hint: 'Nouveau mot de passe',
                            controller: newPassword,
                            isPassword: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Le nouveau mot de passe est requis';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: 'Confirmation du nouveau mot de passe',
                            hint: 'Confirmation du mot de passe',
                            controller: newPasswordConfirm,
                            isPassword: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'La confirmation est requise';
                              }
                              if (value != newPassword.text) {
                                return 'Les mots de passe ne correspondent pas';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          Obx(
                            () => CustomElevatedButton(
                              isLoading: apiController.isLoading.value,
                              label: 'Valider',
                              labelColor: Colors.yellow,
                              onPressed: submitPasswordChange,
                              backgroundColor: AppColors.primary,
                            ),
                          ),
                          step == 1
                              ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      step = 0;
                                    });
                                  },
                                  child: Text('Précedent'),
                                ),
                              )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
