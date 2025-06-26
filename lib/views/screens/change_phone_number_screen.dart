import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/api/controllers/api_controller.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_bottom_sheet.dart';
import 'package:pdi_deme/views/widget/custom_otp_field.dart';
import 'package:pdi_deme/views/widget/custom_text_field.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController newPhoneController = TextEditingController();
  final TextEditingController confirmPhoneController = TextEditingController();
  final ApiController apiController = Get.find<ApiController>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      CustomBottomSheet.show(
        context: context,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomOtpField(
                text:
                    'Veuillez entrer le code OTP réçu sur le  +22${newPhoneController.text}',
                numberOfFields: 6,
                onCodeChanged: (String code) {
                  // Logique de validation du code ici
                },
                onSubmit: (code) {
                  Get.offAllNamed(
                    AppRoutes.successPage,
                    arguments: {
                      'title': 'Modification numéro',
                      'message': 'Numéro modifié avec succès !',
                      'nextRoute': AppRoutes.bottom,
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    newPhoneController.dispose();
    confirmPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String action = Get.arguments as String;
    bool isForPhoneChange() => action != 'reset';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isForPhoneChange() ? "Changer le numéro" : "Réinitialiser le numéro",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Icon(
                  Icons.phone_android,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Entrer le nouveau numéro",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),

              CustomTextField(
                controller: newPhoneController,
                label: 'Nouveau numéro',
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
              const SizedBox(height: 16),
              CustomTextField(
                label: "Confirmer le numéro",
                controller: confirmPhoneController,
                keyboardType: TextInputType.phone,
                maxLength: 8,
                regexPattern: r'^\d{8}$',
                validationMessage:
                    'Veuillez entrer un numéro de téléphone valide.',
                hint: '56 78 90 12',
                validator: (p0) {
                  final phone1 = newPhoneController.text.trim();
                  final phone2 = confirmPhoneController.text.trim();
                  if (phone1 != phone2) {
                    return "Les numéros ne correspondent pas.";
                  }
                  return null;
                },

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

              const SizedBox(height: 32),
              Obx(
                () => CustomElevatedButton(
                  label: isForPhoneChange() ? 'Changer' : 'Réinitialiser',
                  isLoading: apiController.isLoading.value,
                  onPressed: _submit,
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
